#!/usr/bin/env bash
#
# Claude Code hook (PreToolUse on Bash): refuses installs that cannot outlive
# the session.
#
# A hosted session — Claude Code on the web, a CI runner, any container the
# agent did not bring with it — keeps nothing outside the repository. Installing
# an agent capability there buys one conversation and leaves the next session
# without it, while the repository goes on advertising it (SYSTEM.md §4).
#
# Durability is DECLARED, never guessed. A machine whose home directory
# survives says so once:
#
#   touch ~/.chief-of-vibes-durable        # or export COV_DURABLE_HOME=1
#
# With that marker the hook stands aside completely. Without it, every install
# that writes outside the working tree is denied before it runs — the attempt
# itself is what gets prevented, not just the bad outcome, because a
# half-finished install in a disposable container is worse than none: it looks
# like a capability.
#
# What stays allowed, marker or not: repository-scoped installs that land in the
# working tree and can be committed (npm install, bun install, pip install -r),
# and every read-only query.
#
# Two lessons from guard-main.sh are built in. Each command segment is judged on
# its own, so a compound is not one flat haystack. And a segment is judged by
# the PROGRAM IT RUNS, not by the words it contains: `git commit -m "we cannot
# uv tool install here"` runs git, so the install rules never look at it. Verbs
# like install and add are ordinary English, and matching them as substrings
# denies people the ability to talk about the rule while following it.
#
# Like guard-main.sh this is a rail, not a lock: it only runs in sessions that
# wire it, and a determined workaround (a shell script that installs, run by
# name) walks straight past it. The point is to stop the reflex, not to defeat
# an adversary. tools/test-guard-install.sh pins both halves.
#
# Exit 2 makes Claude Code deny the tool call; the reason goes to stderr.
#
# Input: PreToolUse hook JSON on stdin.

set -uo pipefail

input="$(cat)"

# Declared-durable machines are none of this hook's business.
[[ "${COV_DURABLE_HOME:-0}" == "1" ]] && exit 0
[[ -e "${HOME}/.chief-of-vibes-durable" ]] && exit 0

command="$(printf '%s' "${input}" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))' \
  2>/dev/null)" || command=""

cmd="$(printf '%s' "${command}" | tr -d "\"'")"
segments="$(printf '%s' "${cmd}" | sed 's/&&/\n/g; s/||/\n/g' | tr ';|&' '\n')"

# Does the whole command pipe a download into a shell? Judged on the full text,
# since the pipe is exactly what the segment split removes.
pipes_to_shell=0
printf '%s' "${cmd}" | grep -qE '(curl|wget).*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z|k)?sh([[:space:]]|$)' && pipes_to_shell=1

reason=""
while IFS= read -r seg; do
  [[ -z "${seg// }" ]] && continue

  # The program this segment actually runs, past sudo, env, and VAR=value.
  read -r -a words <<< "${seg}"
  prog=""
  for w in "${words[@]}"; do
    case "${w}" in
      sudo|env|command|exec|nohup|time) continue ;;
      *=*) continue ;;
      -*) continue ;;
      *) prog="${w##*/}"; break ;;
    esac
  done
  [[ -z "${prog}" ]] && continue

  # Arguments as one string, for flag and subcommand checks.
  args=" ${seg#*"${prog}"} "

  case "${prog}" in
    uv)
      [[ "${args}" =~ [[:space:]]tool[[:space:]]+install[[:space:]] ]] \
        && reason="installs a tool onto this machine"
      ;;
    uvx)
      [[ "${args}" =~ [[:space:]]--from[[:space:]] ]] \
        && reason="installs a tool onto this machine"
      ;;
    pipx|cargo|gem|go)
      [[ "${args}" =~ [[:space:]]install[[:space:]] ]] \
        && reason="installs a tool onto this machine"
      ;;
    npm|pnpm|yarn|bun)
      # Only the global form. `npm install`, `npm ci`, `npm ls -g` are fine.
      if [[ "${args}" =~ [[:space:]](install|i|add|create)[[:space:]] \
            && "${args}" =~ [[:space:]](-g|--global|--location=global)[[:space:]] ]]; then
        reason="installs a package globally"
      elif [[ "${args}" =~ [[:space:]]global[[:space:]]+add[[:space:]] ]]; then
        reason="installs a package globally"
      fi
      ;;
    pip|pip3)
      # A project venv or an explicit --target is repository-scoped; --user is not.
      [[ "${args}" =~ [[:space:]]install[[:space:]] && "${args}" =~ [[:space:]]--user[[:space:]] ]] \
        && reason="installs into the user site-packages"
      ;;
    apt|apt-get|dnf|yum|zypper|apk|brew)
      [[ "${args}" =~ [[:space:]](install|add)[[:space:]] ]] \
        && reason="installs a system package"
      ;;
    pacman)
      [[ "${args}" =~ [[:space:]]-S([[:space:]]|y|u) ]] \
        && reason="installs a system package"
      ;;
    git|cp|mv|ln|rsync|tar|unzip|mkdir|install)
      # Writing a skill or plugin into an agent directory outside the repository.
      [[ "${args}" =~ (~|\$HOME|/root|/home/[^/[:space:]]+)/\.(claude|codex|factory|config/opencode)(/|[[:space:]]|$) ]] \
        && reason="writes into an agent directory outside the repository"
      ;;
    curl|wget)
      [[ "${pipes_to_shell}" -eq 1 ]] \
        && reason="pipes a downloaded installer into a shell"
      # Writing a download straight into an agent directory counts too.
      [[ "${args}" =~ (~|\$HOME|/root|/home/[^/[:space:]]+)/\.(claude|codex|factory|config/opencode)(/|[[:space:]]|$) ]] \
        && reason="writes into an agent directory outside the repository"
      ;;
  esac

  [[ -n "${reason}" ]] && break
done <<< "${segments}"

if [[ -n "${reason}" ]]; then
  cat >&2 <<EOF
BLOCKED by guard-install.sh: that command ${reason}, and this session's
filesystem does not survive it (SYSTEM.md §4).

Do not retry it, and do not commit a script that promises to run it later. Say
plainly that the install cannot be made durable here, name what is needed and
why, record it in memory/backlog.md under **Principal**, and hand it to a
session running on the Principal's own machine.

If this machine's home directory does persist, declare it once and this guard
stands aside:  touch ~/.chief-of-vibes-durable
EOF
  exit 2
fi

exit 0
