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
# The colon is required, and it is what separates a tag from the tag's name.
# Matching the bare word made any sentence *about* this tool into an item: on
# 07-09-2026 the sensor reported exactly one candidate waiting, and it was a
# line of prose naming the tag, while eleven real candidates carried no tag and
# were invisible. Backticks cannot make that distinction, because a real tag is
# often written inside them.
#
# A tag whose date is missing or malformed keeps the colon, so it still reaches
# the undated path. What the colon rule gives up is a bare `#propagate` on an
# item that never says it is a candidate, and the check below covers the case
# that matters.
#
# The mirror of that failure is checked too: an item that calls itself a
# candidate for upstream and carries no dated tag is a candidate nothing is
# measuring. Reporting the tagged ones while the untagged sit beside them is a
# sensor answering a question nobody asked.
#
# One item, one line, however many tags it carries. An entry that absorbed a
# second finding carries that finding's tag too, and reporting per tag counted
# it twice: on 14-08-2026 the report said eleven where nine were open. A count
# nobody can reconcile with the list under it is worse than no count, because
# the number is the part that gets repeated.
#
# The OLDEST tag governs, and it is found rather than assumed. A tag is appended
# wherever there was room, so file order is not date order: taking the first one
# read would have reported that entry as five days old when it had been waiting
# eleven. An age that under-reports is the one direction a waiting-time sensor
# must never round.
#
# A struck-through title is closed. `~~like this~~` is how a resolved entry is
# marked, and one of those kept reporting for a day after it fell.
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
# The line number of the bullet an item starts on. That is what identifies an
# item: the accumulated text is not, because it grows with how far down the tag
# sits, so two tags in one entry produce two different strings and defeat any
# dedup built on them. Measured on 14-08-2026, and it is why the count read
# eleven against a list of nine.
bullet_of() {  # bullet_of <line-number>
  awk -v n="$1" '
    NR > n { exit }
    /^[[:space:]]*[-*][[:space:]]/ { b = NR }
    END { print b + 0 }
  ' "${file}"
}

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
# Every tag comes out of the display text, not only the one that governed the
# age. An entry with two of them showed the other one mid-sentence, which reads
# as the sensor leaking its own markup at the Principal.
tidy() {  # tidy <text> [tag-to-remove]
  printf '%s' "$1" \
    | sed -E "s/#propagate:[0-9]{2}-[0-9]{2}-[0-9]{4}//g; ${2:+s/${2}//;} s/^[[:space:]*_-]+//; s/\*\*//g; s/\`//g; s/[[:space:]]+/ /g; s/[[:space:]]+\$//" \
    | awk '{ if (length($0) <= 88) print; else { s = substr($0, 1, 88); sub(/[[:space:]][^[:space:]]*$/, "", s); print s "…" } }'
}

# One pass gathers, per item, the line its bullet starts on and the oldest tag
# under it. Reporting then walks items instead of tags.
gathered="$(
  grep -n '#propagate:' "${file}" 2>/dev/null | while IFS= read -r hit; do
    lineno="${hit%%:*}"
    raw="${hit#*:}"
    tag="$(printf '%s' "${raw}" | grep -oE '#propagate:[0-9]{2}-[0-9]{2}-[0-9]{4}' || true)"
    if [[ -z "${tag}" ]]; then
      # NODATE, not a digit string: 99-99-9999 is a real broken tag and it
      # collapses to 99999999, which a numeric sentinel would swallow. The
      # bench caught that, which is what a bench is for.
      printf '%s\t%s\t%s\n' "$(bullet_of "${lineno}")" "NODATE" "${lineno}"
    else
      d="${tag#\#propagate:}"
      printf '%s\t%s\t%s\n' "$(bullet_of "${lineno}")" "${d:6:4}${d:3:2}${d:0:2}" "${lineno}"
    fi
  done | sort -t"$(printf '\t')" -k1,1n -k2,2 | awk -F'\t' '!seen[$1]++'
)"

# Untagged candidates: an item that says it is one and carries no dated tag.
# Walked per item, because the phrase and the tag rarely share a line.
untagged="$(
  awk '
    /^[[:space:]]*[-*][[:space:]]/ { flush(); start = NR; text = $0; next }
    start { text = text " " $0 }
    END { flush() }
    function flush(   lower) {
      if (!start) return
      lower = tolower(text)
      if (index(lower, "candidate for upstream") && !index(text, "#propagate:") \
          && !index(text, "~~"))
        print start
      start = 0; text = ""
    }
  ' "${file}"
)"
if [[ -n "${untagged}" ]]; then
  while IFS= read -r lineno; do
    [[ -n "${lineno}" ]] || continue
    item="$(title_of "${lineno}")"
    printf '  untagged: %s\n' "$(tidy "${item}" '#propagate')"
  done <<< "${untagged}"
  echo "  Those carry no #propagate:DD-MM-YYYY, so nothing is measuring how long they have waited."
fi

[[ -n "${gathered}" ]] || exit 0

while IFS=$'\t' read -r bullet iso8 lineno; do
  [[ -n "${bullet}" ]] || continue
  item="$(title_of "${lineno}")"
  [[ -n "${item}" ]] || continue

  # A resolved entry is struck through, and a closed thing is not waiting.
  case "${item}" in *'~~'*) continue ;; esac

  if [[ "${iso8}" == "NODATE" ]]; then
    text="$(tidy "${item}" '#propagate')"
    printf '  undated: %s\n' "${text:-(untitled item at line ${lineno})}"
    continue
  fi
  tag="#propagate:${iso8:6:2}-${iso8:4:2}-${iso8:0:4}"

  iso="${iso8:0:4}-${iso8:4:2}-${iso8:6:2}"
  filed_epoch="$(date -d "${iso}" +%s 2>/dev/null || true)"
  [[ -n "${filed_epoch}" ]] || { printf '  bad date: %s\n' "${tag}"; continue; }

  age=$(( (today_epoch - filed_epoch) / 86400 ))
  if (( age >= days )); then
    text="$(tidy "${item}" "${tag}")"
    printf '  %s days: %s\n' "${age}" "${text:-(untitled item at line ${lineno})}"
  fi
done <<< "${gathered}"
