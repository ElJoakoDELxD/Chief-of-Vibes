#!/usr/bin/env bash
#
# Prints the current time as "DD-MM-YYYY HH:MM ±TZ" in the agent's timezone.
# The zone comes from the `timezone:` field in memory/state.md's frontmatter.
#
# Two failures, two different exits, because they are not the same thing:
#   - a configured zone that does not exist  → exit 1, nothing printed
#   - no zone configured at all              → exit 2, UTC printed and SAID SO
#
# The second matters more than it looks. A bare `+00` is indistinguishable from
# a Principal who really is in UTC, so a caller stamps a default as an answer
# and nothing downstream can tell. Marking it is what makes the difference
# visible; exiting 2 is what makes it checkable without reading the string.
#
# Usage:  bash tools/now.sh      →  13-07-2026 03:16 +00

set -euo pipefail

zone="UTC"
defaulted=1
if [[ -f memory/state.md ]]; then
  configured="$(awk '
    /^---[[:space:]]*$/ { fence++; next }
    fence == 1 && $1 == "timezone:" { gsub(/["'\''`]/, "", $2); print $2; exit }
  ' memory/state.md)"
  if [[ -n "${configured}" ]]; then zone="${configured}"; defaulted=0; fi
fi

# `date` silently falls back to UTC for an unknown zone name; require the
# zone to exist in the system database so the printed time is never
# wrong-zone. Applies to every form — slashed (America/New_York) or not
# (EST5EDT). UTC is exempt so a bare container without tzdata still works.
if [[ "${zone}" != "UTC" ]]; then
  if [[ "${zone}" == *..* || ! -e "${TZDIR:-/usr/share/zoneinfo}/${zone}" ]]; then
    echo "now.sh: zone '${zone}' not found in ${TZDIR:-/usr/share/zoneinfo}; use an IANA zone (e.g. UTC, America/New_York) in memory/state.md" >&2
    exit 1
  fi
fi

# Compact the numeric offset: -0400 → -04, +0530 → +05:30.
stamp="$(TZ="${zone}" date '+%d-%m-%Y %H:%M %z' \
  | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/; s/:00$//')"

if [[ "${defaulted}" -eq 1 ]]; then
  printf '%s (UTC default — no timezone configured in memory/state.md)\n' "${stamp}"
  exit 2
fi
printf '%s\n' "${stamp}"
