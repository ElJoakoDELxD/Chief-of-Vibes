#!/usr/bin/env bash
#
# Answers "what is X, here" from the tree, with the address of every answer.
#
# **It teaches in both directions, and that is why it exists.** The Principal
# gets an explanation they can check against the file it came from. The agent
# runs it before explaining anything, so the explanation is read rather than
# remembered — which is SYSTEM.md section 3's *never fabricate a reading*,
# applied to the one duty that had no machinery. Measured 08-09-2026: a session
# spent hours rediscovering a procedure that had been written down a month
# earlier, on `main`, where the rule already said to look.
#
# **It never paraphrases.** It prints what the tree says and where it says it.
# Explaining at the right level for the person asking is judgment, it stays with
# the post holding the session, and a tool that summarised would put a second
# copy of every rule one step from the first (section 8).
#
# **Silence is a finding.** Where nothing in the tree names the term, it says so
# plainly. That is the sentence this tool exists to force: an agent that cannot
# find something has learned something, and the alternative is filling the gap
# from training rather than from the repository in front of it.
#
# Usage:
#   bash tools/explain.sh              # what to read first, in order
#   bash tools/explain.sh <term>       # every place this tree names it
#
# Exit 0 when the tree answered, 1 when nothing did. Reporting, never blocking.

set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

term="${1-}"

if [[ -z "${term}" ]]; then
  cat <<'START'
Read in this order. Each one assumes the one before it.

  1. README.md            what this is, for somebody who has never seen it
  2. CLAUDE.md            the four rules that are never worth missing
  3. SYSTEM.md            the core: who decides, what is forbidden, how a session runs
  4. INDEX.md             where every rule, skill and tool lives — generated, never edited
  5. system/              one file per section, opened when the work reaches it

Then ask this tool about anything by name:

  bash tools/explain.sh quarantine
  bash tools/explain.sh "the canon"
  bash tools/explain.sh sync

And to see what this agent can do rather than what it must obey:

  bash tools/skills.sh
START
  exit 0
fi

hits=0
absent=()
section() {  # section <title> <files...>
  local title="$1"; shift
  local found
  # INDEX.md is generated from the tree, so it would answer twice. This file is
  # excluded too: its own usage examples are not evidence about the term.
  # Only ask about paths that exist. A copy does not carry every folder the canon
  # does — the catalogue is the canon's — and a glob that matches nothing made the
  # answer look like a search that found nothing. Those are different answers, and
  # section 3 says the tool must not blur them.
  local present=(); local p
  for p in "$@"; do [[ -e "${p}" ]] && present+=("${p}"); done
  (( ${#present[@]} )) || { absent+=("${title}"); return 0; }
  set -- "${present[@]}"
  found="$(grep -rniE -- "${term}" "$@" 2>/dev/null \
    | grep -vE '^(INDEX\.md|tools/explain\.sh|tools/test-explain\.sh):' | head -8)" || true
  [[ -z "${found}" ]] && return 0
  printf '\n%s\n' "${title}"
  while IFS= read -r line; do
    local file="${line%%:*}"; local rest="${line#*:}"
    local num="${rest%%:*}"; local text="${rest#*:}"
    text="$(printf '%s' "${text}" | sed 's/^[[:space:]#*_-]*//; s/[[:space:]]*$//' | cut -c1-150)"
    printf '  %s:%s\n    %s\n' "${file}" "${num}" "${text}"
    hits=$((hits + 1))
  done <<< "${found}"
}

printf 'What this tree says about: %s\n' "${term}"

section "The specification — the rule itself" SYSTEM.md system/*.md
section "Knowledge — a procedure somebody worked out" knowledge/*/*.md
section "The catalogue — a post, a function, a privilege" posts/*.md functions/*.md privileges/*.md
section "Capabilities — a skill that runs" .claude/skills/*/SKILL.md
section "Machinery — a tool or a hook" tools/*.sh .claude/hooks/*.sh .github/*.sh

# A class this tree does not carry is named, always. Silence about it reads as a
# search that came back empty, and the two are different answers (section 3).
if (( ${#absent[@]} )); then
  printf '\nNot searched, because this repository does not carry it:\n'
  for a in "${absent[@]}"; do printf '  %s\n' "${a}"; done
fi

if (( hits == 0 )); then
  printf '\nNothing in this tree names it.\n'
  printf 'That is a finding rather than a gap to fill from memory: say the tree does not\n'
  printf 'carry it, and either work it out and write it down (SYSTEM.md 5) or say it is\n'
  printf 'outside what this system knows.\n'
  exit 1
fi

printf '\n%s place(s) answered. Read them before explaining: the address is what makes\n' "${hits}"
printf 'the explanation checkable, and the level to pitch it at is yours to judge.\n'
