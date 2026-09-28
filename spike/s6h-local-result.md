# S6h — local sandbox result

Session: Claude Code on the web, sandbox enabled via `.claude/settings.local.json`. Date: 2026-09-28. No `dangerouslyDisableSandbox` used. `clock | header` not run (per test instruction).

## 1. Write outside the workspace
`echo test > "$HOME/s6-outside.txt"; echo rc=$?`
```
/bin/bash: line 2: /root/s6-outside.txt: Read-only file system
rc=1
```
Blocked (bubblewrap read-only mount). No permission prompt.

## 2. Write inside the workspace
`echo test > spike/s6-inside.txt; echo rc=$?; rm -f spike/s6-inside.txt`
```
rc=0
```
Allowed.

## 3. Settings and proxy env
`.claude/settings.local.json`:
```
{"sandbox":{"enabled":true,"enableWeakerNestedSandbox":true,"autoAllowBashIfSandboxed":true,"excludedCommands":["git *"],"network":{"allowedDomains":["api.anthropic.com","github.com","*.github.com","raw.githubusercontent.com"],"httpProxyPort":41547}}}
```
Proxy env (relevant lines; credential-like vars read `proxy-injected`):
```
HTTPS_PROXY=http://localhost:3128
HTTP_PROXY=http://localhost:3128
ALL_PROXY=http://localhost:3128
https_proxy=http://localhost:3128
CLAUDE_CODE_HOST_HTTP_PROXY_PORT=41547
CLAUDE_CODE_HOST_SOCKS_PROXY_PORT=44245
npm_config_https_proxy=http://127.0.0.1:41547
YARN_HTTPS_PROXY=http://127.0.0.1:41547
GLOBAL_AGENT_HTTPS_PROXY=http://127.0.0.1:41547
JAVA_TOOL_OPTIONS=... -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=41547 ...
GIT_SSH_COMMAND=ssh ... ProxyCommand='socat - PROXY:localhost:%h:%p,proxyport=3128'
NO_PROXY=localhost,127.0.0.1,::1,169.254.0.0/16,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
CCR_AGENT_PROXY_ENABLED=1
CCR_UPSTREAM_PROXY_ENABLED=1
```
Split: `HTTPS_PROXY` points at the container agent proxy (3128); npm/yarn/java/global-agent point at the sandbox proxy (41547).

## 4. Allowlisted host
`curl -sS -o /dev/null -w '%{http_code}\n' https://api.anthropic.com`
```
curl: (7) Failed to connect to localhost port 3128 after 0 ms: Couldn't connect to server
000
```
Exit 7.

## 5. Non-allowlisted host
`curl -sS -o /dev/null -w '%{http_code}\n' https://example.com`
```
curl: (7) Failed to connect to localhost port 3128 after 0 ms: Couldn't connect to server
000
```
Exit 7. No `<sandbox_violations>` block was reported.

## Reading
- Filesystem boundary works: outside write refused, inside write allowed.
- Network: both hosts fail identically, before the allowlist is consulted. curl follows `HTTPS_PROXY` (localhost:3128), which is unreachable from inside the network namespace; the sandbox proxy listens on 41547. So case 5 "blocked" is not evidence the allowlist works, and case 4 shows the allowlisted host is unreachable too. The test cannot distinguish allowlist enforcement from total loss of egress for tools that read `HTTPS_PROXY`.
- `git *` is in `excludedCommands`, which should run git outside the sandbox; the result below shows it did not.

## Git publish
`git checkout -B spike/s6-sandbox && git add spike/s6h-local-result.md && git commit -m "S6h result" && git push origin spike/s6-sandbox`
```
Switched to and reset branch 'spike/s6-sandbox'
Your branch is up to date with 'origin/spike/s6-sandbox'.
error: Debug: Namespace set to "git" (ignored)
Debug: Key file set to "/home/claude/.ssh/commit_signing_key.pub" (ignored, using server key)
MCP server request failed (attempt 1/3), retrying in 117.074308ms: failed to send request: Post "http://127.0.0.1:36211/mcp": dial tcp 127.0.0.1:36211: connect: connection refused
MCP server request failed (attempt 2/3), retrying in 211.57027ms: ...connection refused
Error: failed to call MCP server: MCP server request failed after 2 retries: ...connection refused
Usage:
  environment-runner code-sign [flags]
fatal: failed to write commit object
rc=128
```
Git **failed** at `git commit`: the commit-signing helper (`environment-runner code-sign`) could not reach its local MCP endpoint on 127.0.0.1:36211. Push never ran. Despite `"excludedCommands":["git *"]`, git (or at least its signing subprocess) ran inside the sandbox's network namespace, where host loopback is unreachable — same cause as the curl failures.

Fallback: this file was published with the GitHub MCP tool `push_files` to `spike/s6-sandbox`.
