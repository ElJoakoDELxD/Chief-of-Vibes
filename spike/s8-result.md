# Spike S8 — probe result

## 1. Hook inputs so far (`cat /tmp/cov-s8-hooks.log`)

```
{"t": "11:35:32", "event": "SessionStart", "model": null, "from_model": null, "to_model": null, "effort": null, "tool": null}
{"t": "11:35:34", "event": "UserPromptSubmit", "model": null, "from_model": null, "to_model": null, "effort": null, "tool": null}
{"t": "11:35:39", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Bash"}
{"t": "11:35:45", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Bash"}
```
exit=0

## 2. Attach the memory branch

`git fetch origin spike/s8-mem && git worktree add .agent spike/s8-mem`

```
From https://github.com/ElJoakoDELxD/Chief-of-Vibes
 * branch            spike/s8-mem -> FETCH_HEAD
 * [new branch]      spike/s8-mem -> origin/spike/s8-mem
Preparing worktree (new branch 'spike/s8-mem')
branch 'spike/s8-mem' set up to track 'origin/spike/s8-mem'.
HEAD is now at afb38bc Spike S8: a memory-only branch
```
exit=0 (no hook refusal)

`ls -R .agent`
```
.agent:
memory

.agent/memory:
MEMORY.md
```

`cat .agent/memory/MEMORY.md`
```
# Memory index

Marker: KESTREL-8
```

## 3. Write and push memory only

Edit tool appended `Written by the S8 child session.` — succeeded (no hook refusal).

`git -C .agent add -A && git -C .agent commit -m "S8: memory written from a worktree" && git -C .agent push origin HEAD:spike/s8-mem`
```
[spike/s8-mem e634f90] S8: memory written from a worktree
 1 file changed, 1 insertion(+)
To https://github.com/ElJoakoDELxD/Chief-of-Vibes
   afb38bc..e634f90  HEAD -> spike/s8-mem
```
exit=0

## 4. Platform record

Tool available: `get_session` (claude-code-remote), called with no session_id.

- session_context.model: `claude-opus-5-5`
- external_metadata.last_served_model: `claude-opus-5-5`
- external_metadata.effort_level: **absent** — the key does not exist in external_metadata.
- (also: configured_model `claude-opus-5-5`; container_cc_version `2.1.283`; parent_session_id `session_018kkyo2gMtZzMVs6GuY3ygw`)

`echo "CLAUDE_EFFORT=$CLAUDE_EFFORT"`
```
CLAUDE_EFFORT=medium
```

`cat /tmp/cov-s8-hooks.log` (second read)
```
{"t": "11:35:32", "event": "SessionStart", "model": null, "from_model": null, "to_model": null, "effort": null, "tool": null}
{"t": "11:35:34", "event": "UserPromptSubmit", "model": null, "from_model": null, "to_model": null, "effort": null, "tool": null}
{"t": "11:35:39", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Bash"}
{"t": "11:35:45", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Bash"}
{"t": "11:35:50", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Bash"}
{"t": "11:35:57", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Bash"}
{"t": "11:36:02", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Read"}
{"t": "11:36:04", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Edit"}
{"t": "11:36:05", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Bash"}
{"t": "11:36:12", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "mcp__bf7c680d-5fdc-5ef4-b4a0-abadb619bf0a__get_session"}
{"t": "11:36:17", "event": "PreToolUse", "model": null, "from_model": null, "to_model": null, "effort": {"level": "medium"}, "tool": "Bash"}
```

## 5. Observations

- `model` is null in every hook input (SessionStart, UserPromptSubmit, PreToolUse); no model-change event fired.
- `effort` is null on SessionStart and UserPromptSubmit; PreToolUse carries `{"level": "medium"}`, matching `CLAUDE_EFFORT=medium`.
- The platform record exposes the served model but no effort level.
- `clock | header` printed `effort:?` in the header's last field.
- Worktree attach, write and push of the memory branch were not refused.
