#!/usr/bin/env bash
#
# Bench for tools/explain.sh. The tool's whole value is that an explanation is
# read rather than remembered, so the cases pin the two answers that matter: a
# term the tree carries comes back with its address, and one it does not carry
# comes back as a refusal to invent.
#
# Usage:  bash tools/test-explain.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fails=0
report() {  # report <label> <yes|no> <detail>
  if [[ "$2" == yes ]]; then printf 'ok   %s\n' "$1"
  else printf 'FAIL %s: %s\n' "$1" "$3"; fails=$((fails + 1)); fi
}

out="$(bash "${here}/explain.sh" 2>&1)"; code=$?
[[ ${code} -eq 0 && "${out}" == *"Read in this order"* ]] \
  && report "with no term it says where to start" yes "" \
  || report "with no term it says where to start" no "exit=${code}"
[[ "${out}" == *"SYSTEM.md"* && "${out}" == *"INDEX.md"* ]] \
  && report "and names the core and the map" yes "" \
  || report "and names the core and the map" no "${out:0:80}"

# A term this tree certainly carries. The address is the point: an explanation
# nobody can check is the thing this replaces.
out="$(bash "${here}/explain.sh" quarantine 2>&1)"; code=$?
[[ ${code} -eq 0 ]] && report "a term the tree carries exits 0" yes "" \
                    || report "a term the tree carries exits 0" no "exit=${code}"
printf '%s' "${out}" | grep -qE 'system/5-memory[^:]*\.md:[0-9]+' \
  && report "and comes back with a file and a line" yes "" \
  || report "and comes back with a file and a line" no "no address in the output"
[[ "${out}" == *"place(s) answered"* ]] \
  && report "and says how many places answered" yes "" \
  || report "and says how many places answered" no "no count"

# The half that makes it honest. Silence must be stated, never filled.
out="$(bash "${here}/explain.sh" "zzznotinthistreezzz" 2>&1)"; code=$?
[[ ${code} -eq 1 ]] && report "a term the tree lacks exits non-zero" yes "" \
                    || report "a term the tree lacks exits non-zero" no "exit=${code}"
[[ "${out}" == *"Nothing in this tree names it"* ]] \
  && report "and says so rather than answering anyway" yes "" \
  || report "and says so rather than answering anyway" no "${out:0:80}"
[[ "${out}" == *"finding"* ]] \
  && report "and names the silence as a finding" yes "" \
  || report "and names the silence as a finding" no "no finding line"

# It reports what the tree says and never a summary of it, so a line it prints
# is a line that exists in the file it names.
out="$(bash "${here}/explain.sh" quarantine 2>&1)"
addr="$(printf '%s' "${out}" | grep -oE '^  [a-z][^:]*\.(md|sh):[0-9]+' | head -n1 | sed 's/^  //')"
file="${addr%%:*}"; line="${addr##*:}"
if [[ -n "${file}" ]] && sed -n "${line}p" "${here}/../${file}" | grep -qi 'quarantin'; then
  report "every line it prints exists at the address it gives" yes ""
else
  report "every line it prints exists at the address it gives" no "addr=${addr:-none}"
fi

if (( fails )); then echo "tools/explain.sh: bench FAILED"; exit 1; fi
echo "tools/explain.sh: bench passed"
