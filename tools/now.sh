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
# Usage:  bash tools/now.sh             →  13-07-2026 03:16 +00
#         bash tools/now.sh --origin    →  python-zoneinfo  (exit 2 if no zone is set)
#
# --origin prints which of the two answered, and nothing else. It is what
# CLOCKS.md is built from: a platform is only recorded once an origin on it has
# actually produced a time, so the record cannot claim reach nobody measured.

set -euo pipefail

want_origin=0
[[ "${1-}" == "--origin" ]] && want_origin=1

zone="UTC"
defaulted=1
if [[ -f memory/state.md ]]; then
  configured="$(awk '
    /^---[[:space:]]*$/ { fence++; next }
    fence == 1 && $1 == "timezone:" { gsub(/["'\''`]/, "", $2); print $2; exit }
  ' memory/state.md)"
  if [[ -n "${configured}" ]]; then zone="${configured}"; defaulted=0; fi
fi

# Two origins can answer, and the tool asks both before it gives up. A negative
# answer is only as wide as the question behind it, and "this platform has no
# /usr/share/zoneinfo" was a narrow question wearing a general one's clothes.
#
#   1. `date` with the zone database the platform ships. Linux and macOS carry
#      one. Windows carries none at all, not an incomplete one, so every zone
#      but UTC fails there and the agent loses its header on a whole platform.
#   2. python3's `zoneinfo`, which reads that same database where it exists and
#      otherwise reads the `tzdata` package. python3 is already required to run
#      this repository, so this adds no dependency where the first origin works.
#
# What is deliberately NOT a third origin: the machine's local clock. Windows
# knows its own zone and can be asked for the time in it, but proving that zone
# is the configured one needs a Windows-to-IANA mapping that .NET Framework does
# not carry. Printing local time and hoping is the exact failure rung 1 exists to
# make impossible (SYSTEM.md section 1), so the tool fails loudly instead.
raw=""
origin=""

# `date` silently falls back to UTC for an unknown zone name, so the zone has to
# exist in the database before it is trusted. Applies to every form, slashed
# (America/New_York) or not (EST5EDT). UTC is exempt so a bare container with no
# database at all still works.
if [[ "${zone}" == "UTC" ]]; then
  raw="$(TZ=UTC date '+%d-%m-%Y %H:%M %z')"; origin="zone-database"
elif [[ "${zone}" != *..* && -e "${TZDIR:-/usr/share/zoneinfo}/${zone}" ]]; then
  raw="$(TZ="${zone}" date '+%d-%m-%Y %H:%M %z')"; origin="zone-database"
elif command -v python3 >/dev/null 2>&1; then
  raw="$(python3 - "${zone}" <<'PY' 2>/dev/null
import sys
from datetime import datetime
try:
    from zoneinfo import ZoneInfo
    print(datetime.now(ZoneInfo(sys.argv[1])).strftime("%d-%m-%Y %H:%M %z"))
except Exception:
    raise SystemExit(1)
PY
  )" || raw=""
  [[ -n "${raw}" ]] && origin="python-zoneinfo"
fi

if [[ -z "${raw}" ]]; then
  {
    printf "now.sh: zone '%s' could not be resolved, so no time is printed.\n" "${zone}"
    printf "  tried: the zone database at %s\n" "${TZDIR:-/usr/share/zoneinfo}"
    if command -v python3 >/dev/null 2>&1; then
      printf "  tried: python3's zoneinfo, which has no entry for it either\n"
      printf "  fix:   python3 -m pip install tzdata   (gives python the IANA database, and Windows ships none)\n"
      printf "         That is an install, so section 4 applies: only on a machine that keeps it.\n"
    else
      printf "  python3 is not on PATH, so the second origin could not be tried\n"
    fi
    printf "  or:    set a zone that exists in memory/state.md, such as UTC or America/New_York\n"
  } >&2
  exit 1
fi

if (( want_origin )); then
  printf '%s
' "${origin}"
  # An unconfigured zone falls back to UTC, and UTC needs no database anywhere.
  # Recording that as reach would claim a platform can tell the time when all it
  # did was take the default, so the exit code carries the difference through.
  [[ "${defaulted}" -eq 1 ]] && exit 2
  exit 0
fi

# Compact the numeric offset: -0400 → -04, +0530 → +05:30.
stamp="$(printf '%s' "${raw}" \
  | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/; s/:00$//')"

if [[ "${defaulted}" -eq 1 ]]; then
  printf '%s (UTC default — no timezone configured in memory/state.md)\n' "${stamp}"
  exit 2
fi
printf '%s\n' "${stamp}"
