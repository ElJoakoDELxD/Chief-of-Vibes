#!/usr/bin/env bash
#
# Bench for tools/models.sh. Every case here is about the same property: the
# tool must never report approval it did not establish. The failure it exists to
# end was silent for three weeks, so a wrong answer here is worse than no tool.
#
# Usage:  bash tools/test-models.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

fails=0
check() {  # check <want|want-not> <pattern> <label>
  local mode="$1" pat="$2" label="$3"
  if [[ "${mode}" == want && "${out}" == *"${pat}"* ]] \
  || [[ "${mode}" == want-not && "${out}" != *"${pat}"* ]]; then
    printf 'ok   %s\n' "${label}"
  else
    printf 'FAIL %s\n' "${label}"; printf '     out=%s\n' "${out:-<empty>}"; fails=$((fails + 1))
  fi
}
code_is() {  # code_is <want> <label>
  if [[ "$1" == "${code}" ]]; then printf 'ok   %s\n' "$2"
  else printf 'FAIL %s: wanted exit %s, got %s\n' "$2" "$1" "${code}"; fails=$((fails + 1)); fi
}

build() {  # build <models-line-or-empty>
  rm -rf "${tmp}/repo"; mkdir -p "${tmp}/repo/memory/posts"
  {
    printf -- '---\npost: Custodian\n'
    [[ -n "$1" ]] && printf 'models: %s\n' "$1"
    printf -- '---\n\n# Custodian\n'
  } > "${tmp}/repo/memory/posts/custodian.md"
}
run() { out="$( cd "${tmp}/repo" && bash "${here}/models.sh" "$@" 2>&1 )"; code=$?; }

build "claude-opus-5"
run claude-opus-5
check want "is approved for the custodian post" "an approved model is named as approved"
code_is 0 "and exits 0"

run claude-sonnet-5
check want     "STOP: claude-sonnet-5 is not approved" "an unapproved model is refused by name"
check want     "Approved: claude-opus-5"               "and the refusal shows the list it failed"
# The refusal contains the approval sentence as a substring, so the assertion
# has to be the whole claim. A looser one passed while reading the wrong way.
check want-not "Model: claude-sonnet-5 is approved"    "and never reads as approval"
code_is 1 "and exits 1"

# The reading is the half this tool cannot take itself. Missing means refused,
# never assumed: that silence is what let an unlisted model run for two days.
run
check want "no served model given, so nothing was checked" "no reading is a refusal, not a pass"
code_is 2 "and exits 2, distinct from a refusal"

build ""
run claude-opus-5
check want "carries no \`models:\` line" "a post with no list approves nothing"
code_is 2 "and exits 2"

rm -rf "${tmp}/repo"; mkdir -p "${tmp}/repo"
run claude-opus-5
check want "records no approved models" "a missing post file is named, never guessed"
code_is 2 "and exits 2"

# A list a person maintains should not fail on a separator.
build "claude-opus-5, claude-opus-4-8"
run claude-opus-4-8
code_is 0 "a comma-separated list is read"
build "claude-opus-5 claude-opus-4-8"
run claude-opus-4-8
code_is 0 "a space-separated list is read too"

# A prefix is not a match. claude-opus-5 must not approve claude-opus-50.
build "claude-opus-5"
run claude-opus-50
code_is 1 "a longer name that starts the same is refused"

if (( fails )); then echo "tools/models.sh: bench FAILED"; exit 1; fi
echo "tools/models.sh: bench passed"
