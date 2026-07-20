#!/usr/bin/env bash
#
# Claude Code hook (PreToolUse on Edit|Write|Bash): keeps main read-only.
#   - On main: blocks every edit and shell command.
#   - Elsewhere: blocks git commands that push to or check out main.
# Exit 2 makes Claude Code deny the tool call; the reason goes to stderr.
#
# Input: PreToolUse hook JSON on stdin.

set -uo pipefail

input="$(cat)"
branch="$(git branch --show-current 2>/dev/null || echo "")"

if [[ "${branch}" == "main" ]]; then
  echo "BLOCKED by guard-main.sh: main is the template, not a workspace. Check out or create an agent branch; template changes go through an approved pull request." >&2
  exit 2
fi

command="$(printf '%s' "${input}" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))' \
  2>/dev/null)" || command=""

if printf '%s' "${command}" | grep -qE 'git[[:space:]]+(push[[:space:]]+[^[:space:]]+[[:space:]]+(HEAD:)?main([[:space:]]|$)|checkout[[:space:]]+main([[:space:]]|$)|switch[[:space:]]+main([[:space:]]|$))'; then
  echo "BLOCKED by guard-main.sh: that command operates on main. Template changes go through an approved pull request." >&2
  exit 2
fi

exit 0
