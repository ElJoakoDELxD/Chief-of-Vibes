#!/usr/bin/env bash
#
# Claude Code hook (PreToolUse on Edit|Write|Bash): keeps main read-only.
# On main it blocks everything; elsewhere it blocks the git commands that reach
# main, each documented at its own rule below. Exit 2 denies the call, reason on
# stderr. Input: PreToolUse hook JSON on stdin.
#
# A rail, not a lock: it only runs in sessions that wire it, and string-matching
# is never exhaustive. The guarantee for main is branch protection plus CI.
#
# It errs closed where text and intent are indistinguishable — a command writing
# a dangerous command into a file reads exactly like the command. That direction
# is safe. Blocking ordinary work is not, and prose mentioning the branch used to
# be enough to deny an unrelated push. Segment scoping separates the two;
# tools/test-guard-main.sh pins both halves.

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

# Quotes can hide the ref, so strip them — which also flattens prose into refs.
# Hence the split: each segment is judged alone, a git invocation lives in
# exactly one of them, and an echo stops being evidence about a neighbouring push.
cmd="$(printf '%s' "${command}" | tr -d "\"'")"
segments="$(printf '%s' "${cmd}" | sed 's/&&/\n/g; s/||/\n/g' | tr ';|&' '\n')"

reason=""
while IFS= read -r seg; do
  # Only inspect git commands; leave everything else alone.
  printf '%s' "${seg}" | grep -qE '(^|[^[:alnum:]_])git([[:space:]]|$)' || continue
  cmd="${seg}"

  # push to any refspec form ending in main (main, +main, src:main, refs/heads/main).
  # The token must end there, so 'maintenance' and 'main..HEAD' are not matched.
  if printf '%s' "${cmd}" | grep -qE '(^|[[:space:]])push([[:space:]]|$)' \
     && printf '%s' "${cmd}" | grep -qE '(^|[[:space:]:+/])main([[:space:];&|]|$)'; then
    reason="pushes to main"
  fi

  # push --mirror / --all replicate every ref, main included.
  if printf '%s' "${cmd}" | grep -qE '(^|[[:space:]])push([[:space:]]|$)' \
     && printf '%s' "${cmd}" | grep -qE '(^|[[:space:]])--(mirror|all)([[:space:];&|]|$)'; then
    reason="pushes all refs (main included)"
  fi

  # checkout/switch onto main past any flags. Branching OFF main and a path
  # named main-something are not matched.
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
