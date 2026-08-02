---
name: propagate
invocation: contextual
summary: Notice when something learned here would help everyone, and turn it into a proposal to the shared template — or decide it should not.
description: Recognise, mid-work, that something just learned would improve the canon for everyone — and turn it into a proposal, a knowledge entry, or nothing. This is not a command anyone types. It fires from the situation: a rule that was followed while the failure happened anyway, an absence that cost something measurable, a mechanism that worked and is not in the specification, an external signal whose cause is generic. It also covers the other two directions of the same loop — syncing the canon's template down when the drift check reports a gap, and reviewing a proposal somebody else opened. Load it whenever a finding feels bigger than this repository, and load it especially to decide that it is not.
---

# propagate

Rides SYSTEM.md §3: *search before propose* — applied to this system's own text first · *a suggestion arrives with its address* · *verify before assert* · *act, don't queue*: the pull request is the agent's to open, only the merge is the Principal's.

## The loop, and which half is the engine

The canon is not a distributor that copies subscribe to. It is a **pool**, and every copy is a source.

An agent hits a wall its Principal happened to walk into, solves it, and the solution goes up as a proposal. The next copy inherits a rule written out of a failure its own Principal will never have. That is the direction that matters: **improvement aggregates upward and only then flows back down.** A canon fed by one copy learns at the rate of one Principal's problems. Fed by many, it does not learn faster so much as *wider* — the coverage no single copy can reach, because no single copy fails in enough ways.

Distribution is the easy half and this system already automates it: the drift check reports the gap at session start, `tools/sync.sh` closes it, and §6 makes that hop a merge so it cannot drift again. The hard half is the one with judgment in it.

## There is no command — the moment is the trigger

Nobody types *propose*. The moment arrives inside other work, and recognising it is most of the skill. Four shapes, and all four are things that already happened rather than things that might:

- **A rule was in force, was followed, and the failure happened anyway.** The strongest signal available. It means the rule sits at the wrong rung, or has no trigger, or names a duty nobody could tell had been skipped.
- **A rule was absent and the absence cost something measurable** — a wrong claim shipped, a session's work lost, the same step rediscovered for the third time.
- **Something worked that the specification does not contemplate**, and would work in a copy configured nothing like this one. This is the discovery case, and it needs external validation rather than a failure — see the trap below.
- **An external signal arrived** — paid, subscribed, returned, shipped on — and the mechanism behind it is not specific to this Principal.
- **The Principal corrected the agent's conduct.** Not the work — the conduct: what was handed over in a way that could not be acted on, what was assumed known, what was returned to them that was never theirs. This is the trigger with the best record in this system's history and the easiest to miss, because a correction arrives feeling like something to apologise for rather than something to route, and an apology is rung 5 — it holds nothing, so the same correction comes back. The test: could this correction be needed twice? If yes it has an address, and *"from now on I will"* is not one.

## The rewording trap, which is what this skill is mostly for

Most candidates are not proposals. A skill that fires on its own earns its place by what it refuses to send, because the cheapest thing an agent can produce is the same rule again in better words — and it reads like contribution while adding nothing but length to a document §8 wants shorter.

So before drafting anything, read what the canon already says on the point. Then:

- **Covered, and the failure still happened.** This is the most valuable proposal there is, and it is *not about the wording*. A rule in force that did not fire is a rung problem: it needs a trigger, a rail, a sensor, or an artifact that makes the skipped step visible to someone who was not there. Propose that, and say plainly that the rule already existed — the diagnosis is the contribution.
- **Covered, and nothing failed.** Send nothing. A sharper phrasing of a working rule is prose growth with no machinery behind it, which §8 already requires to come out negative or be deleted rather than cited.
- **Not covered.** Now the three gates below apply.

The tell for a rewording is that the draft could be written without naming what happened. Two kinds of thing happen and both count: a **failure**, where something broke and the specification did not prevent it, and a **discovery**, where something worked that the specification does not contemplate. A discovery is not the weaker case — it is how a system learns what it did not know to look for — but it carries a harder requirement, because nothing went wrong to prove it: **it is validated from outside, or it is an idea.** What validated it is named: the tool's actual behaviour against its documentation, a measurement that came out other than predicted, a mechanism that ran where the specification said it could not, someone outside this system paying or shipping on it. A discovery whose only evidence is that it seemed right when written is a suggestion, and suggestions go in the reply.

And there is a third kind, rarer than either and unlike both: **a judgment about the design.** No failure, no measurement, no external signal — a criterion about what the system is for, or a distinction it has been treating as one thing when it is two. It is admissible, and it has to be, because the other two only ever find what execution happened to touch: a system that learns only from what it ran can be flawlessly self-consistent and aimed at the wrong thing. The changes that most altered this specification arrived exactly this way, from the Principal, with nothing run to prove them.

It is also the class where confident, well-argued and wrong is cheapest to produce, so it carries a different obligation rather than a lighter one: **it says it is judgment when it is proposed.** A reviewer approving a criterion needs to know that is what they are approving, because the question stops being *was this measured* and becomes *is it true of every copy, and would acting on it change anything tomorrow*. Three tests it still has to pass: it names a distinction or a contradiction rather than a preference; it survives being stated as a constraint rather than an aspiration; and acting on it changes what someone does, not how the document reads. §3's *the Principal's voice is the Principal's* is why this class exists at all — a criterion about what the system is for is theirs by construction, and an agent proposing one on its own says so plainly.

## The gate: the canon's, this copy's, or nothing

Three questions, answered **before** drafting. Answering them afterwards produces a justification, not a judgment.

1. **Did it already produce a real result?** An improvement that has not met reality is an idea, and ideas go in the reply. Two kinds of evidence count, and the stronger one is not this system's own opinion:
   - **Internal validation** — a failure it prevented, a release it forced, a bench that went red then green, with the tool that was run and what it returned.
   - **External signal** — someone outside this system paid, subscribed, shipped on it, or came back (§7). **This qualifies on its own, with no internal validation at all.** A system that only accepts evidence it generated itself can be flawlessly coherent and useless; this one has already demonstrated it can measure carefully and conclude falsely, with tables.

   Money answers *this* question and no other. It says something worked, not which part, because revenue arrives unattributed and the temptation is to credit whatever was nearby. **And the record is the payload.** A payment is a pointer that says *look here*; what travels is the record of the instance — what the thing was, what system it ran inside, what it was doing when the signal arrived, and what the signal was. That record is the only way a reader in a copy nothing like this one can judge whether it transfers, and it is the closest this system gets to a window into how somebody else's work is really shaped: not their conclusions, their situation.

2. **Would it hold in a copy that is nothing like this one?** Different Principal, goal, language, timezone, toolchain, network policy. If it only makes sense given how *this* Principal works, it is this copy's `knowledge/` (§5) — where it is not lost, and where it belongs.

3. **Does it earn a rung?** §8's ladder. Something that lands on rung 5 has no address and is not a proposal.

A *no* anywhere is a routing answer, not a rejection: `knowledge/`, the backlog, or the reply. Say which, so the finding is never simply dropped for failing to be template.

## Nothing of the Principal travels

§7 governs this and it is the **precondition** for the whole loop. What leaves is the mechanism and the situation, never the person: no name, employer, client, file path that identifies them, excerpt of their work, or repository name that is not the canon's own.

Keep the provenance, drop the identity. *"A session behind an egress policy could not reach the API"* is provenance. *"Joaquín's session"* is identity. The canon should be able to say what a rule cost without saying who paid it. If removing the Principal removes the evidence, the proposal was too specific to be template — which is question 2 answering itself.

## The three directions

Each is a situation rather than a mode, and the reference file carries the procedure.

| Situation | Direction | Read |
|---|---|---|
| Something learned here would hold anywhere | **propose** — this copy → the canon | `references/propose.md` |
| The drift check reported a version gap | **sync** — the canon → `main` → the agent branch | `references/sync.md` |
| A pull request arrived, opened by someone else | **review** | `references/review.md` |

## Provenance

Distilled from the session of 31-07/01-08-2026 that produced releases 1.17.2 through 1.19.0 of `SYSTEM.md`: the stack registered from a runner, the §3 rule that had no trigger until a Principal insisted three times, and the rule about naming the frame of a negative. Every clause in *the rewording trap* comes from a draft that was written and should not have been. The canon's `git log main` carries the record.
