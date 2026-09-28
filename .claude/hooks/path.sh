#!/usr/bin/env bash
#
# Claude Code hook (SessionStart): puts tools/bin on PATH for every later Bash
# call, so `clock | header` runs as written. It only exposes the commands. It
# measures nothing and injects no time: the agent has to run them itself.

set -uo pipefail
[[ -n "${CLAUDE_ENV_FILE:-}" ]] || exit 0
bin="${CLAUDE_PROJECT_DIR:-$(pwd)}/tools/bin"
# Once per env file, and never twice on PATH: every SessionStart (resume,
# clear, compact) runs this hook again.
grep -qF "${bin}" "${CLAUDE_ENV_FILE}" 2>/dev/null && exit 0
printf 'case ":$PATH:" in *":%s:"*) ;; *) export PATH="%s:$PATH" ;; esac\n' "${bin}" "${bin}" >> "${CLAUDE_ENV_FILE}"
exit 0
