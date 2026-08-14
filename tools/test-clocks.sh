#!/usr/bin/env bash
#
# Bench for tools/clocks.sh, the sensor behind CLOCKS.md. It pins both
# directions, because a reach record is worth exactly as much as its refusals:
# a row that arrives without a measurement behind it turns the file into a
# claim, and a claim is what LANGUAGES.md and this file both exist not to be.
#
# The case that matters most is the quiet one. An unconfigured zone falls back
# to UTC, and UTC needs no database on any platform, so recording it would say
# a machine can tell the time when all it did was take the default.
#
# Usage:  bash tools/test-clocks.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

fail=0
check() {
  local name="$1" expected="$2" got="$3"
  if [[ "${got}" == *"${expected}"* ]]; then echo "ok   ${name}"
  else echo "FAIL ${name}"; echo "     expected to contain: ${expected}"
       echo "     got: ${got:-<empty>}"; fail=1; fi
}
check_silent() {
  local name="$1" got="$2"
  if [[ -z "${got}" ]]; then echo "ok   ${name}"
  else echo "FAIL ${name}"; echo "     expected silence, got: ${got}"; fail=1; fi
}

platform="$(uname -s | cut -d- -f1)"

# A fixture with a CLOCKS.md holding the given rows, and a state.md with a zone.
build() {
  local dir="${tmp}/$1" zone="$2" rows="$3"
  rm -rf "${dir}"; mkdir -p "${dir}/tools" "${dir}/memory"
  cp "${here}/clocks.sh" "${dir}/clocks.sh"
  cp "${here}/now.sh" "${dir}/tools/now.sh"
  if [[ -n "${zone}" ]]; then
    printf -- '---\ntimezone: %s\n---\n' "${zone}" > "${dir}/memory/state.md"
  fi
  printf '# Clocks\n\n| Platform | Origin | First recorded |\n|---|---|---|\n%s\n' "${rows}" \
    > "${dir}/CLOCKS.md"
  printf '%s' "${dir}"
}
run() { ( cd "$1" && bash clocks.sh "${2-}" 2>&1 ); }

# What this platform's origin actually is, measured rather than assumed, so the
# bench pins the same pair the sensor will compute.
probe="$(build probe UTC "")"
printf -- '---\ntimezone: America/New_York\n---\n' > "${probe}/memory/state.md"
origin="$( cd "${probe}" && bash tools/now.sh --origin 2>/dev/null )"
echo "     (this platform: ${platform}, origin: ${origin})"

# --- it speaks when the pair is absent ----------------------------------------
d="$(build absent America/New_York "| \`Some/Other\` | \`zone-database\` | 2026-01-01 |")"
out="$(run "${d}")"
check "an unrecorded platform is reported" "has no row for" "${out}"
check "and the row names the origin that answered" "${origin}" "${out}"

out="$(run "${d}" --line)"
check "--line prints a row ready to add" "| \`${platform}\` | \`${origin}\` |" "${out}"

# --- it stays quiet when the pair is there ------------------------------------
d="$(build present America/New_York "| \`${platform}\` | \`${origin}\` | 2026-08-11 |")"
check_silent "a recorded pair says nothing" "$(run "${d}")"

# A platform recorded through the OTHER origin is still a finding: the pair is
# what teaches, not the platform alone.
other="zone-database"; [[ "${origin}" == "zone-database" ]] && other="python-zoneinfo"
d="$(build otherorigin America/New_York "| \`${platform}\` | \`${other}\` | 2026-08-11 |")"
out="$(run "${d}")"
check "the same platform through a second origin is reported" "has no row for" "${out}"

# --- the refusals -------------------------------------------------------------
# No zone configured means the UTC default answered, which is not reach.
d="$(build nozone "" "| \`Some/Other\` | \`zone-database\` | 2026-01-01 |")"
check_silent "an unconfigured zone records nothing" "$(run "${d}")"

# A zone nothing can resolve produced no time, so there is nothing to record and
# now.sh has already said why. Two voices for one failure is one too many.
d="$(build badzone Not/AZone "| \`Some/Other\` | \`zone-database\` | 2026-01-01 |")"
check_silent "an unresolvable zone records nothing" "$(run "${d}")"

# Without the file there is no record to be absent from, which is the canon
# before its first row and any tree that removed it.
d="$(build nofile America/New_York "")"
rm -f "${d}/CLOCKS.md"
check_silent "no CLOCKS.md means no report" "$(run "${d}")"

# --- a sensor never blocks ----------------------------------------------------
d="$(build exitcode America/New_York "")"
( cd "${d}" && bash clocks.sh >/dev/null 2>&1 )
[[ $? -eq 0 ]] && echo "ok   reporting still exits 0" \
  || { echo "FAIL reporting still exits 0"; fail=1; }

if (( fail )); then
  echo "tools/clocks.sh: bench FAILED"
  exit 1
fi
echo "tools/clocks.sh: bench passed"
