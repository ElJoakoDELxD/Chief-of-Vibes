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
# Usage:  bash tools/skills.sh

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

shopt -s nullglob
found=0

for f in .claude/skills/*/SKILL.md; do
  # Frontmatter only: name and description, first occurrence, folded onto one line.
  awk '
    NR == 1 && $0 == "---" { infm = 1; next }
    infm && $0 == "---" { exit }
    infm && /^name:/ { sub(/^name:[[:space:]]*/, ""); name = $0; next }
    infm && /^description:/ {
      sub(/^description:[[:space:]]*/, ""); desc = $0
      # A folded (>) or literal (|) block continues on the indented lines below.
      if (desc == ">" || desc == "|" || desc == ">-" || desc == "|-") desc = ""
      collecting = 1; next
    }
    infm && collecting && /^[[:space:]]/ { sub(/^[[:space:]]+/, ""); desc = desc (desc == "" ? "" : " ") $0; next }
    infm && collecting { collecting = 0 }
    END {
      if (name == "") exit 1
      printf "%s\n  %s\n\n", name, desc
    }
  ' "$f" && found=1
done

if [[ "${found}" -eq 0 ]]; then
  echo "No skills in .claude/skills/ — this agent has no packaged capabilities yet."
fi
