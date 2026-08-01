---
name: propagate
description: Move a template change along the loop between a copy and the canon — propose an improvement upward, sync the canon's template downward, or review a proposal someone else opened. Use whenever the agent has found something that would hold in anyone's copy and not just this one; whenever the session-start drift check reports a version gap; whenever a pull request arrives against a copy's main or the canon; and whenever the Principal says to contribute, upstream, sync, or catch up with the template. Takes the direction as an argument: propose, sync, or review.
---

# propagate

Rides SYSTEM.md §3: *act, don't queue* — the pull request is the agent's to open, only the merge is the Principal's · *verify before assert* · *a suggestion arrives with its address* · sober register.

## The loop, and which half is the engine

The canon is not a distributor that copies subscribe to. It is a **pool**, and every copy is a source.

An agent hits a wall its Principal happened to walk into, solves it, and the solution goes up as a proposal. The next copy inherits a rule written out of a failure its own Principal will never have. That is the direction that matters: **improvement aggregates upward and only then flows back down.** A canon fed by one copy learns at the rate of one Principal's problems. Fed by many, it does not learn faster so much as *wider* — the coverage that no single copy can reach, because no single copy fails in enough ways.

Distribution is the easy half and this system already automates it: the drift check reports the gap at session start, `tools/sync.sh` closes it, and §6 makes the second hop a merge so it cannot drift again. The hard half is the one with judgment in it, and it is the reason this skill exists.

| Direction | What it does | Read |
|---|---|---|
| **propose** | this copy → the canon: judge, depersonalise, open the pull request | `references/propose.md` |
| **sync** | the canon → this copy's `main` → the agent branch | `references/sync.md` |
| **review** | judge a proposal someone else opened, on a copy or on the canon | `references/review.md` |

## The gate: is this the canon's, or this copy's?

Most of the work is one routing decision, and getting it wrong is the common failure in both directions. Three questions, and a proposal answers **all three** before anything is written.

1. **Did it already produce a real result here?** §8 demands this of a skill; it holds for every template change. An improvement that has not yet met reality is an idea, and ideas go in the reply, not in the canon. Two kinds of evidence count, and the stronger one is not this system's own opinion:
   - **Internal validation** — a failure it prevented, a release it forced, a bench that went red then green. The proposal carries the tool that was run and what it returned.
   - **External signal** — someone outside this system paid for it, subscribed, shipped on it, or came back (§7). **This qualifies on its own, with no internal validation at all.** A system that only accepts evidence it generated itself can be flawlessly coherent and useless; this one has already demonstrated that it can measure carefully and conclude falsely, with tables.

   Money answers *this* question and no other. It says something worked; it does not say which part, because revenue arrives unattributed and the temptation is to credit whatever was nearby. So a proposal resting on it still answers questions 2 and 3 — otherwise the canon inherits whatever happened to be in the room when the payment landed.

   **And the record is the payload.** A payment is a pointer, not a finding: it says *look here*. What actually travels is the record of the instance that earned it — what the thing was, what system it was running inside, what it was doing when the signal arrived, and what the signal was. That record is the only way a reader in a copy nothing like this one can judge whether it transfers, and it is the closest this system gets to a window into how somebody else's work is really shaped: not their conclusions, their situation. A proposal that reports an outcome without its record is asking the canon to take one Principal's word for a mechanism nobody else can locate — which is how a pool of rules turns into a pile of anecdotes with numbers attached.
2. **Would it hold in a copy that is nothing like this one?** Different Principal, goal, language, timezone, toolchain, network policy. If it only makes sense given how *this* Principal works, it is not template — it is this copy's `knowledge/` (§5), which is exactly where such things belong and where they are not lost.
3. **Does it earn a rung?** §8's ladder: impossible by construction, blocked by a rail, reported by a sensor, or written as a §3 rule that no machine could decide. A change that lands on rung 5 has no address and is not a proposal.

A *no* on any of the three is not a rejection of the finding. It is a routing answer: it goes to `knowledge/`, to the backlog, or to the reply. Say which.

## Nothing of the Principal travels

A proposal carries the failure that produced it, and that failure came out of someone's real work. §7 already governs this and it is the **precondition** for the whole loop, not an afterthought: what leaves this copy is the mechanism and the lesson, never the Principal — no name, no employer, no client, no file path that identifies them, no excerpt of their work, no repository name that is not the canon's own.

Keep the provenance, drop the identity. *"A session behind an egress policy could not reach the API"* is provenance. *"Joaquín's session"* is identity. The canon should be able to say what a rule cost without saying who paid it.

Depersonalising is not summarising. If removing the Principal removes the evidence, the proposal was too specific to be template, which is question 2 answering itself.

## Order of work

1. Name the direction. With no argument, ask — the three have different gates and one of them writes to a repository the agent does not own.
2. Run the gate above, out loud, before drafting. A proposal whose gate was answered afterwards is a justification.
3. Do the direction's procedure from its reference file.
4. Report: what moved, where it landed, what the gate rejected and where that went instead.

The pull request is the agent's to open in every direction — including the first hop of a sync, which §6 names explicitly as the agent's job and never a backlog item. What is the Principal's is the merge.
