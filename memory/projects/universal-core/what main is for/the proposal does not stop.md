---
thread: What main is for
date: 07-09-2026
state: the Principal's rule, stated 07-09-2026. Exposes a gap with no sensor. Unimplemented.
reads: the membership test.md
---

# A proposal does not stop where it is accepted

The Principal's rule: **everything is tested outside its own `main`, then proposed upward, and a
copy does not stop the proposal at its own main. It goes on to the canon's custodian too.**

## The shape, and it is the same shape at every level

```
work on a disposable branch
        │  proposed
        ▼
the copy's steward  ──merged──▶  the copy's main
                                       │  and does NOT stop here
                                       ▼  proposed
                          the canon's custodian  ──merged──▶  the canon's main
                                                                    │  sync
                                                                    ▼
                                                              every other copy
```

A copy of a copy adds a hop and changes nothing else. Acceptance at any level is **local
adoption**, never the end of the journey.

## Why it goes to a person at each level instead of travelling on its own

Because a filled form is identity. A change is born specific: this agent, this Principal, this
machine, this failure. What generalizes is the form underneath it, and finding the form means
stripping the identity and judging what is left.

**That is the function `receive a proposal` names, and it is why the hop is a post and not a
pipe.** Nothing can be forwarded automatically, because the thing that must travel is not the
thing that was written.

## Which refines the two posts

The table written an hour earlier said the custodian **receives** and the steward **sends**. Too
coarse. **Both receive.** The difference is the trust boundary each stands on:

| | receives from | sends to |
|---|---|---|
| **steward** | its own agent's working branches | the canon's custodian |
| **custodian** | stewards, and strangers | nothing above it |

So `receive a proposal` is one function held by both posts, which is another thing written once
in `functions/` and referenced twice.

## Nothing is proved on a `main`

The other half of the rule, and it already holds mechanically: work happens on a branch, `main`
is read-only in operation, and the guard hook blocks work on it.

What the rule adds is the reason. **A `main` is a published surface, and a published surface
cannot be an experiment.** Proof belongs where failure is cheap. The branch is where a change is
allowed to be wrong.

## The gap: local success hides the obligation

**A change merged into a copy's `main` looks finished.** The backlog item closes, the journal
says it landed, and the upstream hop silently never happens, because nothing is left open to
remind anybody. A rejected idea stays visible. An adopted one does not.

So the merge **creates** the obligation to propose upward. It does not discharge it.

**And nothing watches for it.** `tools/candidates.sh` reports findings the agent kept instead of
sending, by reading `#propagate:DD-MM-YYYY` tags in `memory/backlog.md`. It measures what was
tagged and never done. A change already merged into a copy's `main` is not a backlog item at all,
so it is invisible to the only sensor pointed upstream.

## The sensor that closes it

On a copy the outstanding set is exactly computable, and the fetch is already paid for by the
drift check at session start:

```
git log <canon>/main..origin/main
```

Every local template commit not yet in the canon. One line, no judgment in it.

**It reports and never blocks**, because deciding that a change generalizes is a judgment and §8
says a rail on a judgment lies. A copy may legitimately carry something specific to it forever.
What the sensor removes is the silence: today the agent has to remember that adopted work is
still owed upstream, which is rung 5, and rung 5 holds nothing.

Silent on the canon by construction, which has nothing above it.
