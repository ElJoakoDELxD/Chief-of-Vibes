#!/usr/bin/env bash
#
# Bench for tools/bin/clock and tools/bin/header: the format holds, a method is
# tested before it is saved, a saved method is reused, a broken one is replaced,
# and a reading 3+ minutes from the reference raises DESFASE without failing.

set -uo pipefail
cd "$(dirname "$0")/.."
bin="$PWD/tools/bin"
tmp="$(mktemp -d)"; trap 'rm -rf "${tmp}"' EXIT
fail=0
check() { if eval "$2"; then :; else echo "FAIL: $1"; fail=1; fi; }
now="$(date -u +%s)"
export COV_CLOCK_RECORD="${tmp}/methods.tsv" COV_CLOCK_SIGNATURE="Test/bench" COV_CLOCK_REFERENCE_EPOCH="${now}"

out="$(TS_ZONE=UTC "${bin}/clock" 2>"${tmp}/err")"
check "format" '[[ "${out}" =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}\ [0-9]{2}:[0-9]{2}\ \+00$ ]]'
check "saved after testing" 'grep -q "^Test/bench	date_tzdata	" "${COV_CLOCK_RECORD}"'
check "says it saved" 'grep -q "tested and saved" "${tmp}/err"'

TS_ZONE=UTC "${bin}/clock" >/dev/null 2>"${tmp}/err2"
check "reused, not saved twice" '[[ $(wc -l < "${COV_CLOCK_RECORD}") -eq 1 ]] && ! grep -q "saved" "${tmp}/err2"'

printf 'Test/bench\tno_such_method\t2026-01-01\tx\n' > "${COV_CLOCK_RECORD}"
TS_ZONE=UTC "${bin}/clock" >/dev/null 2>/dev/null
check "unknown saved method replaced" 'grep -q "	date_tzdata	" "${COV_CLOCK_RECORD}"'

out="$(TS_ZONE=UTC COV_CLOCK_REFERENCE_EPOCH=$(( now - 600 )) "${bin}/clock" 2>"${tmp}/err3")"; rc=$?
check "DESFASE reported" 'grep -q "^DESFASE" "${tmp}/err3"'
check "DESFASE still prints the time" '[[ ${rc} -eq 0 && -n "${out}" ]]'
TS_ZONE=UTC COV_CLOCK_REFERENCE_EPOCH=$(( now - 60 )) "${bin}/clock" >/dev/null 2>"${tmp}/err4"
check "under 3 minutes is quiet" '! grep -q DESFASE "${tmp}/err4"'
TS_ZONE=UTC TS_CTX_DATE=1999-01-01 "${bin}/clock" >/dev/null 2>"${tmp}/err5"
check "context date mismatch is DESFASE" 'grep -q "context date" "${tmp}/err5"'

check "unknown zone prints nothing" '[[ -z "$(TS_ZONE=Nowhere/Void "${bin}/clock" 2>/dev/null)" ]]'

h="$(echo "01-02-2026 03:04 +00" | CLAUDE_CODE_SESSION_ID=bench CLAUDE_EFFORT=low "${bin}/header" 2>/dev/null)"
check "header shape" '[[ "${h}" =~ ^\[01-02-2026\ 03:04\ \+00\ ·\ .+\ ·\ .+/.+\ ·\ .+·effort:\?\]$ ]]'
tdir="${tmp}/home/.claude/projects/$(printf '%s' "$PWD" | sed 's#[^A-Za-z0-9]#-#g')"; mkdir -p "${tdir}"
reply() { printf '{"type":"assistant","message":{"model":"m-test","content":[{"type":"text","text":"say \\"model\\":\\"m-quoted\\""}]},"effort":"xhigh","timestamp":"%s"}\n' "$1"; }
{ reply "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"; printf '{"type":"user","content":"\\"type\\":\\"assistant\\",\\"model\\":\\"m-old\\""}\n'; } > "${tdir}/fresh.jsonl"
reply "$(date -u -d '-10 min' +%Y-%m-%dT%H:%M:%S.000Z)" > "${tdir}/stale.jsonl"
h2="$(echo "t" | HOME="${tmp}/home" CLAUDE_CODE_SESSION_ID=fresh CLAUDE_EFFORT=low "${bin}/header" --self 10 2>/dev/null)"
check "model and effort from this turn's record" '[[ "${h2}" == *"· m-test·effort:xhigh]" ]]'
check "effort never the label or self-declared" '[[ "${h2}" != *low* && "${h2}" != *10* ]]'
h3="$(echo "t" | HOME="${tmp}/home" CLAUDE_CODE_SESSION_ID=stale "${bin}/header" 2>"${tmp}/err6")"
check "an earlier turn is never used" '[[ "${h3}" == *"· ?·effort:?]" ]] && grep -q "not this turn" "${tmp}/err6"'
TMPDIR="${tmp}" CLAUDE_CODE_SESSION_ID=bench "${bin}/header" --declare function=onboard
h="$(echo "t" | TMPDIR="${tmp}" CLAUDE_CODE_SESSION_ID=bench "${bin}/header" 2>/dev/null)"
check "declared function shows" '[[ "${h}" == *"/onboard ·"* ]]'

[[ ${fail} -eq 0 ]] && echo "tools/bin/clock: bench passed"
exit ${fail}
