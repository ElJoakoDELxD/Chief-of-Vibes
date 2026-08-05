#!/usr/bin/env bash
#
# Prints what this agent can do, derived from the skills themselves.
#
# Generated, never maintained. A hand-written roster is a second copy that
# starts drifting the day after it is written — the same failure as a
# transparency table lagging its machinery (SYSTEM.md §1, §8). Reading the
# directory means a skill that exists is listed by construction, and one that
# is listed exists.
#
# Grouping comes from the two fields the runtime itself obeys, not from this
# script and not from a help page: adding a skill must never mean editing the
# thing that lists skills. `user-invocable: false` means no command exists.
# `disable-model-invocation: true` means the skill never fires on its own.
# Neither field means both, which is the runtime's default and a declaration
# like any other — so there is no unclassified group to report.
#
# Two fields make three reachable states, and the third is a defect rather
# than a category: both off means nothing can load the skill. It gets its own
# heading, because filing it under "they fire when the situation arrives"
# would be the roster asserting what the runtime contradicts.
#
# The roster reads the enforced fields on purpose. A field only this script
# read could say a skill has no command while the runtime went on offering
# one, and the roster is the half a reader trusts (SYSTEM.md section 1).
#
# Usage:  bash tools/skills.sh

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
shopt -s nullglob

read_field() {
  awk -v want="$2" '
    NR == 1 && $0 == "---" { infm = 1; next }
    infm && $0 == "---" { exit }
    infm && index($0, want ":") == 1 {
      sub(/^[^:]*:[[:space:]]*/, ""); v = $0
      if (v == ">" || v == "|" || v == ">-" || v == "|-") v = ""
      collecting = 1; next
    }
    infm && collecting && /^[[:space:]]/ { sub(/^[[:space:]]+/, ""); v = v (v == "" ? "" : " ") $0; next }
    infm && collecting { collecting = 0 }
    END { print v }
  ' "$1"
}

emit_group() {
  local title="$1" want="$2" blurb="$3" any=0
  for f in .claude/skills/*/SKILL.md; do
    local name asks fires line
    name="$(read_field "$f" name)"
    [[ -z "${name}" ]] && continue
    # Both default to on. Only an explicit field turns one off.
    asks=1; fires=1
    [[ "$(read_field "$f" user-invocable)" == "false" ]] && asks=0
    [[ "$(read_field "$f" disable-model-invocation)" == "true" ]] && fires=0
    # Three states, not two. A skill with both fields off is reachable by
    # nobody, and printing it under "they fire when the situation arrives"
    # is the roster asserting something the runtime contradicts.
    case "${want}" in
      command)     (( asks )) || continue ;;
      contextual)  { (( asks )) || (( fires == 0 )); } && continue ;;
      unreachable) { (( asks )) || (( fires )); } && continue ;;
    esac
    if [[ "${any}" -eq 0 ]]; then printf '%s\n%s\n\n' "${title}" "${blurb}"; any=1; fi
    # One human line: `summary:` if the skill carries one, else the first sentence
    # of the description — which is written to match a situation, not to be read.
    line="$(read_field "$f" summary)"
    [[ -z "${line}" ]] && line="$(read_field "$f" description | sed 's/\([.!?]\) .*/\1/')"
    printf '  %s%s\n      %s\n\n' "${name}" \
      "$( (( asks && fires )) && printf '   (also fires on its own)')" "${line}"
  done
}

emit_group "YOU CAN ASK FOR THESE"  command \
  "Say the name, or just describe what you want."
emit_group "THESE RUN ON THEIR OWN" contextual \
  "No command. They fire when the situation arrives, and say so when they do."
emit_group "NOTHING CAN REACH THESE" unreachable \
  "Both routes are switched off in the frontmatter, so no command exists and nothing fires them. That is a defect in the skill, not a category — say so, and name the field to change."

[[ -n "$(echo .claude/skills/*/SKILL.md)" ]] || \
  echo "No skills in .claude/skills/ — this agent has no packaged capabilities yet."
