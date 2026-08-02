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
# Grouping comes from each skill's own `invocation:` field, not from this
# script and not from a help page: adding a skill must never mean editing the
# thing that lists skills. A skill with no field is reported as unclassified
# rather than guessed into a group — a wrong group is worse than a visible gap.
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
    local name inv line
    name="$(read_field "$f" name)"; inv="$(read_field "$f" invocation)"
    [[ -z "${name}" ]] && continue
    case "${want}" in
      command)      [[ "${inv}" == "command" || "${inv}" == "both" ]] || continue ;;
      contextual)   [[ "${inv}" == "contextual" ]] || continue ;;
      unclassified) [[ -z "${inv}" ]] || continue ;;
    esac
    if [[ "${any}" -eq 0 ]]; then printf '%s\n%s\n\n' "${title}" "${blurb}"; any=1; fi
    # One human line: `summary:` if the skill carries one, else the first sentence
    # of the description — which is written to match a situation, not to be read.
    line="$(read_field "$f" summary)"
    [[ -z "${line}" ]] && line="$(read_field "$f" description | sed 's/\([.!?]\) .*/\1/')"
    printf '  %s%s\n      %s\n\n' "${name}" "$([[ "${inv}" == "both" ]] && printf '   (also fires on its own)')" "${line}"
  done
}

emit_group "YOU CAN ASK FOR THESE"  command \
  "Say the name, or just describe what you want."
emit_group "THESE RUN ON THEIR OWN" contextual \
  "No command. They fire when the situation arrives, and say so when they do."
emit_group "NOT DECLARED YET"        unclassified \
  "These carry no invocation field. Classify them by reading them, say it is a\n  reading, and offer to write it in (SYSTEM.md §8) — do not show this heading\n  to the Principal as an answer."

[[ -n "$(echo .claude/skills/*/SKILL.md)" ]] || \
  echo "No skills in .claude/skills/ — this agent has no packaged capabilities yet."
