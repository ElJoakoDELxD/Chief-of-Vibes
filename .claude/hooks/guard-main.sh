#!/usr/bin/env bash
#
# Claude Code hook (PreToolUse on Edit|Write|Bash): keeps main read-only.
#   - On main: blocks every edit and shell command.
#   - Elsewhere: blocks git commands that write to, delete, check out, or
#     force-move main: push to any main destination refspec (quoted or not),
#     push --mirror/--all, checkout/switch onto main including -B and -f,
#     branch -f/-D/-m/-M/-C main, worktrees on main, and ref plumbing
#     (update-ref / symbolic-ref) that targets refs/heads/main.
# Exit 2 makes Claude Code deny the tool call; the reason goes to stderr.
#
# A local hook is a rail, not a lock: it only runs in sessions that wire it,
# and string-matching shell commands is never exhaustive. The hard guarantee
# for main is server-side branch protection plus the PR guard (CI); treat this
# hook as defence-in-depth.
#
# It still errs closed where it cannot tell intent from text — a command that
# writes 'git checkout main' into a file, say, reads exactly like the command
# itself. That direction is the safe one. What it must not do is block ordinary
# work: a commit message or an echo that merely mentions the branch is prose,
# not a refspec, and it used to be enough to deny an unrelated push. Segment
# scoping is what separates the two; tools/test-guard-main.sh pins both halves.
#
# Input: PreToolUse hook JSON on stdin.

set -uo pipefail

input="$(cat)"
branch="$(git branch --show-current 2>/dev/null || echo "")"

if [[ "${branch}" == "main" ]]; then
  echo "BLOCKED by guard-main.sh: main is the template, not a workspace. Check out or create an agent branch; template changes go through an approved pull request." >&2
  exit 2
fi

command="$(printf '%s' "${input}" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))' \
  2>/dev/null)" || command=""

# Quotes can hide the ref ("main", 'main'); strip them before matching.
#
# Stripping them also flattens prose into refs: `echo "check main"; git push -u
# origin agent-branch` used to read as a push to main, because the word and the
# push met in one flat string. So the command is split on separators first and
# each segment judged alone — a git invocation lives in exactly one segment, so
# nothing hides across the split, and an echo is no longer evidence about a push.
cmd="$(printf '%s' "${command}" | tr -d "\"'")"
segments="$(printf '%s' "${cmd}" | sed 's/&&/\n/g; s/||/\n/g' | tr ';|&' '\n')"

reason=""
while IFS= read -r seg; do
  # Only inspect git commands; leave everything else alone.
  printf '%s' "${seg}" | grep -qE '(^|[^[:alnum:]_])git([[:space:]]|$)' || continue
  cmd="${seg}"

  # push where main can be the destination, in any refspec form:
  #   main | +main | :main | src:main | refs/heads/main — main must end the
  # token, so 'maintenance', 'main-backup', 'main..HEAD' are not matched.
  if printf '%s' "${cmd}" | grep -qE '(^|[[:space:]])push([[:space:]]|$)' \
     && printf '%s' "${cmd}" | grep -qE '(^|[[:space:]:+/])main([[:space:];&|]|$)'; then
    reason="pushes to main"
  fi

  # push --mirror / --all replicate every ref, main included.
  if printf '%s' "${cmd}" | grep -qE '(^|[[:space:]])push([[:space:]]|$)' \
     && printf '%s' "${cmd}" | grep -qE '(^|[[:space:]])--(mirror|all)([[:space:];&|]|$)'; then
    reason="pushes all refs (main included)"
  fi

  # checkout/switch onto main, with any leading flags (-B, -f, --detach, …).
  # 'checkout -b <new> main' (branching OFF main) and 'checkout main-file'
  # are not matched.
  if printf '%s' "${cmd}" | grep -qE '(checkout|switch)([[:space:]]+-[^[:space:]]+)*[[:space:]]+main([[:space:];&|]|$)'; then
    reason="checks out main"
  fi

  # branch with a force/delete/move/copy flag targeting main.
  if printf '%s' "${cmd}" | grep -qE 'branch([[:space:]]+-[^[:space:]]+)*[[:space:]]+-[A-Za-z]*[fdDmMC][A-Za-z]*[[:space:]]+main([[:space:];&|]|$)'; then
    reason="force-moves, renames, or deletes main"
  fi

  # worktrees on main and ref plumbing that reaches main without a checkout.
  if printf '%s' "${cmd}" | grep -qE 'worktree[^|;&]*[[:space:]]main([[:space:];&|]|$)' \
     || printf '%s' "${cmd}" | grep -qE '(update-ref|symbolic-ref)[^|;&]*refs/heads/main([[:space:];&|]|$)'; then
    reason="manipulates main via worktree or ref plumbing"
  fi

  [[ -n "${reason}" ]] && break
done <<< "${segments}"

if [[ -n "${reason}" ]]; then
  echo "BLOCKED by guard-main.sh: that command ${reason}. Template changes go through an approved pull request." >&2
  exit 2
fi

exit 0
