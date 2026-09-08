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
touch "${agent}/SYSTEM.md" "${agent}/memory/state.md"
want true "${agent}" "a branch carrying an agent's memory is skipped"

# memory/ without state.md is not an agent's workspace. The vault is what the
# file marks, and a stray folder is not one (SYSTEM.md section 5).
stray="$(mktemp -d)"
mkdir -p "${stray}/memory"
touch "${stray}/SYSTEM.md"
want false "${stray}" "an empty memory folder does not exclude a branch"

rm -rf "${template}" "${agent}" "${stray}"

if (( fails )); then echo ".github/scope.sh: bench FAILED"; exit 1; fi
echo ".github/scope.sh: bench passed"
