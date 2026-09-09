#!/usr/bin/env bash
#
# Scores every piece of published prose against the gate in SYSTEM.md section 7.
#
# Rung 3 (section 8): it reports, and it never blocks. Section 7 keeps 1.5
# violations per 100 words as the reference rate and says plainly that the number
# is a reading rather than a verdict — reading it is rung 4, and whether a piece
# is fit to publish stays with the post that publishes it. What this buys is that
# the number never waits for somebody to ask for it.
#
# It does not fail the build. Most of this repository is over the gate today, and
# a check that is red from the first day is a check nobody reads (section 8: a
# rail that fires on the wrong thing teaches the agent to route around it). The
# number goes on every pull request, and the fixing is its own work.
#
# Usage:  bash tools/prose-gate.sh

set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || { echo "$(basename "$0"): could not reach the repository root; nothing was measured." >&2; exit 1; }

GATE=1.5

files=()
for f in README.md SYSTEM.md CLAUDE.md CONTRIBUTING.md INDEX.md; do
  [[ -f "${f}" ]] && files+=("${f}")
done
for f in system/*.md .claude/skills/*/SKILL.md .claude/skills/*/references/*.md knowledge/*.md; do
  [[ -f "${f}" ]] && files+=("${f}")
done

(( ${#files[@]} )) || { printf 'No published prose found.\n'; exit 0; }

printf 'Prose gate (SYSTEM.md section 7): under %s violations per 100 words.\n\n' "${GATE}"
bash tools/prose-lint.sh "${files[@]}" | awk -v gate="${GATE}" '
  {
    line = $0
    score = 0
    if (match(line, /per100w=[ ]*[0-9.]+/)) {
      s = substr(line, RSTART + 8, RLENGTH - 8)
      gsub(/ /, "", s)
      score = s + 0
    }
    name = $1
    if (name == "TOTAL") { total = line; next }
    if (score >= gate) { over[++n] = sprintf("  %-46s %5.2f", name, score) }
    print "  " line
  }
  END {
    if (total != "") print "  " total
    printf "\n"
    if (n) {
      printf "%d file(s) over the gate:\n", n
      for (i = 1; i <= n; i++) print over[i]
      printf "\nThis reports and does not block. Fixing them is its own change.\n"
    } else {
      printf "Every published file is under the gate.\n"
    }
  }
'
