#!/usr/bin/env bash
#
# Test bench for tools/sync.sh.
#
# Builds a throwaway repository with a main branch and an agent branch, then
# drives the situations a real sync meets: nothing to do, a clean template
# update, a conflict on the agent's own README, a conflict on a template file
# the agent branch should never have touched, and a second sync afterwards —
# which is the case cherry-picking got wrong, by re-raising a conflict already
# settled.
#
# Usage:  bash tools/test-sync.sh [path/to/sync.sh]
# Exits non-zero with the number of failures.

set -uo pipefail

SYNC="$(cd "$(dirname "${1:-tools/sync.sh}")" && pwd)/$(basename "${1:-tools/sync.sh}")"
[[ -f "${SYNC}" ]] || { echo "no sync.sh at ${SYNC}" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT
failures=0

say() { printf '\n--- %s\n' "$1"; }
ok()  { printf 'ok    %s\n' "$1"; }
bad() { printf 'FAIL  %s\n' "$1"; failures=$((failures + 1)); }

check() { # description, expected, actual
  if [[ "$2" == "$3" ]]; then ok "$1"; else bad "$1 (want '$2', got '$3')"; fi
}

# A repository with main (template) and AGENT (template + memory).
build() {
  rm -rf "${WORK}/repo" "${WORK}/remote"
  git init -q --bare "${WORK}/remote"
  git init -q -b main "${WORK}/repo"
  cd "${WORK}/repo"
  git config user.email t@t; git config user.name t
  printf 'v1\n' > SYSTEM.md
  printf 'template readme\n' > README.md
  git add -A; git commit -qm 'template v1'
  git remote add origin "${WORK}/remote"; git push -q -u origin main

  git checkout -qb AGENT
  mkdir -p memory; printf 'agent state\n' > memory/state.md
  printf 'agent readme\n' > README.md
  git add -A; git commit -qm 'agent vault'
}

advance_main() { # file, content, message
  git checkout -q main
  printf '%s\n' "$2" > "$1"
  git add -A; git commit -qm "$3"; git push -q origin main
  git checkout -q AGENT
}

say 'nothing new on main'
build
out="$(bash "${SYNC}" 2>&1)"; rc=$?
check 'exits 0' 0 "${rc}"
check 'says up to date' 'yes' "$(grep -q 'up to date' <<<"${out}" && echo yes || echo no)"

say 'clean template update'
build
advance_main SYSTEM.md v2 'template v2'
out="$(bash "${SYNC}" 2>&1)"; rc=$?
check 'exits 0' 0 "${rc}"
check 'template file updated' 'v2' "$(cat SYSTEM.md)"
check 'agent memory untouched' 'agent state' "$(cat memory/state.md)"
check 'agent README untouched' 'agent readme' "$(cat README.md)"

say 'conflict on README: the agent keeps its own'
build
advance_main README.md 'template readme v2' 'template readme change'
out="$(bash "${SYNC}" 2>&1)"; rc=$?
check 'exits 0' 0 "${rc}"
check 'agent README wins' 'agent readme' "$(cat README.md)"
check 'reports keeping ours' 'yes' "$(grep -q "kept this branch's version" <<<"${out}" && echo yes || echo no)"
check 'no conflict markers left' 'no' "$(grep -q '<<<<<<<' README.md && echo yes || echo no)"

say 'second sync does not re-raise the settled README conflict'
advance_main SYSTEM.md v3 'template v3'
out="$(bash "${SYNC}" 2>&1)"; rc=$?
check 'exits 0' 0 "${rc}"
check 'template moved on' 'v3' "$(cat SYSTEM.md)"
check 'agent README still the agent one' 'agent readme' "$(cat README.md)"
check 'README not reported again' 'no' "$(grep -q "kept this branch's version" <<<"${out}" && echo yes || echo no)"

say 'conflict on a template file the branch should not own: main wins, loudly'
build
printf 'local meddling\n' > SYSTEM.md
git add -A; git commit -qm 'agent edited a template file'
advance_main SYSTEM.md v2 'template v2'
out="$(bash "${SYNC}" 2>&1)"; rc=$?
check 'exits 0' 0 "${rc}"
check "main's version wins" 'v2' "$(cat SYSTEM.md)"
check 'reports the override' 'yes' "$(grep -q "took main's version" <<<"${out}" && echo yes || echo no)"
check 'names the lost edit' 'yes' "$(grep -q 'SYSTEM.md' <<<"${out}" && echo yes || echo no)"

say 'refuses to run with a dirty tree'
build
advance_main SYSTEM.md v2 'template v2'
printf 'scratch\n' > memory/state.md
out="$(bash "${SYNC}" 2>&1)"; rc=$?
check 'exits non-zero' 1 "${rc}"
check 'says why' 'yes' "$(grep -q 'uncommitted' <<<"${out}" && echo yes || echo no)"

say 'refuses to run on main'
build
git checkout -q main
out="$(bash "${SYNC}" 2>&1)"; rc=$?
check 'exits non-zero' 1 "${rc}"
check 'says why' 'yes' "$(grep -q 'run this from an agent branch' <<<"${out}" && echo yes || echo no)"

printf '\n'
if [[ "${failures}" -eq 0 ]]; then echo "all green"; else echo "${failures} failing"; fi
exit "${failures}"
