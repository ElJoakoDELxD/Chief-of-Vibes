#!/usr/bin/env bash
#
# Bench for tools/pr-guard.sh, the check that decides what reaches main. It had
# none while it lived inside a workflow, which made it the only rail here whose
# failure mode was a green check.
#
# Fixtures are whole repositories with two commits, because both halves read
# git: one diffs the paths between base and head, the other reads SYSTEM.md at
# each end. The `.canon` file decides which side of the copy/canon split the
# fixture is on, and the two sides answer differently on purpose.
#
# Usage:  bash tools/test-pr-guard.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

fail=0
check() {
  local name="$1" expected="$2" got="$3"
  if [[ "${got}" == *"${expected}"* ]]; then echo "ok   ${name}"
  else echo "FAIL ${name}"; echo "     expected to contain: ${expected}"
       echo "     got: ${got:-<empty>}"; fail=1; fi
}
check_absent() {
  local name="$1" forbidden="$2" got="$3"
  if [[ "${got}" == *"${forbidden}"* ]]; then echo "FAIL ${name}"
       echo "     should not contain: ${forbidden}"; echo "     got: ${got}"; fail=1
  else echo "ok   ${name}"; fi
}
check_code() {
  local name="$1" want="$2" got="$3"
  if [[ "${want}" == "${got}" ]]; then echo "ok   ${name}"
  else echo "FAIL ${name}: wanted exit ${want}, got ${got}"; fail=1; fi
}

# A repository at version $2, whose base commit is tagged `base`.
build() {
  local dir="${tmp}/$1" version="$2" canon="$3"
  rm -rf "${dir}"; mkdir -p "${dir}"
  cd "${dir}"
  git init -q .
  git config user.email bench@example.com
  git config user.name bench
  printf '%s\n' "${canon}" > .canon
  printf '**Version %s.** spec\n' "${version}" > SYSTEM.md
  git add -A && git commit -q -m base && git tag base
  cd - >/dev/null
}

# Runs the guard in a fixture, as the given owner/repo.
run() { ( cd "${tmp}/$1" && bash "${here}/pr-guard.sh" base HEAD "$2" 2>&1 ); }
code() { ( cd "${tmp}/$1" && bash "${here}/pr-guard.sh" base HEAD "$2" >/dev/null 2>&1 ); echo $?; }

commit() { ( cd "${tmp}/$1" && git add -A && git commit -q -m change ); }

CANON="Owner/Canon"

# --- the canon, the strict side -----------------------------------------------
build canon-ok 1.0.0 "${CANON}"
printf '**Version 1.1.0.** spec\n' > "${tmp}/canon-ok/SYSTEM.md"; commit canon-ok
out="$(run canon-ok "${CANON}")"
check "a template change with a bump passes"        "Version 1.0.0 → 1.1.0" "${out}"
check "the path half reports when it finds nothing" "every changed file is a template file" "${out}"
check_code "and it exits 0" 0 "$(code canon-ok "${CANON}")"

build canon-nobump 1.0.0 "${CANON}"
printf 'changed\n' >> "${tmp}/canon-nobump/SYSTEM.md"; commit canon-nobump
out="$(run canon-nobump "${CANON}")"
check      "a template change with no bump is rejected" "bump SYSTEM.md's version" "${out}"
check_code "and it exits 1" 1 "$(code canon-nobump "${CANON}")"

build canon-mem 1.0.0 "${CANON}"
mkdir -p "${tmp}/canon-mem/memory"
printf 'notes\n' > "${tmp}/canon-mem/memory/backlog.md"
printf '**Version 1.1.0.** spec\n' > "${tmp}/canon-mem/SYSTEM.md"; commit canon-mem
out="$(run canon-mem "${CANON}")"
check      "agent memory bound for main is rejected" "memory/backlog.md is outside the template" "${out}"
check_code "and it exits 1 even though the version was bumped" 1 "$(code canon-mem "${CANON}")"

# The reason this stopped being two workflow steps. Steps are fail-fast, so a
# rejected path used to hide whatever the version check would have said.
build canon-both 1.0.0 "${CANON}"
mkdir -p "${tmp}/canon-both/memory"
printf 'notes\n' > "${tmp}/canon-both/memory/backlog.md"
printf 'changed\n' >> "${tmp}/canon-both/SYSTEM.md"; commit canon-both
out="$(run canon-both "${CANON}")"
check "two failures are both reported, not just the first" "bump SYSTEM.md's version" "${out}"
check "and the path failure is reported too"               "outside the template"     "${out}"

# knowledge/ is a template path in both repositories since 1.61.0. This case is
# the reverse of the one it replaced: the canon used to reject the folder, and
# the guard rejected this very change when the rule moved and the rail did not.
# What separates the two repositories is what the folder ADMITS, which is a
# judgment about content and belongs to the reviewer, not to a path pattern.
build canon-know 1.0.0 "${CANON}"
mkdir -p "${tmp}/canon-know/knowledge"
printf 'entry\n' > "${tmp}/canon-know/knowledge/thing.md"
printf '**Version 1.1.0.** spec\n' > "${tmp}/canon-know/SYSTEM.md"; commit canon-know
out="$(run canon-know "${CANON}")"
check_absent "knowledge/ on the canon is allowed" "outside the template" "${out}"

# --- a copy, which holds a superset and issues no versions --------------------
build copy-nobump 1.0.0 "${CANON}"
printf 'changed\n' >> "${tmp}/copy-nobump/SYSTEM.md"; commit copy-nobump
out="$(run copy-nobump "Someone/Their-Copy")"
check      "a copy is not asked for a bump" "a copy does not carry the master version" "${out}"
check_code "and it exits 0"                 0 "$(code copy-nobump "Someone/Their-Copy")"

build copy-know 1.0.0 "${CANON}"
mkdir -p "${tmp}/copy-know/knowledge"
printf 'entry\n' > "${tmp}/copy-know/knowledge/thing.md"; commit copy-know
out="$(run copy-know "Someone/Their-Copy")"
check_absent "knowledge/ in a copy is allowed" "outside the template" "${out}"

# --- the knowledge-only carve-out, on the canon side of the switch ------------
# Pinned because it is the one case where a changed SYSTEM.md is NOT required,
# and a carve-out that never fires is the same as not having one.
build canon-konly 1.0.0 "${CANON}"
mkdir -p "${tmp}/canon-konly/knowledge"
printf '**Version 1.0.0.** spec\n' > "${tmp}/canon-konly/SYSTEM.md"
printf 'entry\n' > "${tmp}/canon-konly/knowledge/thing.md"
printf 'index\n' > "${tmp}/canon-konly/INDEX.md"; commit canon-konly
out="$(run canon-konly "${CANON}")"
check "a knowledge-only change needs no bump" "no bump required" "${out}"

# The two reach records land a line when somebody used the system somewhere new.
# That changes no rule, so it is not a release either — and the two have to be
# treated alike, or the guard itself becomes the contradiction.
for record in LANGUAGES CLOCKS; do
  build "canon-${record}" 1.0.0 "${CANON}"
  printf '**Version 1.0.0.** spec\n' > "${tmp}/canon-${record}/SYSTEM.md"
  printf '| a row | 2026-01-01 |\n' > "${tmp}/canon-${record}/${record}.md"
  commit "canon-${record}"
  out="$(run "canon-${record}" "${CANON}")"
  check "a line in ${record}.md needs no bump" "no bump required" "${out}"
done

# --- a SYSTEM.md with no version line -----------------------------------------
build canon-noline 1.0.0 "${CANON}"
printf 'no version here\n' > "${tmp}/canon-noline/SYSTEM.md"; commit canon-noline
out="$(run canon-noline "${CANON}")"
check "a missing version line is named, not ignored" "carries no '**Version X.Y.Z.**' line" "${out}"

if (( fail )); then
  echo "tools/pr-guard.sh: bench FAILED"
  exit 1
fi
echo "tools/pr-guard.sh: bench passed"
