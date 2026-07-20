#!/usr/bin/env bash
#
# Prints the current time as "DD-MM-YYYY HH:MM ±TZ" in the agent's timezone.
# The zone comes from the `timezone:` field in memory/state.md's YAML
# frontmatter; without a state file it defaults to UTC.
#
# Exits non-zero with a message on stderr when the zone cannot be resolved,
# so callers report a missing clock instead of printing a wrong one.
#
# Usage:  bash tools/now.sh      →  13-07-2026 03:16 +00

set -euo pipefail

zone="UTC"
if [[ -f memory/state.md ]]; then
  configured="$(awk '
    /^---[[:space:]]*$/ { fence++; next }
    fence == 1 && $1 == "timezone:" { gsub(/["'\''`]/, "", $2); print $2; exit }
  ' memory/state.md)"
  [[ -n "${configured}" ]] && zone="${configured}"
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
TZ="${zone}" date '+%d-%m-%Y %H:%M %z' \
  | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/; s/:00$//'
