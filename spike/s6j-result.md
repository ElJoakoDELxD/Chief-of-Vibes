# S6j result

Date: 2026-09-28. Sandbox never disabled.

## 1. `cat .claude/settings.local.json; env | grep -E 'CLAUDE_CODE_HOST_(HTTP|SOCKS)_PROXY_PORT|^HTTPS_PROXY'`

```
{"sandbox":{"enabled":true,"enableWeakerNestedSandbox":true,"autoAllowBashIfSandboxed":true,"excludedCommands":["git *"],"network":{"allowedDomains":["api.anthropic.com","github.com","*.github.com","raw.githubusercontent.com"]}}}
CLAUDE_CODE_HOST_SOCKS_PROXY_PORT=32831
HTTPS_PROXY=http://srt.<REDACTED>:<REDACTED>@localhost:3128
CLAUDE_CODE_HOST_HTTP_PROXY_PORT=32831
```

(Proxy credentials redacted before commit; the rest is verbatim.)

## 2. `echo test > "$HOME/s6-outside.txt"; echo rc=$?`

```
/bin/bash: line 2: /root/s6-outside.txt: Read-only file system
rc=1
```

## 3. `curl ... https://api.anthropic.com`

```
404
```

## 4. `curl ... https://example.com`

```
curl: (56) CONNECT tunnel failed, response 403
000
```

Exit code 56. Sandbox violation reported: `deny network-outbound example.com:443 (not in this command's allowed_domains)`.

## Reading

- Filesystem: write outside the working directory denied (read-only bind).
- Network: allowlisted host (api.anthropic.com) reached; non-allowlisted host (example.com) refused by the proxy with 403.
