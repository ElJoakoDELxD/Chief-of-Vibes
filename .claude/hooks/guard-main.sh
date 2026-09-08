#!/usr/bin/env bash
#
# Claude Code hook (PreToolUse on Edit|Write|Bash): keeps the default branch
# read-only. Standing there it blocks everything; elsewhere it blocks the git
# commands that reach it, each documented at its own rule below. Exit 2 denies
# the call, reason on stderr. Input: PreToolUse hook JSON on stdin.
#
# A rail, not a lock: it only runs in sessions that wire it, and string-matching
# is never exhaustive. The guarantee is branch protection plus CI.
#
# **It judges what the shell will run, and nothing else.** Three things are
# mechanical, so the rail keeps them: a here-document body bound for a file is
# data (.claude/hooks/lib/command.sh), each segment is judged alone so prose in
# one is not evidence about a push in the next, and a `-C` naming a path outside
# this working tree is a different repository whose branches are not ours. What
# is left over is intent — whether this checkout is the one that was meant — and
# no rail decides that. It belongs to the post holding the session (SYSTEM.md
# section 8). tools/test-guard-main.sh pins every half.
#
# One thing stays coarse on purpose: a branch name inside a quoted argument, as
# in a commit message, still reads as a ref. That argument is executed, so the
# rail cannot call it data. knowledge/the-canon-copy-loop/ carries the way round.

set -uo pipefail
# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/lib/command.sh"

branch="$(git branch --show-current 2>/dev/null || echo "")"
command="$(hook_command)"

if [[ "${branch}" == "main" ]]; then
  # The escape hatch, and it is one command wide.
  #
  # A session created from a source lands on the default branch, and denying
  # everything here also denied the only command that leaves it. Measured
  # 02-09-2026: a session fired with a source was paralysed in its shell from
  # its first turn — it could not run `git checkout -b`, and it could not run
  # `date` either. It escaped only because it happened to hold API tools that
  # do not go through a shell; a session without them has no first move at all.
  # A rail that traps the sessions it is meant to guide gets worked around
  # until it protects nothing (§8).
  #
  # So exactly one shape passes: a lone branch-creating checkout. One segment,
  # no chaining, no redirection, no substitution, and the new branch is not the
  # default one. Everything else here is still denied, Edit and Write included —
  # they carry no command field, so they can never match this.
  esc="$(printf '%s' "${command}" | tr -d "\"'")"
  if [[ "${command}" != *[\;\|\&\>\<\`\$\(]* ]] \
     && [[ "${esc}" =~ ^[[:space:]]*git[[:space:]]+(checkout|switch)[[:space:]]+(-b|-c)[[:space:]]+([^[:space:]]+)[[:space:]]*$ ]] \
     && [[ "${BASH_REMATCH[3]}" != "main" ]]; then
    exit 0
  fi
  echo "BLOCKED by guard-main.sh: main is the template, not a workspace. Create an agent branch first — 'git checkout -b <name>' is the one command allowed from here — and template changes go through an approved pull request." >&2
  exit 2
fi

# This repository's own tree, for the -C rule below. Empty outside a checkout,
# which makes every -C read as ours and the rail err closed.
toplevel="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"

# Quotes can hide the ref, so strip them — which also flattens prose into refs.
# Hence the split: each segment is judged alone, a git invocation lives in
# exactly one of them, and an echo stops being evidence about a neighbouring push.
runs="$(executable_text "${command}" | tr -d "\"'")"
segments="$(command_segments "${runs}")"

reason=""
while IFS= read -r seg; do
  # Only inspect git commands; leave everything else alone.
  printf '%s' "${seg}" | grep -qE '(^|[^[:alnum:]_])git([[:space:]]|$)' || continue
  cmd="${seg}"

  # A -C naming an absolute path outside this working tree runs against another
  # repository, and its default branch is not the one this rail protects. A
  # fixture built under a temporary directory is the ordinary case. A relative
  # path resolves against a working directory this hook cannot see, so it counts
  # as ours.
  if [[ "${cmd}" =~ -C[[:space:]]+(/[^[:space:]]*) ]]; then
    target="${BASH_REMATCH[1]}"
    if [[ -z "${toplevel}" || "${target}" != "${toplevel}"* ]]; then
      continue
    fi
  fi

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
