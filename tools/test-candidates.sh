#!/usr/bin/env bash
#
# Bench for tools/candidates.sh. It pins what must be reported and what must be
# left alone. A sensor that fires on the wrong thing teaches the agent to stop
# reading it (SYSTEM.md section 8).
#
# Usage:  bash tools/test-candidates.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

old="$(date -d '9 days ago' '+%d-%m-%Y')"
today="$(date '+%d-%m-%Y')"

cat > "${tmp}/backlog.md" <<EOF
# Backlog

## Agent

- **A finding that has waited.** #propagate:${old}
- **A finding filed today.** #propagate:${today}
- **A finding with no date.** #propagate
- **An ordinary item.** Nothing to send upstream.
- **A tag with a broken date.** #propagate:99-99-9999
EOF

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

out="$(bash "${here}/candidates.sh" 2 "${tmp}/backlog.md")"

check want     "9 days"       "a finding that waited nine days is reported"
check want     "has waited"   "the report names the finding, not only its age"
check want-not "filed today"  "a finding filed today is left alone"
check want     "undated"      "a tag with no date is reported as undated"
check want     "bad date"     "a tag with a broken date is named, never guessed"
check want-not "ordinary"     "an untagged item is left alone"

out="$(bash "${here}/candidates.sh" 2 "${tmp}/absent.md")"
check want-not "days"         "a missing backlog is silence, not an error"

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
