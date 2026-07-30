#!/usr/bin/env bash
#
# Brings the template from `main` into the current agent branch by merging it.
#
# Merge rather than cherry-pick, on purpose. A cherry-pick copies main commit by
# commit, so the agent branch is only as current as whoever remembered to run
# this, and every sync re-raises the same conflicts. A merge makes the agent
# branch *be* main plus `memory/` and `projects/`, and git remembers each
# resolution through the merge base, so a conflict settled once stays settled.
#
# Conflicts resolve themselves, because the rule covering them has no exception
# worth a prompt (SYSTEM.md §4, §6): template files take main's version, and the
# agent branch's own README.md keeps the agent's. Both outcomes are printed — an
# override the Principal never hears about is the kind of silence this system
# exists to remove. Anything the rule does not cover stops the script.
#
# Safe to re-run: with nothing new on main it does nothing and says so.
#
# Usage:  bash tools/sync.sh

set -uo pipefail

branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "${branch}" == "main" ]]; then
  echo "sync.sh: on main; run this from an agent branch." >&2
  exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "sync.sh: working tree has uncommitted changes; commit or stash them first." >&2
  exit 1
fi

git fetch origin main || { echo "sync.sh: could not fetch origin/main." >&2; exit 1; }

if git merge-base --is-ancestor origin/main HEAD; then
  echo "Template up to date."
  exit 0
fi

echo "Merging template changes from main:"
git log --oneline --no-merges HEAD..origin/main | sed 's/^/  /'

if git merge --no-edit origin/main; then
  echo "Done. Explain to the Principal what changed."
  exit 0
fi

# Conflicts: apply the rule rather than asking.
mapfile -t conflicted < <(git diff --name-only --diff-filter=U)
took_theirs=()
kept_ours=()

for f in "${conflicted[@]}"; do
  if [[ "${f}" == "README.md" ]]; then
    git checkout --ours -- "${f}" && git add -- "${f}" && kept_ours+=("${f}")
  else
    git checkout --theirs -- "${f}" && git add -- "${f}" && took_theirs+=("${f}")
  fi
done

if git diff --name-only --diff-filter=U | grep -q .; then
  {
    echo ""
    echo "sync.sh: conflicts remain that the rule does not cover:"
    git diff --name-only --diff-filter=U | sed 's/^/  /'
    echo "Resolve them, then: git commit"
  } >&2
  exit 1
fi

git commit --no-edit >/dev/null || { echo "sync.sh: merge commit failed." >&2; exit 1; }

echo ""
echo "Conflicts resolved by the rule (SYSTEM.md §4, §6):"
if [[ ${#took_theirs[@]} -gt 0 ]]; then
  echo "  took main's version — this branch had edited template files it does not own:"
  printf '    %s\n' "${took_theirs[@]}"
  echo "  Tell the Principal those local edits are gone."
fi
if [[ ${#kept_ours[@]} -gt 0 ]]; then
  echo "  kept this branch's version — the agent's own file:"
  printf '    %s\n' "${kept_ours[@]}"
fi
echo ""
echo "Done. Explain to the Principal what changed."
