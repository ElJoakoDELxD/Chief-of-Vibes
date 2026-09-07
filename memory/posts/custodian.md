---
post: Custodian
definition: posts/custodian.md on main
held_since: 14-08-2026
models: claude-opus-5
verified: exercised through releases 1.65.0 to 1.72.0 on 06-09-2026 and 07-09-2026
---

# The custodian post, as this agent has held it

The definition lives in `posts/custodian.md` on `main` and is the same for anybody holding it.
**This file is the filling**: who holds it here, since when, and what has actually run.

## Functions exercised

| Function | Where it ran |
|---|---|
| `prepare-the-door` | pull requests 77 to 82, six releases in two days |
| `keep-the-benches` | a bench asserting `-04` for `America/Santiago` went red on 06-09-2026 when Chile moved its clocks, with `tools/now.sh` correct throughout |
| `sync-the-template` | after every merge, 1.65.0 through 1.70.0, both versions read rather than assumed |
| `sweep-the-repository` | twenty branches became seven on 07-09-2026: fourteen deleted, six kept |
| `receive-a-proposal` | **never.** No copy has sent one to this repository |

## Which models may exercise it, and the gate that was never built

**Approved by the Principal on 07-09-2026: `claude-opus-5`, and only that. Custody of the
blueprint's `main` runs on Opus.**

That supersedes the approval of 14-08-2026, which named `claude-sonnet-5` for the scheduled
guard. The weekly guard is a function this post authorizes, so it falls under the same rule and
runs on Opus too. If the Principal wants the guard on a cheaper model, that is a second approval
and it belongs on this line, not in an assumption.

The identity file said since 15-08-2026 that `MODELS.md` on `main` names the approved models and
that `tools/models.sh` compares them against what the runtime served. **Neither file existed for
three weeks**, so the paragraph described an intention while reading as a control.

**`tools/models.sh` exists now, shipped in 1.72.0**, and `MODELS.md` never will: the list is
identity and belongs here, which is the `models:` line above. What ships is the tool and the rule.

**And it has been running unenforced.** The sessions of 06-09-2026 and 07-09-2026 were served by
`claude-opus-5`, which is not on the list, and they held this post through seven releases into the
blueprint. Nothing detected it, because the thing that would have is the file that does not exist.
It surfaced only because the Principal asked an unrelated question.

Both decisions were the Principal's and both were made on 07-09-2026: Opus holds this post, and
the gate is built. **A rule that reads as a mechanism and is prose is worse than an absent rule,
because it is trusted** — and this one was trusted for three weeks.

## What has never run, and it is the important row

`receive-a-proposal` is the reason the blueprint exists and it has never been exercised here. The
return flow has produced nothing, because no copy exists that could produce it. A project of this
post's kind can pass its brief, ship, and reach §7's measurement step with nothing to measure,
and its brief should say so rather than wait quietly.

## What the post cost to hold, measured

On 07-09-2026 this agent read a superseded vault for six hours because two branches carried a
`memory/state.md` and each read correctly alone. It reported two documented backlog items as
discoveries and wrote a plan against a tree two releases stale. The check that catches it now
runs at every session start, and it found this repository's own defect on its first run.

The same day the header gained the agent's name, and its first output read `Agent: Custodian`
beside branch `Chief-of-Vibes-Agent` — a post name in the agent field, in this vault, an hour
after shipping the release that separates the two.
