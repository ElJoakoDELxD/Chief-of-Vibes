#!/usr/bin/env bash
#
# Bench for tools/ready.sh. The probe exists to stop a session editing the
# specification on a feeling, so the thing worth pinning is that it never
# replaces a missing number with a comfortable one.
#
# Usage:  bash tools/test-ready.sh

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

check_absent() {
  local name="$1" forbidden="$2" got="$3"
  if [[ "${got}" != *"${forbidden}"* ]]; then echo "ok   ${name}"
  else echo "FAIL ${name}"; echo "     must not contain: ${forbidden}"; fail=1; fi
}

# A repository with a version, an optional origin/main at another version, and
# one bench that passes or fails on demand.
build() {
  local dir="${tmp}/$1" here_v="$2" main_v="$3" bench="$4"
  rm -rf "${dir}"; mkdir -p "${dir}/tools" "${dir}/system" "${dir}/memory"
  cp "${here}/ready.sh" "${dir}/tools/ready.sh"
  cd "${dir}"
  git init -q .
  git config user.email bench@example.com
  git config user.name bench
  printf '**Version %s.** spec\n' "${main_v:-${here_v}}" > SYSTEM.md
  printf 'entry point\n' > CLAUDE.md
  printf 'index\n' > INDEX.md
  printf 'leaf\n' > system/1-purpose.md
  printf 'state\n' > memory/state.md
  # A healthy bench reports a case and exits 0. Exit code alone is not health:
  # one that dies before its first assertion also exits 0 (SYSTEM.md section 8).
  printf '#!/usr/bin/env bash\necho "ok   a case ran"\nexit %s\n' "${bench}" > tools/test-thing.sh
  git add -A && git commit -q -m base
  if [[ -n "${main_v}" ]]; then
    git branch -q -f main
    git update-ref refs/remotes/origin/main refs/heads/main
    printf '**Version %s.** spec\n' "${here_v}" > SYSTEM.md
  fi
  cd - >/dev/null
  printf '%s' "${dir}"
}
run() { ( cd "$1" && bash tools/ready.sh "${2-}" 2>&1 ); }

# --- the rails half -----------------------------------------------------------
# A bench that exits 0 having asserted nothing did not pass. Measured 08-09-2026:
# a sourced library replaced by `exit 0` made its bench print nothing, exit 0, and
# read as green wherever the exit code was the whole test.
d="$(build green 1.0.0 "" 0)"
check "a green tree says so, with a count" "1 of 1 benches green" "$(run "${d}")"

mute="$(build mute 1.0.0 "" 0)"
printf '#!/usr/bin/env bash\nexit 0\n' > "${mute}/tools/test-thing.sh"
check "a bench that asserted nothing is not green" "asserted nothing" "$(run "${mute}")"
check "and it counts as red rather than passing"   "1 red"            "$(run "${mute}")"

d="$(build red 1.0.0 "" 1)"
out="$(run "${d}")"
check "a red bench is named, not counted away" "RED   tools/test-thing.sh" "${out}"
check "and the summary says how many"          "0 green, 1 red"           "${out}"

# --- the parity half ----------------------------------------------------------
d="$(build gap 2.0.0 1.0.0 0)"
check "a version gap against origin/main is reported" "2.0.0 here against 1.0.0" "$(run "${d}")"

d="$(build same 1.0.0 1.0.0 0)"
check "parity is reported as parity" "matching origin/main" "$(run "${d}")"

# Nothing to compare against is not the same as being current, and silence here
# would read as parity — the mistake the drift check already refuses to make.
d="$(build noremote 1.0.0 "" 0)"
check "no origin/main is UNCHECKED, never assumed current" "parity is UNCHECKED" "$(run "${d}")"

d="$(build noversion "" "" 0)"
printf 'no version line\n' > "${d}/SYSTEM.md"
check "a missing version line is named" "carries no version line" "$(run "${d}")"

# --- the fee, and the half that cannot be measured ----------------------------
d="$(build fee 1.0.0 "" 0)"
out="$(run "${d}")"
check "the fee is reported in characters, which are measured" "chars of specification and memory" "${out}"
check "the divisor is stated, so the token figure names itself a conversion" "chars/token" "${out}"
check "the window it cannot see is UNREADABLE, not estimated" "UNREADABLE from here" "${out}"

out="$(run "${d}" --fee)"
check "--fee is one line and carries both numbers" "chars, about" "${out}"

# --- a probe never blocks ------------------------------------------------------
( cd "${tmp}/red" && bash tools/ready.sh >/dev/null 2>&1 )
[[ $? -eq 0 ]] && echo "ok   a red tree still exits 0, because this reports" \
  || { echo "FAIL a red tree still exits 0"; fail=1; }

# --- a tree that is not this one ---------------------------------------------
# The first version of this guard fired only where the directory was gone. A
# monitor copied the tool into a valid *wrong* directory and got a full confident
# report — "0 of 0 benches green" — which is the class the guard was named for.
wrong="${tmp}/wrongtree"; rm -rf "${wrong}"; mkdir -p "${wrong}/tools"
cp "${here}/ready.sh" "${wrong}/tools/ready.sh"
( cd "${wrong}" && git init -q . ) >/dev/null 2>&1
out="$( cd "${wrong}" && bash tools/ready.sh 2>&1 )"
check "a directory that is not this repository is refused" "is not this repository" "${out}"
check_absent "and no count is printed from it"             "benches green"          "${out}"

# --- what this change grows, and the three ways it got that wrong -------------
# Section 8's test was applied one release at a time. The measure that reports it
# shipped with three defects, each caught by a monitor rather than by this bench,
# which is why the bench exists now.

# 1. Nothing to compare against is not a growth of everything. A fabricated
#    reading inside a sensor is worse than no sensor (section 3).
solo="$(build solo 1.0.0 "" 0)"
check "with no origin/main the measure says so" "Growth against main: UNAVAILABLE" "$(run "${solo}")"
check_absent "and never prints a number instead" "prose +" "$(run "${solo}")"

# 2. A deletion has to move it. A measure that walks the working tree only cannot
#    see a payment-down, which is the one thing it exists to ask for.
paid="$(build paid 1.1.0 1.0.0 0)"
( cd "${paid}" && git rm -q system/1-purpose.md ) >/dev/null 2>&1
out="$(run "${paid}")"
printf '%s' "${out}" | grep -qE 'prose -[0-9]+ words' \
  && printf 'ok    a removed file shows as prose paid down\n' \
  || { printf 'FAIL  a removed file moved the number by nothing\n'; fail=1; }
check_absent "and one side falling is never called unfinished" "Both grew" "${out}"

# 3. Both growing is the case the rule is about, and it says so.
grew="$(build grew 1.1.0 1.0.0 0)"
( cd "${grew}" && printf 'a much longer leaf with many more words than before\n' >> system/1-purpose.md \
   && printf '#!/usr/bin/env bash\n# another line\n' > tools/extra.sh ) >/dev/null 2>&1
check "both growing is named as unfinished" "Both grew" "$(run "${grew}")"

if (( fail )); then
  echo "tools/ready.sh: bench FAILED"
  exit 1
fi
echo "tools/ready.sh: bench passed"
