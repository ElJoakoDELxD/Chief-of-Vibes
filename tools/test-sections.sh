#!/usr/bin/env bash
#
# Bench for tools/sections.sh. It pins each way the map and the tree can
# disagree, and pins that a correct pair passes. A check that cannot fail is
# not a check, and the on-demand reading of the specification rests on this
# one (SYSTEM.md section 8).
#
# Usage:  bash tools/test-sections.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT
mkdir -p "${tmp}/tools" "${tmp}/system"
cp "${here}/sections.sh" "${tmp}/tools/sections.sh"

core() {  # core <map-rows...>
  { printf '# SYSTEM\n\n## Map\n\n| Section | Holds | Where |\n|---|---|---|\n'
    for r in "$@"; do printf '%s\n' "${r}"; done
    printf '\n---\n\n## 1. Purpose\n\nbody\n\n---\n\n## 3. Rules\n\nbody\n'
  } > "${tmp}/SYSTEM.md"
}

leaf() { printf '## %s. %s\n\nbody\n' "$1" "$2" > "${tmp}/system/$3"; }

reset_good() {
  rm -f "${tmp}/system/"*.md
  core '| §1 | Purpose | **here** |' \
       '| §2 | Roles | [`system/2-roles.md`](system/2-roles.md) |' \
       '| §3 | Rules | **here** |'
  leaf 2 Roles 2-roles.md
}

fails=0
run() { (cd "${tmp}" && bash tools/sections.sh --check 2>&1); }
check() {  # check <pass|fail> <label> [expected-substring]
  local want="$1" label="$2" pat="${3:-}" out rc
  out="$(run)"; rc=$?
  if [[ "${want}" == pass && ${rc} -eq 0 ]] \
  || [[ "${want}" == fail && ${rc} -ne 0 && ( -z "${pat}" || "${out}" == *"${pat}"* ) ]]; then
    printf 'ok    %s\n' "${label}"
  else
    printf 'FAIL  %s\n      got: %s\n' "${label}" "${out}"; fails=$((fails + 1))
  fi
}

reset_good
check pass "a map that matches the tree passes"

# 1. A section nobody points at.
reset_good; leaf 4 Extra 4-extra.md
sed -i 's/^## 3\. Rules$/## 3. Rules/' "${tmp}/SYSTEM.md"
check fail "a leaf with no row in the map is named" "no row in the map"

# 2. A row pointing at the wrong file.
reset_good
sed -i 's#(system/2-roles.md)#(system/9-elsewhere.md)#g; s#`system/2-roles.md`#`system/9-elsewhere.md`#' "${tmp}/SYSTEM.md"
check fail "a row pointing somewhere else is named" "the map sends §2"

# 3. The same section in two places.
reset_good; leaf 1 Purpose 1-purpose.md
check fail "a section defined twice is named" "defined twice"

# 4. A leaf whose filename does not match its heading.
reset_good; rm -f "${tmp}/system/2-roles.md"; leaf 2 Roles 2-something-else.md
check fail "a leaf named wrong is named, with the name it should have" "its name should be"

# 5. A row for a section no file holds.
reset_good; rm -f "${tmp}/system/2-roles.md"
check fail "a row with no file behind it is named" "no file holds it"

# 6. The map calling a section something the heading does not.
reset_good
sed -i 's/| §2 | Roles |/| §2 | Something Else |/' "${tmp}/SYSTEM.md"
check fail "a row whose title drifted from the heading is named" "the heading says"

# 7. A gap in the numbering.
reset_good; rm -f "${tmp}/system/2-roles.md"
sed -i '/| §2 |/d' "${tmp}/SYSTEM.md"
check fail "a gap in the section numbers is named" "are not 1.."

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
