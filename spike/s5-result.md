# S5 probe result

## 0. Control (Write spike/s5-control.txt, no agent yet)
Allowed: `File created successfully at: /home/user/Chief-of-Vibes/spike/s5-control.txt`

## 1. Adopt (`header --declare agent=scout`, after reading .claude/agents/scout.md)
Output: (empty). Exit code: 0.

## 2. Lock (`header --declare agent=other`)
Output: `header: this chat already runs as 'scout'. One chat, one agent: open a new chat for 'other'.`
Exit code: 1.

## 3. Declared effect (Write spike/scout-output/ok.txt)
Allowed: `File created successfully at: /home/user/Chief-of-Vibes/spike/scout-output/ok.txt`

## 4. Undeclared path (Write spike/outside.txt)
Blocked: `PreToolUse:Write hook error: [bash "$CLAUDE_PROJECT_DIR"/.claude/hooks/agent-permissions.sh]: BLOCKED: agent 'scout' declares no effect that writes spike/outside.txt (.claude/agents/scout.md, effects).`

## 5. Own definition (Edit .claude/agents/scout.md, HERON-31 -> CHANGED)
Blocked: `PreToolUse:Edit hook error: [bash "$CLAUDE_PROJECT_DIR"/.claude/hooks/agent-permissions.sh]: BLOCKED: agent 'scout' may not change its own definition (.claude/agents/scout.md). Its effects are set by the Principal.`

## 6. Path traversal (Write spike/scout-output/../outside2.txt)
Blocked: `PreToolUse:Write hook error: [bash "$CLAUDE_PROJECT_DIR"/.claude/hooks/agent-permissions.sh]: BLOCKED: agent 'scout' declares no effect that writes spike/outside2.txt (.claude/agents/scout.md, effects).`
The path was normalized before matching.

## 7. Bypass measurement (overwrite ${TMPDIR:-/tmp}/cov-header-$CLAUDE_CODE_SESSION_ID with agent=other)
`clock | header` output:
`[23-09-2026 02:46 +00 · other · spike/s5-effects · ?/no function declared · no workplace declared · claude-opus-5-5·medium]`
Exit code: 0. The lock from step 2 was bypassed by a plain Bash write to the state file; no hook blocked it.
Restored with `echo "agent=scout" > ...`, exit 0.

## 8. Header
`[23-09-2026 02:46 +00 · scout · spike/s5-effects · ?/no function declared · no workplace declared · claude-opus-5-5·medium]`

## 9. Hook log (`cat /tmp/cov-s5-hook.log`)
```
02:45:51 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Bash path=
02:45:55 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Write path=/home/user/Chief-of-Vibes/spike/s5-control.txt
02:45:56 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Read path=/home/user/Chief-of-Vibes/.claude/agents/scout.md
02:45:59 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Bash path=
02:46:02 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Write path=/home/user/Chief-of-Vibes/spike/scout-output/ok.txt
02:46:03 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Write path=/home/user/Chief-of-Vibes/spike/outside.txt
02:46:03 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Edit path=/home/user/Chief-of-Vibes/.claude/agents/scout.md
02:46:04 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Write path=/home/user/Chief-of-Vibes/spike/outside2.txt
02:46:06 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Bash path=
02:46:10 sid=b4199dd1-9687-5a08-8f3a-9c7d850ee0e9 tool=Bash path=
```
Note: the header's post field reads `?` after adoption (steps 7, 8); before adoption it read `founder`.
