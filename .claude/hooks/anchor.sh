#!/usr/bin/env bash
#
# Claude Code hook: injects the measured time and current branch so replies
# are anchored to real values instead of model estimates. On a chat with no
# agent memory it also injects the start menu.
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
  # Agent branches: every remote head that is not main or a chat surface.
  candidates="$(git ls-remote --heads origin 2>/dev/null \
    | sed -E 's#.*refs/heads/##' \
    | grep -vE '^(main$|claude/|HEAD$)' \
    | paste -sd ',' - | sed 's/,/, /g')" || true
  menu=" No agent lives here (no memory/state.md): the system only listens — start no agent. Greet briefly in the user's language, assuming they may not know what this is, and offer the two reasons to be here: create their agent (.claude/skills/onboard/) or maintain the template (authorized pull request only)."
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
