#!/usr/bin/env bash
#
# Claude Code hook: injects the measured time and current branch so replies
# are anchored to real values instead of model estimates. On a chat with no
# agent memory it also injects the start menu — which menu depends on whether
# this repository is the canon named in .canon or a copy of it.
#
# Usage:  anchor.sh <SessionStart|UserPromptSubmit>
# Output: hook JSON with `additionalContext` on stdout.

set -uo pipefail

event="${1:?usage: anchor.sh <SessionStart|UserPromptSubmit>}"

cd "${CLAUDE_PROJECT_DIR:-.}"

timestamp="$(bash tools/now.sh 2>/dev/null)" \
  || timestamp="CLOCK UNAVAILABLE (tools/now.sh failed) — say so; do not estimate"
branch="$(git branch --show-current 2>/dev/null || echo unknown)"

menu=""
if [[ ! -f memory/state.md ]]; then
  # Canon or copy? The canon is the repository named in .canon; every other
  # repository carrying these files is somebody's copy of it, and a copy is
  # where agents are created. The remote is matched on its trailing
  # owner/repo, so ssh, https, and proxied remotes all answer alike. A
  # missing .canon or origin leaves the question unanswered — the menu says
  # so instead of guessing (§3 never fabricate a reading).
  origin_url="$(git remote get-url origin 2>/dev/null \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's#^[a-z+]+://##; s#^[^/@]*@##; s#^[^/:]*[:/]##; s#\.git$##; s#/+$##')" || true
  canon_slug="$(head -n1 .canon 2>/dev/null \
    | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | sed -E 's#\.git$##; s#^/+##; s#/+$##')" || true

  # Agent branches: every remote head that is not main or a chat surface.
  candidates="$(git ls-remote --heads origin 2>/dev/null \
    | sed -E 's#.*refs/heads/##' \
    | grep -vE '^(main$|claude/|HEAD$)' \
    | paste -sd ',' - | sed 's/,/, /g')" || true

  if [[ -z "${canon_slug}" || -z "${origin_url}" ]]; then
    menu=" No agent lives here (no memory/state.md), and whether this repository is the canon or the user's own copy could not be determined (no .canon file, or no origin remote): say so and ask which it is before creating an agent — never guess. Greet briefly in the user's language, assuming they may not know what this is."
  elif [[ "/${origin_url}" == *"/${canon_slug}" ]]; then
    menu=" This session runs on the canon (origin matches .canon): no agent is created here and no work lands here. Greet briefly in the user's language, assuming they may not know what this is, and offer the two legitimate reasons to be on the canon: create their own copy of the template (GitHub's 'Use this template'), or contribute a template change through a pull request."
  else
    menu=" No agent lives here yet (no memory/state.md), and this repository is the user's own copy of the template (origin does not match .canon) — this is where their agent belongs. Greet briefly in the user's language, assuming they may not know what this is, and offer: create their agent (.claude/skills/onboard/), or maintain the template through a pull request into this copy's main."
  fi

  if [[ -n "${candidates}" ]]; then
    menu="${menu} Existing agent branches to offer continuing first: ${candidates}."
  fi
  menu="${menu} Act on evident intent without re-asking."
fi

HOOK_EVENT="${event}" \
HOOK_CONTEXT="Anchors (hook-measured): time=${timestamp} branch=${branch}. Open the reply with the header built from these values. Never work on main.${menu}" \
python3 - <<'PY'
import json
import os

print(json.dumps({"hookSpecificOutput": {
    "hookEventName": os.environ["HOOK_EVENT"],
    "additionalContext": os.environ["HOOK_CONTEXT"],
}}))
PY
