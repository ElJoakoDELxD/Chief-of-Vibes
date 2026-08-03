#!/usr/bin/env bash
#
# Bench for tools/index.sh. It pins that the index is generated from the tree and
# that a stale one fails loudly. An index that drifts without saying so is worse
# than no index, because it will be trusted (SYSTEM.md section 1).
#
# Usage:  bash tools/test-index.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(dirname "${here}")"
fails=0

check() {  # check <want|want-not> <pattern> <label>
  local mode="$1" pat="$2" label="$3"
  if [[ "${mode}" == want && "${out}" == *"${pat}"* ]] \
  || [[ "${mode}" == want-not && "${out}" != *"${pat}"* ]]; then
    printf 'ok    %s\n' "${label}"
  else
    printf 'FAIL  %s\n' "${label}"; fails=$((fails + 1))
  fi
}

out="$(cd "${root}" && bash tools/index.sh)"
check want "# INDEX"                     "it generates an index"
check want "SYSTEM.md#3-operating-rules" "a section carries a link to where the rule lives"
check want "Verify before assert."       "a rule of section 3 is listed by its name alone"
check want-not "Verify before assert. A claim about" \
                                         "a rule name stops at the name, and does not swallow its body"
check want "tools/index.sh"              "the generator lists itself, because it reads the tree"
check want "5s"                          "a skill is listed"
check want "documents, memory, tree"     "a skill's leaves are named, so the agent knows what loads on demand"

# Every skill directory must appear. A skill that exists is listed by construction.
missing=""
for d in "${root}"/.claude/skills/*/; do
  n="$(basename "${d}")"
  [[ "${out}" == *"\`${n}\`"* ]] || missing="${missing} ${n}"
done
if [[ -z "${missing}" ]]; then
  printf 'ok    every skill in the directory appears\n'
else
  printf 'FAIL  skills missing from the index:%s\n' "${missing}"; fails=$((fails + 1))
fi

# --check is the part CI runs.
tmp="$(mktemp -d)"; trap 'rm -rf "${tmp}"' EXIT
cp -r "${root}/tools" "${root}/SYSTEM.md" "${tmp}/" 2>/dev/null
mkdir -p "${tmp}/.claude"; cp -r "${root}/.claude/skills" "${tmp}/.claude/" 2>/dev/null

( cd "${tmp}" && bash tools/index.sh > INDEX.md )
if ( cd "${tmp}" && bash tools/index.sh --check >/dev/null 2>&1 ); then
  printf 'ok    --check passes on a freshly generated index\n'
else
  printf 'FAIL  --check rejected an index it had just generated\n'; fails=$((fails + 1))
fi

printf '\n## An edit nobody regenerated\n' >> "${tmp}/INDEX.md"
if ( cd "${tmp}" && bash tools/index.sh --check >/dev/null 2>&1 ); then
  printf 'FAIL  --check accepted a hand-edited index\n'; fails=$((fails + 1))
else
  printf 'ok    --check rejects a hand-edited index\n'
fi

rm -f "${tmp}/INDEX.md"
if ( cd "${tmp}" && bash tools/index.sh --check >/dev/null 2>&1 ); then
  printf 'FAIL  --check accepted a missing index\n'; fails=$((fails + 1))
else
  printf 'ok    --check rejects a missing index\n'
fi

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
