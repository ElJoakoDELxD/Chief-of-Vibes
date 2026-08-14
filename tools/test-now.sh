#!/usr/bin/env bash
#
# Bench for tools/now.sh. This is the only rung-1 guarantee in the system with a
# behaviour worth pinning: a timestamp cannot pass itself off as something else
# (SYSTEM.md section 1). Everything here exists to pin one of the two halves.
#
#   - It answers where it can. Two origins are tried, the platform's zone
#     database and python3's own copy of it, so a platform that ships no
#     database does not cost the agent its header.
#   - It never answers where it cannot. A zone that neither origin resolves
#     prints nothing at all. Local time is never substituted, which is the
#     failure that would be invisible: a plausible clock, in the wrong zone.
#
# TZDIR is pointed at an empty directory to simulate a platform with no zone
# database, which is what Windows is. That is the case that used to fail.
#
# Usage:  bash tools/test-now.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
empty="${tmp}/no-zone-database"
mkdir -p "${empty}"
trap 'rm -rf "${tmp}"' EXIT

fail=0
report() {
  local name="$1" ok="$2" detail="$3"
  if [[ "${ok}" == "yes" ]]; then echo "ok   ${name}"
  else echo "FAIL ${name}"; echo "     ${detail}"; fail=1; fi
}

# A working directory holding one state.md with the given timezone line. An
# empty argument writes no timezone at all, which is the exit-2 case.
build() {
  local dir="${tmp}/$1" zone="${2-}"
  rm -rf "${dir}"; mkdir -p "${dir}/memory"
  cp "${here}/now.sh" "${dir}/now.sh"
  if [[ -n "${zone}" ]]; then
    printf -- '---\ntimezone: %s\n---\n' "${zone}" > "${dir}/memory/state.md"
  else
    printf -- '---\nagent: Nameless\n---\n' > "${dir}/memory/state.md"
  fi
  printf '%s' "${dir}"
}

# Runs now.sh in a fixture. With a second argument, TZDIR is forced to an empty
# directory first, so only the python origin can answer.
run() {
  local dir="$1" blind="${2-}"
  if [[ -n "${blind}" ]]; then
    ( cd "${dir}" && TZDIR="${empty}" bash now.sh 2>/dev/null )
  else
    ( cd "${dir}" && bash now.sh 2>/dev/null )
  fi
}

STAMP='^[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2} [+-][0-9]{2}(:[0-9]{2})?'

# --- it answers ---------------------------------------------------------------
d="$(build ok America/New_York)"
out="$(run "${d}")"; code=$?
[[ "${out}" =~ ${STAMP} && ${code} -eq 0 ]] \
  && report "a configured zone prints a stamp and exits 0" yes "" \
  || report "a configured zone prints a stamp and exits 0" no "exit=${code} out=${out:-<empty>}"

# The case this bench was written for. No zone database on the platform at all,
# which is every Windows machine, and the answer still has to come out.
d="$(build blind America/New_York)"
out="$(run "${d}" blind)"; code=$?
[[ "${out}" =~ ${STAMP} && ${code} -eq 0 ]] \
  && report "with no zone database, python answers instead" yes "" \
  || report "with no zone database, python answers instead" no "exit=${code} out=${out:-<empty>}"

# Both origins must agree, or one of them is quietly wrong. Compared to the
# minute, because the two calls are not simultaneous.
d="$(build agree Asia/Tokyo)"
a="$(run "${d}")"; b="$(run "${d}" blind)"
[[ -n "${a}" && "${a}" == "${b}" ]] \
  && report "both origins print the same time" yes "" \
  || report "both origins print the same time" no "database=${a:-<empty>} python=${b:-<empty>}"

# UTC is exempt from the database check, so a bare container still works.
d="$(build utc UTC)"
out="$(run "${d}" blind)"
[[ "${out}" =~ \+00$ ]] \
  && report "UTC works with no database" yes "" \
  || report "UTC works with no database" no "out=${out:-<empty>}"

# --- the offset is compacted, and a half-hour zone keeps its minutes ----------
d="$(build half Asia/Kolkata)"
out="$(run "${d}" blind)"
[[ "${out}" == *"+05:30" ]] \
  && report "a half-hour offset keeps its minutes" yes "" \
  || report "a half-hour offset keeps its minutes" no "out=${out:-<empty>}"

# --- it refuses ---------------------------------------------------------------
# The important half. A zone nothing can resolve prints NOTHING, because a
# plausible time in the wrong zone is the one error nobody downstream can catch.
d="$(build bad Not/AZone)"
out="$(run "${d}")"; code=$?
[[ -z "${out}" && ${code} -eq 1 ]] \
  && report "an unresolvable zone prints nothing and exits 1" yes "" \
  || report "an unresolvable zone prints nothing and exits 1" no "exit=${code} out=${out}"

d="$(build traverse ../../etc)"
out="$(run "${d}")"; code=$?
[[ -z "${out}" && ${code} -eq 1 ]] \
  && report "a traversing zone name is refused" yes "" \
  || report "a traversing zone name is refused" no "exit=${code} out=${out}"

# --- no zone configured at all ------------------------------------------------
# Exit 2 is a different event from exit 1: there IS a reading, and it carries
# its own marking so a caller cannot mistake the default for an answer.
d="$(build nozone)"
out="$(run "${d}")"; code=$?
[[ "${out}" == *"UTC default"* && ${code} -eq 2 ]] \
  && report "no zone configured prints a marked value and exits 2" yes "" \
  || report "no zone configured prints a marked value and exits 2" no "exit=${code} out=${out:-<empty>}"

# The hook has to keep that value rather than throw it away with the exit code.
grep -q 'now_exit' "${here}/../.claude/hooks/anchor.sh" \
  && report "the anchor hook reads the exit code instead of discarding output" yes "" \
  || report "the anchor hook reads the exit code instead of discarding output" no "anchor.sh drops an exit-2 reading"

if (( fail )); then
  echo "tools/now.sh: bench FAILED"
  exit 1
fi
echo "tools/now.sh: bench passed"
