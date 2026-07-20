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
# and string-matching shell commands is never exhaustive — this guard errs
# closed on odd compounds (e.g. a quoted argument carrying a bare 'main'
# word may block too; reword and retry). The hard guarantee for main is
# server-side branch protection plus the PR guard (CI); treat this hook as
# defence-in-depth.
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

# Quotes can hide the ref ("main", 'main'); strip them before matching, and
# treat command separators (; & |) as token ends so `...main&&x` still hits.
cmd="$(printf '%s' "${command}" | tr -d "\"'")"

# Only inspect git commands; leave everything else alone.
if printf '%s' "${cmd}" | grep -qE '(^|[^[:alnum:]_])git([[:space:]]|$)'; then
  reason=""

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

  if [[ -n "${reason}" ]]; then
    echo "BLOCKED by guard-main.sh: that command ${reason}. Template changes go through an approved pull request." >&2
    exit 2
  fi
fi

exit 0
