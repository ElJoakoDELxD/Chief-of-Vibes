#!/usr/bin/env bash
#
# Reports findings the agent kept instead of sending upstream.
#
# Rung 3 (SYSTEM.md section 8): it reports, and it never blocks. A finding that
# generalizes reaches other copies only if somebody sends it, and noticing is a
# judgment that misses. So the wait is measured here instead of remembered.
#
# A backlog line carries the tag #propagate:DD-MM-YYYY. The date is in the tag,
# not in git, so an edit to the entry does not reset its age.
#
# Usage:  bash tools/candidates.sh [days]     # default 2

set -uo pipefail
days="${1:-2}"
file="${2:-memory/backlog.md}"
[[ -f "${file}" ]] || exit 0

today_epoch="$(date +%s)"

grep -n '#propagate' "${file}" 2>/dev/null | while IFS= read -r hit; do
  line="${hit#*:}"
  tag="$(printf '%s' "${line}" | grep -oE '#propagate:[0-9]{2}-[0-9]{2}-[0-9]{4}' || true)"

  if [[ -z "${tag}" ]]; then
    printf '  undated: %s\n' "$(printf '%s' "${line}" \
      | sed -E 's/^[[:space:]*_-]+//; s/\*\*//g' | cut -c1-88)"
    continue
  fi

  d="${tag#\#propagate:}"
  iso="${d:6:4}-${d:3:2}-${d:0:2}"
  filed_epoch="$(date -d "${iso}" +%s 2>/dev/null || true)"
  [[ -n "${filed_epoch}" ]] || { printf '  bad date: %s\n' "${tag}"; continue; }

  age=$(( (today_epoch - filed_epoch) / 86400 ))
  if (( age >= days )); then
    printf '  %s days: %s\n' "${age}" "$(printf '%s' "${line}" \
      | sed -E "s/${tag}//; s/^[[:space:]*_-]+//; s/\*\*//g" | cut -c1-88)"
  fi
done
