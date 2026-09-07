#!/usr/bin/env bash
#
# Deletes the branches that `main` already contains, and keeps everything else.
#
# Section 6 says the branch list is live work and not a graveyard. On 07-09-2026
# thirteen merged branches were sitting on the canon, and the three anybody had
# noticed were the three with a pull request attached. Nobody sweeps by hand.
#
# Why this is a tool and not a session's `git push --delete`: a cloud session's
# git credentials live outside its sandbox, and the proxy that signs on the
# session's behalf refuses a ref deletion whatever branch is checked out. Push
# and branch creation work in the same session, so the refusal is of the
# destructive ref update itself. A runner is a different origin with the same
# repository and its own token, which is the arrangement .github/workflows/
# already uses twice for the same reason. Do not work around the proxy. Use the
# door that exists.
#
# Three rules decide every branch, and a branch has to clear all three:
#
#   1. It is not the default branch.
#   2. `main` already contains its tip, so deleting the ref loses a name and no
#      commit. This is re-tested here rather than read from a list, because a
#      list is true when it is written and not when it runs.
#   3. It carries no `memory/state.md`. That file is an agent's identity (§5),
#      and a branch holding one is somebody's memory whatever git says about
#      its commits. Rule 2 alone would already spare a live agent branch. This
#      one is here for the case rule 2 stops covering: a memory branch whose
#      work has all landed is still not litter.
#
# Reports by default and deletes only when told, because a sweep that deletes
# on its first run gives nobody a chance to read what it chose.
#
# Usage:  bash tools/sweep-branches.sh <remote> [--delete]
#         bash tools/sweep-branches.sh origin            # what would go
#         bash tools/sweep-branches.sh origin --delete   # let it go

set -uo pipefail

remote="${1:?usage: sweep-branches.sh <remote> [--delete]}"
mode="${2:-}"
doit=0
[[ "${mode}" == "--delete" ]] && doit=1

default_branch="$(git symbolic-ref --quiet --short "refs/remotes/${remote}/HEAD" 2>/dev/null \
  | sed "s#^${remote}/##")"
default_branch="${default_branch:-main}"

if ! git rev-parse --verify --quiet "${remote}/${default_branch}" >/dev/null; then
  echo "sweep-branches.sh: no ${remote}/${default_branch} to measure against." >&2
  exit 1
fi

base="$(git rev-parse "${remote}/${default_branch}")"
echo "Default branch: ${default_branch} at ${base}"
echo

doomed=()
kept=0

while IFS= read -r branch; do
  [[ -n "${branch}" ]] || continue
  [[ "${branch}" == "${default_branch}" ]] && continue

  sha="$(git rev-parse --verify --quiet "${remote}/${branch}")" || continue

  if ! git merge-base --is-ancestor "${sha}" "${base}"; then
    printf 'keep    %-44s %s  (not contained in %s)\n' "${branch}" "${sha:0:8}" "${default_branch}"
    kept=$(( kept + 1 ))
    continue
  fi

  if git cat-file -e "${sha}:memory/state.md" 2>/dev/null; then
    printf 'keep    %-44s %s  (carries memory/state.md)\n' "${branch}" "${sha:0:8}"
    kept=$(( kept + 1 ))
    continue
  fi

  printf 'delete  %-44s %s\n' "${branch}" "${sha:0:8}"
  doomed+=("${branch}")
done < <(git ls-remote --heads "${remote}" 2>/dev/null | sed -E 's#.*refs/heads/##')

echo
echo "${#doomed[@]} to delete, ${kept} kept."

if (( ! doit )); then
  echo "Reported only. Re-run with --delete to act."
  exit 0
fi

if (( ${#doomed[@]} == 0 )); then
  echo "Nothing to do."
  exit 0
fi

# One ref per push. A single push with many refs reports one status for the
# batch, and a sweep that cannot say which branch it failed on is a sweep
# nobody can trust twice.
failed=0
for branch in "${doomed[@]}"; do
  if git push "${remote}" --delete "${branch}"; then
    echo "  deleted ${branch}"
  else
    echo "  FAILED  ${branch}" >&2
    failed=1
  fi
done

exit "${failed}"
