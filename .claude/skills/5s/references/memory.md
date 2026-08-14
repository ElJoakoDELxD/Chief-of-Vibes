# 5s · memory

Target: `memory/journal/`, `memory/backlog.md`, `memory/state.md`, `memory/handoff/`. This runs on the agent branch and lands as an ordinary commit — memory never goes to `main` (§6).

## Measure

    wc -w memory/journal/*.md memory/backlog.md memory/state.md
    ls memory/handoff/
    bash tools/hygiene.sh

Report the journal separately from the rest. A journal growing is normal — it is a log. A backlog growing is a symptom. The sensor's own output belongs in the before state, because a run that leaves it still firing did not finish.

## What each step means here

**Sort.** Backlog items that are done, superseded, or were never the agent's to do. An item under **Principal** with no failed attempt attached is the agent's own task, misfiled (§3) — it does not get deleted, it gets moved and done. Handoff notes whose thread has closed are finished, not archive: delete them, the journal holds the history.

**Set in order.** Two splits, and both decay. The first is the shape of `memory/projects/`: a topic, a thread folder inside it, and the topic's `brief.md` as the only file the topic level holds (§5). The sensor names what is outside it, and moving a loose note into a thread means deciding which thread it came from, which `git log --diff-filter=A` answers instead of memory.

The second is the §5 split, which is the one that decays fastest. *What happened* stays in `memory/`. *How to do it again* — a procedure, a flag that is always wrong, an environment quirk that cost three attempts — is distilled into `knowledge/` on `main`, where the next agent executes it instead of rediscovering it. A procedure left in a journal entry is a procedure the next session pays for twice. Moving it is the highest-value action this target has, and it is the one most often skipped because the journal entry "already says it".

**Shine.** Read the journal back. Entries that assert something later entries corrected are the finding — a correction that lives only in the later entry leaves the earlier one available to be believed. Annotate the superseded entry rather than editing history out; the record of having been wrong is worth keeping, being wrong silently is not.

Aim the third question at `backlog.md` and the thread notes rather than at the journal:

    python3 tools/redundancy.py memory/backlog.md "memory/projects/<topic>/<thread>"/*.md

A backlog holding one item twice in two wordings is the defect the size threshold only hints at, and the two copies age at different speeds. The journal is exempt by design: two entries describing the same work on different days are the record doing its job, not a duplicate.

**Standardize.** A `knowledge/` entry names what was actually run to verify it. A guess written there is worse than an empty folder, because it will be trusted.

**Sustain.** Triggers: a handoff being written, a thread closing, or a journal file crossing the size where nobody will read it back.

## Traps

- **Compressing the journal into a summary.** The journal is evidence, and its value is that it recorded what was believed at the time. Losing the wrong turns loses the reason the rules exist. Prune duplicates and dead handoffs; do not rewrite entries into a tidier story.
- **Distilling to `knowledge/` without the verification.** §5 wants what was run, not what was concluded.
- **Running this instead of the work.** Memory housekeeping feels productive and is the cheapest possible substitute for progress on the goal (§7). If the goal has not moved in three sessions, a tidy journal is a symptom, and the report should say so rather than close on a clean number.
