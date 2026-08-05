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
# What it reports is the item, never the line the tag landed on. A backlog item
# is a Markdown bullet and prose wraps, so the tag sits wherever there was room:
# reporting that line reports a fragment, or nothing at all when the tag sits
# alone. A rung 3 that prints noise teaches the agent to stop reading it, which
# costs more than the sensor buys (SYSTEM.md section 8).
#
# Usage:  bash tools/candidates.sh [days]     # default 2

set -uo pipefail
days="${1:-2}"
file="${2:-memory/backlog.md}"
[[ -f "${file}" ]] || exit 0

today_epoch="$(date +%s)"

# The item a line belongs to: the nearest bullet at or above it, joined with
# the lines it wraps onto. Taking the bullet's first physical line alone would
# cut a title mid-clause, which is the same fragment problem one level up.
title_of() {  # title_of <line-number>
  awk -v n="$1" '
    NR > n { exit }
    /^[[:space:]]*[-*][[:space:]]/ { t = $0; wrapping = 1; next }
    /^[[:space:]]*$/ { wrapping = 0; next }
    wrapping { sub(/^[[:space:]]+/, ""); t = t " " $0 }
    END { print t }
  ' "${file}"
}

# Strip the markup a person does not need, and end on a word rather than
# mid-syllable. A cut that lands inside a word reads as a broken sensor.
tidy() {  # tidy <text> [tag-to-remove]
  printf '%s' "$1" \
    | sed -E "${2:+s/${2}//;} s/^[[:space:]*_-]+//; s/\*\*//g; s/\`//g; s/[[:space:]]+/ /g; s/[[:space:]]+\$//" \
    | awk '{ if (length($0) <= 88) print; else { s = substr($0, 1, 88); sub(/[[:space:]][^[:space:]]*$/, "", s); print s "…" } }'
}

grep -n '#propagate' "${file}" 2>/dev/null | while IFS= read -r hit; do
  lineno="${hit%%:*}"
  raw="${hit#*:}"
  item="$(title_of "${lineno}")"
  [[ -n "${item}" ]] || item="${raw}"
  tag="$(printf '%s' "${raw}" | grep -oE '#propagate:[0-9]{2}-[0-9]{2}-[0-9]{4}' || true)"

  if [[ -z "${tag}" ]]; then
    text="$(tidy "${item}" '#propagate')"
    printf '  undated: %s\n' "${text:-(untitled item at line ${lineno})}"
    continue
  fi

  d="${tag#\#propagate:}"
  iso="${d:6:4}-${d:3:2}-${d:0:2}"
  filed_epoch="$(date -d "${iso}" +%s 2>/dev/null || true)"
  [[ -n "${filed_epoch}" ]] || { printf '  bad date: %s\n' "${tag}"; continue; }

  age=$(( (today_epoch - filed_epoch) / 86400 ))
  if (( age >= days )); then
    text="$(tidy "${item}" "${tag}")"
    printf '  %s days: %s\n' "${age}" "${text:-(untitled item at line ${lineno})}"
  fi
done
