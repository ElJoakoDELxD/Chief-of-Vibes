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
#   3. Its `memory/state.md` names no agent. That file is an agent's identity (§5),
#      and a branch holding one is somebody's memory whatever git says about
#      its commits. Rule 2 alone would already spare a live agent branch. This
#      one is here for the case rule 2 stops covering: a memory branch whose
#      work has all landed is still not litter.
#
# Reports by default and deletes only when told, because a sweep that deletes
# on its first run gives nobody a chance to read what it chose.
#
# Retiring one named branch is the other half, and it is a different act. A
# superseded vault is not contained in the default branch and never will be: its
# notes were folded into another branch by hand, so nothing proves the move by
# commit ancestry. What can be proved is content. This mode reports, per file,
# whether the same bytes exist somewhere in the current branch's tree, and it
# deletes only when somebody has read that list and asked again.
#
# It is deliberately not a general branch-deletion tool. The report is the point:
# a file it cannot find elsewhere is a file the fold missed.
#
# Usage:  bash tools/sweep-branches.sh <remote> [--delete]
#         bash tools/sweep-branches.sh origin            # what would go
#         bash tools/sweep-branches.sh origin --delete   # let it go
#         bash tools/sweep-branches.sh origin --retire <branch>            # what it would lose
#         bash tools/sweep-branches.sh origin --retire <branch> --delete   # retire it

set -uo pipefail

remote="${1:?usage: sweep-branches.sh <remote> [--delete]}"
mode="${2:-}"
doit=0
[[ "${mode}" == "--delete" ]] && doit=1

if [[ "${mode}" == "--retire" ]]; then
  target="${3:?usage: sweep-branches.sh <remote> --retire <branch> [--delete]}"
  doit=0
  [[ "${4:-}" == "--delete" ]] && doit=1

  current="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "${target}" == "${current}" ]]; then
    echo "sweep-branches.sh: ${target} is the branch you are standing on." >&2
    exit 1
  fi
  ref="${remote}/${target}"
  if ! git rev-parse --verify --quiet "${ref}" >/dev/null; then
    echo "sweep-branches.sh: no ${ref}." >&2
    exit 1
  fi

  # Every blob reachable from HEAD, by content. A file is preserved when its
  # bytes exist here under any path: a fold may rename, and renaming loses
  # nothing.
  here="$(git ls-tree -r HEAD --format='%(objectname)' | sort -u)"

  # Template files are skipped, and that is not a shortcut. A branch's copy of a
  # template file is a stale mirror of main by construction: the branch being
  # retired sits at an older release, so most of them differ and none of those
  # differences is a loss. What a fold can actually lose is the branch's own
  # content, which is everything outside the template's paths.
  template='^((SYSTEM|CLAUDE|README|CONTRIBUTING|LANGUAGES|CLOCKS|INDEX)\.md|LICENSE|repomix\.config\.json|\.gitignore|\.canon|\.blueprint)$|^(\.claude|\.github|tools|system|knowledge|posts|functions)/'

  echo "Retiring ${ref}, measured against ${current}."
  echo "Template paths are skipped: a retired branch mirrors an older release of them."
  echo
  missing=0
  skipped=0
  while IFS=$'\t' read -r blob path; do
    [[ -n "${path}" ]] || continue
    if printf '%s' "${path}" | grep -qE "${template}"; then
      skipped=$(( skipped + 1 ))
      continue
    fi
    if grep -qxF "${blob}" <<< "${here}"; then
      printf 'kept      %s\n' "${path}"
    else
      printf 'NOT HERE  %s\n' "${path}"
      missing=$(( missing + 1 ))
    fi
  done < <(git ls-tree -r "${ref}" --format='%(objectname)%x09%(path)')

  echo
  echo "${skipped} template file(s) skipped."
  if (( missing )); then
    echo "${missing} file(s) on ${target} have no copy of their bytes on ${current}."
    echo "A rename is fine and is reported as kept. A file listed above is either"
    echo "changed by the fold, which a person must confirm, or missed by it."
  else
    echo "Every file on ${target} exists byte for byte on ${current}."
  fi

  if (( ! doit )); then
    echo "Reported only. Re-run with --delete once the list above has been read."
    exit 0
  fi

  git push "${remote}" --delete "${target}" && echo "Retired ${target}."
  exit $?
fi

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

  # A FILLED form, never a present file. The vault ships empty on main (§5), so
  # every branch carries memory/state.md and only an agent's names an agent.
  # Measured 09-09-2026: the first sweep after the form landed protected two dead
  # release branches, because the file they inherited looked like an identity.
  named="$(git cat-file -p "${sha}:memory/state.md" 2>/dev/null \
    | sed -n 's/^agent:[[:space:]]*//p' | head -n1 | sed 's/[[:space:]]*#.*$//; s/[[:space:]]*$//')"
  if [[ -n "${named}" ]]; then
    printf 'keep    %-44s %s  (names an agent in memory/state.md)\n' "${branch}" "${sha:0:8}"
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
