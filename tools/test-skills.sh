#!/usr/bin/env bash
#
# Bench for tools/skills.sh. It pins the grouping against the two fields the
# runtime obeys, because the roster is the half a reader trusts: a skill shown
# as having no command, while the runtime still offers one, is the roster
# lying (SYSTEM.md section 1).
#
# Usage:  bash tools/test-skills.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

mk() {  # mk <name> <extra frontmatter...>
  local n="$1"; shift
  mkdir -p "${tmp}/.claude/skills/${n}"
  { printf -- '---\nname: %s\nsummary: what %s does.\n' "${n}" "${n}"
    for line in "$@"; do printf '%s\n' "${line}"; done
    printf -- '---\n\nbody\n'
  } > "${tmp}/.claude/skills/${n}/SKILL.md"
}

mk plain
mk quiet    'user-invocable: false'
mk manual   'disable-model-invocation: true'
mk mute     'user-invocable: false' 'disable-model-invocation: true'
mk nosummy
sed -i '/^summary:/d' "${tmp}/.claude/skills/nosummy/SKILL.md"
sed -i '/^name: nosummy/a description: A first sentence. A second one nobody should see.' \
  "${tmp}/.claude/skills/nosummy/SKILL.md"

cp "${here}/skills.sh" "${tmp}/skills.sh"
mkdir -p "${tmp}/tools" && mv "${tmp}/skills.sh" "${tmp}/tools/skills.sh"
out="$(bash "${tmp}/tools/skills.sh")"

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

asked="${out%%THESE RUN ON THEIR OWN*}"
own="${out#*THESE RUN ON THEIR OWN}"

out="${asked}"
check want     "plain"    "a skill with no field is something you can ask for"
check want     "manual"   "disable-model-invocation still leaves a command"
check want-not "quiet"    "user-invocable false removes the command"
check want-not "mute"     "both fields off still removes the command"

out="${own}"
check want     "quiet"    "user-invocable false lands under runs on its own"
check want     "mute"     "a skill with neither route is still listed"

out="$(bash "${tmp}/tools/skills.sh")"
check want     "plain   (also fires on its own)"  "the default says it fires on its own too"
check want-not "manual   (also fires on its own)" "disable-model-invocation drops that note"
check want     "A first sentence."                "a skill with no summary falls back to one sentence"
check want-not "A second one nobody should see"   "the fallback stops at the first sentence"
check want-not "NOT DECLARED YET"                 "no unclassified group exists any more"

rm -rf "${tmp}/.claude/skills"
mkdir -p "${tmp}/.claude/skills"
out="$(bash "${tmp}/tools/skills.sh")"
check want "no packaged capabilities" "an empty directory says so instead of printing nothing"

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
