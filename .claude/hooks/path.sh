#!/usr/bin/env bash
#
# Claude Code hook (SessionStart): puts tools/bin on PATH for every later Bash
# call, so `clock | header` runs as written. It only exposes the commands. It
# measures nothing and injects no time: the agent has to run them itself.

set -uo pipefail
[[ -n "${CLAUDE_ENV_FILE:-}" ]] || exit 0
printf 'export PATH="%s/tools/bin:$PATH"\n' "${CLAUDE_PROJECT_DIR:-$(pwd)}" >> "${CLAUDE_ENV_FILE}"
exit 0
