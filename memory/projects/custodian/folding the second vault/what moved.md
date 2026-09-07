---
thread: Folding the second vault
date: 07-09-2026
verified: every path copied with `git show origin/Custodian:<path>` and compared; the commit
  authors on both branches read with `git log --format=%ae`
---

# What moved, and what it changed about the deletion

Two branches carried a `memory/state.md` for one agent. The sensor shipped in 1.67.0 reported it
at every session start, and this is the repair.

## Moved verbatim

| From `Custodian` | To here |
|---|---|
| `memory/projects/custodian/**` (5 notes) | the same paths |
| `memory/journal/2026-09-03.md` | the same path, no conflict |
| `memory/corrections.md` | the same path. It did not exist here, and the sensor said so daily |

## Merged by hand

`memory/state.md` held agent facts and post facts in one file, which is the confusion 1.69.0
exists to end. The agent facts moved here: the demo, the quotation rule, the commit-identity
rule, the language and zone reasoning, the funding, and where improvements come from. The post
facts were already in `posts/custodian.md` on `main` and `memory/posts/custodian.md` here.

Its backlog gave up two live items nothing else carried: the rail refusing an inline identity
override, and the weekly guard that has never produced a report.

## What the fold changed about the deletion

The second vault's backlog asked the Principal to authorise a history rewrite, because four
commits carry a personal address in a public repository. Measured before touching anything:

- Those four commits exist **only** on `Custodian`. None is an ancestor of this branch.
- This branch's own 49 commits carry the noreply identity.

**So deleting that branch removes the only ref pointing at them.** The rewrite, the force-push
permission it needed, and the note about not depending on a scratchpad script all collapse into
the deletion that was already asked for. What deletion does not do is reach objects GitHub may
still serve by direct SHA, so asking support to purge them is what finishes it.
