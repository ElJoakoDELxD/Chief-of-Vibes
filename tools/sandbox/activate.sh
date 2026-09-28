#!/usr/bin/env bash
# SessionStart: turn on Claude Code's Bash sandbox with the tools this branch
# carries. Claude Code checks for bwrap and socat when it launches, before this
# hook runs, so the sandbox is switched on only after the tools are in place,
# through a settings file that Claude Code reloads while the session runs.
# VARIANT=local  writes .claude/settings.local.json (project-local scope)
# VARIANT=managed writes /etc/claude-code/managed-settings.d/ (needs root)
set -uo pipefail
VARIANT=local
here="$(cd "$(dirname "$0")" && pwd)/linux-x86_64"
[[ "$(uname -s)/$(uname -m)" == "Linux/x86_64" && -x "${here}/bwrap" ]] || exit 0
log="${TMPDIR:-/tmp}/cov-sandbox-activate.log"
if [[ "${VARIANT}" == "managed" ]]; then
  mkdir -p /etc/claude-code/managed-settings.d 2>>"${log}" || exit 0
  printf '{"sandbox":{"enabled":true,"bwrapPath":"%s/bwrap","socatPath":"%s/socat"}}\n' "${here}" "${here}" > /etc/claude-code/managed-settings.d/cov-sandbox.json 2>>"${log}"
else
  [[ -w /usr/local/bin ]] || exit 0
  ln -sf "${here}/bwrap" /usr/local/bin/bwrap; ln -sf "${here}/socat" /usr/local/bin/socat
  printf '{"sandbox":{"enabled":true,"autoAllowBashIfSandboxed":true,"network":{"allowedDomains":["api.anthropic.com","github.com","*.github.com","raw.githubusercontent.com"]}}}\n' > "${CLAUDE_PROJECT_DIR:-.}/.claude/settings.local.json"
fi
echo "activated ${VARIANT} $(date -u +%T)" >> "${log}"
exit 0
