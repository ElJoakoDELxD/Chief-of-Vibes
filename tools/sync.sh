#!/usr/bin/env bash
#
# Brings template updates from origin/main into the current agent branch by
# cherry-picking the main commits not yet applied here. Safe to re-run:
# already-absorbed patches are excluded via `git log --cherry-pick`.
#
# On conflict the script stops with instructions. A conflict means this
# branch edited template files; resolve by accepting main's version, then
# `git cherry-pick --continue` (or `--abort` to roll back).
#
# Usage:  bash tools/sync.sh

set -euo pipefail

branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "${branch}" == "main" ]]; then
  echo "sync.sh: on main; run this from an agent branch." >&2
  exit 1
fi

git fetch origin main

commits="$(git log --cherry-pick HEAD...origin/main --right-only --reverse --no-merges --format='%H')"
if [[ -z "${commits}" ]]; then
  echo "Template up to date."
  exit 0
fi

count="$(wc -l <<<"${commits}" | tr -d ' ')"
echo "Applying ${count} template commit(s) from main:"
git log --cherry-pick HEAD...origin/main --right-only --reverse --no-merges --format='  %h %s'

while IFS= read -r commit; do
  if ! git cherry-pick -x "${commit}"; then
    {
      echo ""
      echo "Conflict at ${commit}: this branch has local template edits."
      echo "Accept main's version, then:  git cherry-pick --continue"
      echo "To roll back the sync:        git cherry-pick --abort"
    } >&2
    exit 1
  fi
done <<<"${commits}"

echo "Done: ${count} commit(s) applied. Explain to the Principal what changed."
