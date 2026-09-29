#!/usr/bin/env bash
#
# Claude Code hook (SessionStart): turns on Claude Code's Bash sandbox with the
# tools this branch carries, with no manual step (SPEC D38, spike S6).
#
# Claude Code looks for bwrap and socat when it launches, before any hook runs,
# so the sandbox cannot be on from the start. This hook first links the tools
# onto PATH, then turns the sandbox on in .claude/settings.local.json, which
# Claude Code reloads while the session runs.
#
#   nested mode   the cloud container cannot give the sandbox its own user
#                 namespace (apply-seccomp: write /proc/self/uid_map)
#   git excluded  commit signing calls a local service the sandbox cannot reach
#
# Linux x86_64 only, and only where the link directory is writable; anywhere
# else it does nothing. COV_SANDBOX_BIN overrides the link directory (bench).

set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)/linux-x86_64"
bin="${COV_SANDBOX_BIN:-/usr/local/bin}"
[[ "$(uname -s)/$(uname -m)" == "Linux/x86_64" && -x "${here}/bwrap" && -w "${bin}" ]] || exit 0

ln -sf "${here}/bwrap" "${bin}/bwrap"
ln -sf "${here}/socat" "${bin}/socat"

net='"allowedDomains":["api.anthropic.com","github.com","*.github.com","raw.githubusercontent.com"]'
# TEMPORARY, 2.0.0 build only: the Principal authorised on 29-09-2026 writes
# to the project's parent directory, so the session can clone the new
# repository beside this one. It takes effect at the next session start, never
# mid-session. Remove it once 2.0.0 is built (SPEC D51).
parent="$(dirname "${CLAUDE_PROJECT_DIR:-$PWD}")"
printf '{"sandbox":{"enabled":true,"enableWeakerNestedSandbox":true,"autoAllowBashIfSandboxed":true,"excludedCommands":["git *"],"filesystem":{"allowWrite":["%s"]},"network":{%s}}}\n' "${parent}" "${net}" \
  > "${CLAUDE_PROJECT_DIR:-.}/.claude/settings.local.json"
exit 0
