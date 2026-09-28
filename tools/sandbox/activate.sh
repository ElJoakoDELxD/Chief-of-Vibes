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
#   httpProxyPort the container reaches the internet only through its own
#                 proxy, so the sandbox forwards to it
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

port="$(printf '%s' "${HTTPS_PROXY:-${https_proxy:-}}" | sed -n 's#.*:\([0-9][0-9]*\)/*$#\1#p')"
net='"allowedDomains":["api.anthropic.com","github.com","*.github.com","raw.githubusercontent.com"]'
[[ -n "${port}" ]] && net="${net},\"httpProxyPort\":${port}"
printf '{"sandbox":{"enabled":true,"enableWeakerNestedSandbox":true,"autoAllowBashIfSandboxed":true,"excludedCommands":["git *"],"network":{%s}}}\n' "${net}" \
  > "${CLAUDE_PROJECT_DIR:-.}/.claude/settings.local.json"
exit 0
