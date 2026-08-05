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

# Real backlog items are wrapped Markdown bullets, so the tag lands wherever
# there was room. A fixture of one-line bullets is a fixture that cannot see
# the failure this sensor actually had.
cat > "${tmp}/backlog.md" <<EOF
# Backlog

## Agent

- **A finding that has waited.** #propagate:${old}
- **A finding filed today.** #propagate:${today}
- **A finding with no date.** #propagate
- **An ordinary item.** Nothing to send upstream.
- **A tag with a broken date.** #propagate:99-99-9999
- **A wrapped finding.** Its first line says what it is, and the prose runs on
  for a while before the tag turns up somewhere in the middle of a sentence
  #propagate:${old} that keeps going afterwards.
- **A finding whose tag sits alone.** The prose ends and the tag gets its own
  line, with nothing else on it.
  \`#propagate:${old}\`
- **A finding with a title far longer than the width this sensor prints, written
  to run past eighty-eight characters so the cut has to land somewhere.**
  #propagate:${old}
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

# The three the sensor used to get wrong, because it printed the physical line
# the tag landed on rather than the item it belongs to.
check want     "A wrapped finding."          "a tag mid-sentence still names its item"
check want-not "that keeps going afterwards" "the report is the item, not the line under the tag"
check want     "A finding whose tag sits alone." "a tag alone on its line still names its item"
check want-not "  9 days: $"                 "no report is ever an empty line"
check want     "…"                           "a title over the width ends in an ellipsis"
check want-not "writt…"                      "the cut lands between words, never inside one"
check want     "undated"      "a tag with no date is reported as undated"
check want     "bad date"     "a tag with a broken date is named, never guessed"
check want-not "ordinary"     "an untagged item is left alone"

out="$(bash "${here}/candidates.sh" 2 "${tmp}/absent.md")"
check want-not "days"         "a missing backlog is silence, not an error"

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
