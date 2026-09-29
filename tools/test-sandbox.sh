#!/usr/bin/env bash
#
# Bench for tools/sandbox/activate.sh: on Linux x86_64 with a writable link
# directory it links bwrap and socat and turns the sandbox on, with no
# fixed proxy port; with no writable directory it does nothing.

set -uo pipefail
cd "$(dirname "$0")/.."
tmp="$(mktemp -d)"; trap 'rm -rf "${tmp}"' EXIT
fail=0
check() { if eval "$2"; then :; else echo "FAIL: $1"; fail=1; fi; }
[[ "$(uname -s)/$(uname -m)" == "Linux/x86_64" ]] || { echo "tools/sandbox: bench skipped (not Linux x86_64)"; exit 0; }

mkdir -p "${tmp}/bin" "${tmp}/proj/.claude"
COV_SANDBOX_BIN="${tmp}/bin" CLAUDE_PROJECT_DIR="${tmp}/proj" HTTPS_PROXY=http://127.0.0.1:41547 bash tools/sandbox/activate.sh
s="${tmp}/proj/.claude/settings.local.json"
check "tools linked" '[[ -L "${tmp}/bin/bwrap" && -L "${tmp}/bin/socat" ]]'
check "settings are JSON" 'python3 -m json.tool "${s}" >/dev/null'
check "sandbox on, nested, git out" 'python3 -c "import json,sys; x=json.load(open(sys.argv[1]))[\"sandbox\"]; assert x[\"enabled\"] and x[\"enableWeakerNestedSandbox\"] and x[\"excludedCommands\"]==[\"git *\"]" "${s}"'
check "no fixed proxy port (it changes between restarts)" '! grep -q httpProxyPort "${s}"'
check "linked bwrap runs" '"${tmp}/bin/bwrap" --version >/dev/null'
check "2.0.0 build only: the project's parent is writable" 'grep -q "\"allowWrite\":\[\"${tmp}\"\]" "${s}"'
check "socat forces IPv4" 'grep -q "socat.bin\" -4" tools/sandbox/linux-x86_64/socat'

mkdir -p "${tmp}/ro" "${tmp}/p2/.claude"; chmod a-w "${tmp}/ro"
if [[ $(id -u) -ne 0 ]]; then
  COV_SANDBOX_BIN="${tmp}/ro" CLAUDE_PROJECT_DIR="${tmp}/p2" bash tools/sandbox/activate.sh
  check "no writable directory: nothing done" '[[ ! -e "${tmp}/p2/.claude/settings.local.json" ]]'
fi
COV_SANDBOX_BIN="${tmp}/missing" CLAUDE_PROJECT_DIR="${tmp}/p2" bash tools/sandbox/activate.sh
check "no link directory: nothing done" '[[ ! -e "${tmp}/p2/.claude/settings.local.json" ]]'

[[ ${fail} -eq 0 ]] && echo "tools/sandbox: bench passed"
exit ${fail}
