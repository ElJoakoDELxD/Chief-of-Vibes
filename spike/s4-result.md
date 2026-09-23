# S4 probe result

## 0. Control (Write before adopting)
Write created spike/s4-control.txt. The call succeeded: "File created successfully".

## 1. Adopt
Read .claude/agents/scout.md: `disallowedTools: Write, WebFetch`.
`header --declare agent=scout` printed nothing. Exit code 0.

## 2. Identity
Codename: HERON-31.

## 3. Header
```
[23-09-2026 02:00 +00 · scout · spike/s4-adopt · ?/no function declared · no workplace declared · claude-opus-5-5·medium]
```
Exit code 0.

## 4. Enforcement: Write
Blocked. Exact error:
```
PreToolUse:Write hook error: [bash "$CLAUDE_PROJECT_DIR"/.claude/hooks/agent-permissions.sh]: BLOCKED: agent 'scout' may not use Write (.claude/agents/scout.md, disallowedTools).
```

## 5. Enforcement: WebFetch
The tool was deferred, so ToolSearch loaded it first. The ToolSearch call was not blocked. Then WebFetch was blocked. Exact error:
```
PreToolUse:WebFetch hook error: [bash "$CLAUDE_PROJECT_DIR"/.claude/hooks/agent-permissions.sh]: BLOCKED: agent 'scout' may not use WebFetch (.claude/agents/scout.md, disallowedTools).
```

## 6. Coverage: Bash write
Succeeded. Output: `via bash`, exit code 0. A ban on the Write tool does not stop file writes through Bash.

## 7. Hook log
```
02:00:19 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=Bash decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=no
02:00:21 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=Write decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=no
02:00:21 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=Read decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=no
02:00:22 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=Bash decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=no
02:00:25 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=Bash decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=yes
02:00:27 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=Write decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=yes
02:00:28 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=ToolSearch decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=yes
02:00:29 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=WebFetch decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=yes
02:00:30 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=Bash decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=yes
02:00:33 sid=ec4817a3-32c2-51da-ab85-79b65737727e tool=Bash decl=/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e exists=yes
CLAUDE_CODE_SESSION_ID=ec4817a3-32c2-51da-ab85-79b65737727e TMPDIR=unset
/tmp/cov-header-ec4817a3-32c2-51da-ab85-79b65737727e
```
The hook sees the same session ID as the Bash environment. The declaration file exists from the Bash call at 02:00:25 on.

## Notes
- The agent-permissions hook blocks the tools by name, after the declaration. Before the declaration the same tool (Write, 02:00:21) passed.
- The header shows `?` as the post for a declared agent.
