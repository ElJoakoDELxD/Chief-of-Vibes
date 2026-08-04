#!/usr/bin/env bash
#
# Bench for tools/prose-gate.sh. It pins that the check reports and never blocks,
# and that a file over the gate is named rather than buried in a table.
#
# Usage:  bash tools/test-prose-gate.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(dirname "${here}")"
fails=0

check() {  # check <want|want-not> <pattern> <label>
  local mode="$1" pat="$2" label="$3"
  if [[ "${mode}" == want && "${out}" == *"${pat}"* ]] \
  || [[ "${mode}" == want-not && "${out}" != *"${pat}"* ]]; then
    printf 'ok    %s\n' "${label}"
  else
    printf 'FAIL  %s\n' "${label}"; fails=$((fails + 1))
  fi
}

out="$(cd "${root}" && bash tools/prose-gate.sh)"; status=$?

if (( status == 0 )); then
  printf 'ok    it exits zero, because it reports and never blocks\n'
else
  printf 'FAIL  it exited %d; rung 3 does not block\n' "${status}"; fails=$((fails + 1))
fi

check want "SYSTEM.md"        "the specification is scored"
check want "README.md"        "the public page is scored"
check want "SKILL.md"         "a skill is scored, because a skill is published too"
check want "over the gate"    "a file over the gate is named, not buried"
check want "does not block"   "the report says plainly that it does not block"
check want "section 7"        "it names the section that sets the gate"

# The named list must carry a score, or the reader has to go and measure it again.
if printf '%s' "${out}" | grep -qE '^  [^ ]+\.md +[0-9]+\.[0-9]+$'; then
  printf 'ok    each named file carries its own score\n'
else
  printf 'FAIL  a named file arrived without its score\n'; fails=$((fails + 1))
fi

# Every file it scores must exist. A gate that scores a path nobody has is lying.
missing=""
while read -r f; do
  [[ -z "${f}" ]] && continue
  [[ -f "${root}/${f}" ]] || missing="${missing} ${f}"
done < <(printf '%s' "${out}" | grep -oE '^  [^ ]+\.md' | sed 's/^  //' | sort -u)
if [[ -z "${missing}" ]]; then
  printf 'ok    every scored path exists in the tree\n'
else
  printf 'FAIL  scored a path that does not exist:%s\n' "${missing}"; fails=$((fails + 1))
fi

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
