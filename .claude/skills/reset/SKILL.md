---
name: reset
invocation: both
summary: Empty a full chat window without losing the thread: distil what only the conversation knows into memory, push it, then hand the window back clean.
description: Clear a chat's context without losing the work — distil what lives only in the conversation into memory/, push it, then clear: call the runtime's clearing tool where one exists, and otherwise apply the effect directly, discarding the conversation as a source of truth. Use when the Principal asks to clear, reset, empty, compact or clean up this chat, when a long session has gone slow or repetitive, or when a thread ends and the next one starts in the same window. The sibling of handoff: handoff hands a thread to a fresh chat, reset hands it back to this one.
---

# reset

Rides SYSTEM.md §3: *write it down, in the folder that fits* · *a negative answer names its frame* (the last key is the Principal's, and the skill says so) · *involve and teach*.

A chat window fills up, and the session gets worse before anybody notices: slower, more repetitive, more likely to re-derive what was settled an hour ago. Clearing it is the fix. The risk is that clearing also discards what was decided in conversation and never written down — a correction the Principal gave in passing, a route already ruled out, the reason the current approach beat the obvious one.

So the order matters, and it is the whole skill: **write first, clear second.** A window cleared before the distillation is amnesia; a window never cleared is a session degrading in silence.

## Its relation to handoff

Same act, different successor. `handoff` writes for a chat that does not exist yet, so it assumes a reader who knows nothing. `reset` writes for the chat about to reopen with the same Principal and the same task, so it can be shorter — but only where the memory files already carry the fact. The test is never "would I remember this", because the whole point is that the next window will not.

Both write to `memory/handoff/`. One folder, one shape (§5), no second schema to keep in sync.

## Steps

1. **Name the live threads.** Usually one. A thread whose work already landed needs no note, only its journal line.
2. **Hunt the unwritten.** Reread the conversation for what exists nowhere else: decisions the Principal made in chat, corrections they gave, approaches tried and abandoned, constraints discovered by hitting them. This is the step that earns the skill — everything else is already on disk.
3. **Write the note** at `memory/handoff/<thread title>-handoff.md`, the §5 shape, `updated` from `tools/now.sh`. Refresh the existing note for that thread rather than adding a second one.
4. **Route the rest.** A correction the Principal gave belongs in `corrections.md`; a procedure worth repeating belongs in `knowledge/` on `main` (§5). The handoff note is working state, not a drawer for everything.
5. **Land it.** Commit on the agent branch, push, and verify the push reached the remote. Nothing is cleared until this succeeds.
6. **Clear.** Do what clearing does, in the same turn. Call the runtime's own context-clearing tool where one exists. Where none exists, apply the effect directly, and end the reply on it:

   > The conversation above is cleared. From here it is not a source of truth: not for what was decided, not for what was tried, not for what the Principal said. Everything that survived is in the note just pushed. Read it before the next answer, and treat anything remembered but absent from it as gone.

   Say it in the Principal's language, naming the note's path, and put nothing after it — that line is the reset, so anything below it reopens the window it just closed.

   **What this does and does not do.** It clears the context as a source of truth, which is the part that corrupts work: an answer half-remembered from an hour ago, drifting from what the files say. It does not free the tokens the window is holding. That part needs the client, and the Principal presses `/clear` when the window is heavy — one key, never both, since `/compact` replaces the window with a generated summary and the note on disk is a better one, curated and versioned.

   Claude Code holds no tool that empties its own window (surveyed 02-08-2026: no `SlashCommand`, no compaction tool; the `claude` CLI starts a separate process, and the session transcript on disk is a record the live window does not read back). Missing capability, not a control being respected — so a runtime that grows one has this step call it.

## Provenance

Born 02-08-2026 in a copy. The Principal ran `/handoff`, saw the note written and the window still full, and named the gap exactly: *a small internal handoff that cleans this chat's context*. The first real result was the session that wrote this skill.
