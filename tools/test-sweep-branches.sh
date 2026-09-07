#!/usr/bin/env bash
#
# Bench for tools/sweep-branches.sh. A sweep that deletes refs is the one tool
# here whose mistake cannot be read back afterwards, so every rule it applies is
# pinned, and the rule that spares an agent's memory is pinned twice: once where
# the commits alone would already have saved it, and once where they would not.
#
# The fixture is a bare repository and a clone of it, so the delete path is
# exercised for real rather than mocked.
#
# Usage:  bash tools/test-sweep-branches.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

fails=0
report() {
  local name="$1" ok="$2" detail="$3"
  if [[ "${ok}" == "yes" ]]; then echo "ok   ${name}"
  else echo "FAIL ${name}"; echo "     ${detail}"; fails=$((fails + 1)); fi
}
check() {  # check <want|want-not> <pattern> <label>
  local mode="$1" pat="$2" label="$3"
  if [[ "${mode}" == want && "${out}" == *"${pat}"* ]] \
  || [[ "${mode}" == want-not && "${out}" != *"${pat}"* ]]; then
    report "${label}" yes ""
  else
    report "${label}" no "out=${out}"
  fi
}

q() { git "$@" >/dev/null 2>&1; }

git init --quiet --bare "${tmp}/origin.git"
git clone --quiet "${tmp}/origin.git" "${tmp}/work" 2>/dev/null
cd "${tmp}/work" || exit 1
q config user.email bench@example.com
q config user.name Bench
q checkout -b main
echo one > file.txt; q add .; q commit -m "one"
q push -u origin main

# Contained in main and carrying no memory: the only shape that goes.
q branch merged-one
q push origin merged-one

# A commit main does not have.
q checkout -b ahead-one
echo two > file.txt; q add .; q commit -m "two"
q push origin ahead-one
q checkout main

# An agent memory branch whose work has all landed. The commits alone would
# not save it, so only the memory/state.md rule can.
q checkout -b memory-landed
mkdir -p memory; printf -- '---\nagent: Bench\n---\n' > memory/state.md
q add .; q commit -m "a vault"
q push origin memory-landed
q checkout main
q merge --no-ff --no-edit memory-landed
q push origin main
q fetch origin

out="$(bash "${here}/sweep-branches.sh" origin 2>&1)"
check want     "delete  merged-one"          "a branch main contains is named for deletion"
check want     "keep    ahead-one"           "a branch with its own commit is kept"
check want     "not contained in main"       "the keep says why"
check want     "keep    memory-landed"       "a merged branch carrying a vault is kept"
check want     "carries memory/state.md"     "that keep names the vault as its reason"
check want-not "delete  main"                "the default branch is never named"
check want     "1 to delete, 2 kept."        "the count matches the rules"

before="$(git ls-remote --heads origin | wc -l | tr -d ' ')"
out="$(bash "${here}/sweep-branches.sh" origin 2>&1)"
after="$(git ls-remote --heads origin | wc -l | tr -d ' ')"
[[ "${before}" == "${after}" ]] \
  && report "reporting deletes nothing" yes "" \
  || report "reporting deletes nothing" no "refs ${before} then ${after}"

out="$(bash "${here}/sweep-branches.sh" origin --delete 2>&1)"
remaining="$(git ls-remote --heads origin | sed -E 's#.*refs/heads/##' | sort | paste -sd ',' -)"
[[ "${remaining}" == "ahead-one,main,memory-landed" ]] \
  && report "delete removes exactly the one branch" yes "" \
  || report "delete removes exactly the one branch" no "remaining=${remaining}"

out="$(bash "${here}/sweep-branches.sh" origin --delete 2>&1)"
check want "0 to delete"                     "a second run finds nothing and says so"

# --- retiring one named branch ------------------------------------------------
# A superseded vault is never contained in the default branch, so ancestry proves
# nothing about it. What can be proved is content, per file, and the report is
# the point: a file it cannot find elsewhere is a file the fold missed.
(
  cd "${tmp}/work"
  git switch -q -c keeper
  mkdir -p memory/projects/old
  printf 'moved verbatim\n' > memory/projects/old/note.md
  printf 'merged by hand\n' > memory/state.md
  git add -A && git commit -q -m vault && git push -q origin keeper

  git switch -q -c folded keeper
  mkdir -p memory/projects/new
  printf 'moved verbatim\n' > memory/projects/new/note.md
  printf 'merged by hand, differently\n' > memory/state.md
  printf 'a template file that moved on\n' > SYSTEM.md
  git add -A && git commit -q -m fold
  git fetch -q origin
) >/dev/null 2>&1

out="$( cd "${tmp}/work" && bash "${here}/sweep-branches.sh" origin --retire keeper 2>&1 )"
check want "kept      memory/projects/old/note.md" "a file whose bytes moved under a new path is kept"
check want "NOT HERE  memory/state.md" "a file the fold changed is named"
check want-not "NOT HERE  SYSTEM.md" "a template mirror is not called a loss"
check want "template file(s) skipped" "the template count is reported"
check want "Reported only" "reporting does not delete"

before="$( cd "${tmp}/work" && git ls-remote --heads origin | wc -l | tr -d ' ' )"
out="$( cd "${tmp}/work" && bash "${here}/sweep-branches.sh" origin --retire keeper 2>&1 )"
after="$( cd "${tmp}/work" && git ls-remote --heads origin | wc -l | tr -d ' ' )"
[[ "${before}" == "${after}" ]] \
  && report "a retire report removes no ref" yes "" \
  || report "a retire report removes no ref" no "refs ${before} then ${after}"

out="$( cd "${tmp}/work" && bash "${here}/sweep-branches.sh" origin --retire folded 2>&1 )"
check want "is the branch you are standing on" "standing on the branch is refused"

out="$( cd "${tmp}/work" && bash "${here}/sweep-branches.sh" origin --retire nowhere 2>&1 )"
check want "no origin/nowhere" "an absent branch is named, never guessed"

out="$( cd "${tmp}/work" && bash "${here}/sweep-branches.sh" origin --retire keeper --delete 2>&1 )"
remaining="$( cd "${tmp}/work" && git ls-remote --heads origin | sed -E 's#.*refs/heads/##' | sort | paste -sd ',' - )"
[[ "${remaining}" != *keeper* ]] \
  && report "--delete retires the named branch" yes "" \
  || report "--delete retires the named branch" no "remaining=${remaining}"

if (( fails )); then
  echo "tools/sweep-branches.sh: bench FAILED"; exit 1
fi
echo "tools/sweep-branches.sh: bench passed"
