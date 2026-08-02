---
name: handoff
invocation: both
summary: Write the handoff note that lets a fresh chat pick up a thread mid-stride, then commit and push it.
description: Write a handoff note for every thread in flight — state, next step, open decisions, files, dead ends — then commit it to the agent branch and push, so a fresh chat resumes mid-stride instead of replaying the conversation. Use when the Principal asks for a handoff (/handoff), when the context window is filling and quality has not yet degraded, and before ending any session that leaves a thread unfinished. Also covers the other end of the lifecycle: a resumed thread that lands gets its note deleted.
---

# handoff

Rides SYSTEM.md §3: *write it down, in the folder that fits* · *never fabricate a reading* (the timestamp comes from `tools/now.sh`) · *register* (terse inside, nothing omitted).

The shape and lifecycle live in SYSTEM.md §5. This skill is the act: the note gets written, committed, and pushed in the same turn, because a handoff that exists only in the chat window is amnesia with a title.

## When

- The Principal asks for one.
- The context window is filling and quality has not yet degraded — §5 fixes the order: write while the window is healthy, never after.
- A session is ending with a thread that cannot land.

## Steps

1. **Inventory the threads.** One note per thread in flight, not one per session. A thread whose remaining actions all belong to the Principal is a backlog item, not a handoff — but a thread the next session must *watch, verify, or continue* earns its note even while the Principal moves his pieces.
2. **Check the folder first.** `ls memory/handoff/`. A note whose thread already landed is deleted now, with one journal line saying so — a stale handoff is a second memory drifting out of sync with the record (§5).
3. **Write each note** at `memory/handoff/<thread title>-handoff.md`, the §5 shape exactly: frontmatter (`thread`, `updated` from `tools/now.sh`, `branch`), then State, Next step, Open decisions, Files, Dead ends.
   - **Next step** carries the single next action, concrete enough to start cold. "Continue the work" hands the next session a question, not a step.
   - **Dead ends** is what saves the next session real money: what was tried, what it returned, and why it will fail again. Carry forward the ones still relevant from the thread's history, not only today's.
   - Compression is not omission — a fact dropped here is paid for twice in the next window.
4. **Land it.** Commit on the agent branch and push. Verify the push reached the remote before claiming it did.
5. **Say so.** One line to the Principal per note: the thread, the file, and the next step it names.

## Provenance

Born 02-08-2026 in a copy: the Principal typed `/handoff` at the end of a working day, and the system had the ritual in §5 but no command that runs it. The first real result is the note that closed that same session.
