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
  printf '#!/usr/bin/env bash\nexit %s\n' "${bench}" > tools/test-thing.sh
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
d="$(build green 1.0.0 "" 0)"
check "a green tree says so, with a count" "1 of 1 benches green" "$(run "${d}")"

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

if (( fail )); then
  echo "tools/ready.sh: bench FAILED"
  exit 1
fi
echo "tools/ready.sh: bench passed"
