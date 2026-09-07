---
post: Custodian
definition: posts/custodian.md on main
held_since: 14-08-2026
verified: exercised through releases 1.65.0 to 1.70.0 on 06-09-2026 and 07-09-2026
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
