#!/usr/bin/env bash
#
# Bench for .github/scope.sh, which decides whether the guard jobs apply to a
# pull request. It reads the branch rather than its name, so the bench builds
# both kinds of tree and asks.
#
# Usage:  bash tools/test-scope.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scope="${here}/../.github/scope.sh"
fails=0

ask() {  # ask <dir> -> the skip value written to the step output
  local out; out="$(mktemp)"
  (cd "$1" && GITHUB_OUTPUT="${out}" bash "${scope}" >/dev/null 2>&1)
  grep -oE 'skip=(true|false)' "${out}" | tail -n1
  rm -f "${out}"
}
want() {  # want <expected> <dir> <label>
  local got; got="$(ask "$2")"
  if [[ "${got}" == "skip=$1" ]]; then printf 'ok   %s\n' "$3"
  else printf 'FAIL %s: wanted skip=%s, got %s\n' "$3" "$1" "${got:-nothing}"; fails=$((fails + 1)); fi
}

template="$(mktemp -d)"
mkdir -p "${template}/system" "${template}/tools"
touch "${template}/SYSTEM.md"
want false "${template}" "a template branch is checked"

agent="$(mktemp -d)"
mkdir -p "${agent}/memory/projects" "${agent}/system"
touch "${agent}/SYSTEM.md"
printf -- '---\nagent: Some Agent\nposts: [steward]\n---\n' > "${agent}/memory/state.md"
want true "${agent}" "a branch whose state.md names an agent is skipped"

# The empty form is on every branch, because the vault ships as template (SYSTEM.md
# section 5). Testing that the file exists would skip these jobs on every pull
# request and report success while checking nothing, so the test is the value.
empty="$(mktemp -d)"
mkdir -p "${empty}/memory/journal" "${empty}/system"
touch "${empty}/SYSTEM.md"
printf -- '---\nagent:                     # the agent'"'"'s name\nposts: []\n---\n' > "${empty}/memory/state.md"
want false "${empty}" "the empty form on main is not an agent"

# A field holding only its own comment is empty, which is how the shipped form reads.
commented="$(mktemp -d)"
mkdir -p "${commented}/system"; mkdir -p "${commented}/memory"
touch "${commented}/SYSTEM.md"
printf -- '---\nagent:   # the agent name goes here\n---\n' > "${commented}/memory/state.md"
want false "${commented}" "a field carrying only a comment is not a value"

# memory/ without state.md is not an agent's workspace either.
stray="$(mktemp -d)"
mkdir -p "${stray}/memory"
touch "${stray}/SYSTEM.md"
want false "${stray}" "an empty memory folder does not exclude a branch"

rm -rf "${template}" "${agent}" "${stray}" "${empty}" "${commented}"

if (( fails )); then echo ".github/scope.sh: bench FAILED"; exit 1; fi
echo ".github/scope.sh: bench passed"
