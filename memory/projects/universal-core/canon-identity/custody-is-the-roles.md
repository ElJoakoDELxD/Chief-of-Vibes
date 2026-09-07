---
thread: Canon identity
date: 07-09-2026
state: the Principal's closing move of 07-09-2026. Supersedes plan-lineage.md's file layout.
reads: role-is-not-agent.md, proposal-from-lab.md
---

# Custody belongs to the role, so the template ships no custody marker

Set by the Principal on 07-09-2026, following from *Custodian is a role and one agent holds it*:
**no `.canon` on the canon's `main`, and `.canon` with the custodian role.**

## What the first verdict got wrong, and what it got right

The verdict rejected the laboratory's contract — *`.canon` is custodian-only, `main` does not ship
it* — on three mechanical grounds. Those grounds were true of the design as it stood. The contract
was still reaching for something correct, and it needed *custodian* to mean a **role** rather than
a branch-shaped second agent. Read that way it is right, and the reasoning below is the door the
lab could not find.

## Three facts, not two

The verdict said `.canon` conflates two facts. It conflates **three**, and the third is the one
that does not belong in a template at all.

| Fact | Question | Belongs to |
|---|---|---|
| **custody** | is this repository under a custodian, and who holds it | **the role** — never shipped |
| **parent** | where does my template come from | `.upstream`, generated at onboarding |
| **root** | where do proposals go | lineage, inherited |

Custody and root coincide today only because there is exactly one canon and it is also the root of
every lineage. They are not the same fact and a fork separates them.

## What that does to the three objections

**The agentless menu — dissolves, and its premise was already stale.** The menu exists to decide
whether to offer creating an agent, and its canon branch says *no agent is created here*. That was
written when the canon had no agent. The canon now has one: Chief of Vibes, holding the custodian
role. The real question is *does an agent already live in this repository, on any branch*, and the
hook already lists candidate agent branches to answer it. No custody marker is needed.

**The drift check — dissolves.** It compares against `.upstream`, the parent, which onboarding
generates. The window before onboarding carries no agent, so no rules are being obeyed and there
is nothing to report to anyone. That worry was weaker than the verdict made it.

**The version rail in `tools/pr-guard.sh` — survives, and it is the real cost.** The guard must
know whether it stands in the canon to demand a version bump, and it runs in CI on a checkout of
the pull request's head, which is template content. Reading a marker that lives with the role
means reading another branch. `actions/checkout` already fetches with `fetch-depth: 0`, so
`git show origin/<role-branch>:.canon` is available at no extra cost — at the price of the guard
depending on a branch name. That dependency is a design decision and it is open.

## The same structure in a copy

The Principal's other half: this is not a canon arrangement, it is the blueprint's.

**What every copy inherits:** one agent, one vault, one branch. `roles:` as a set the agent may
hold. A session declaring which role it acts in. Three kinds of branch — the template, the memory,
and a disposable work branch per change. Custody expressed as a role rather than as a file.

**What a copy fills in differently.** Its agent holds a guardian role over its own `main`, and the
role's *content* differs because what it guards differs: a copy has no outside proposers, only its
own agent and its Principal, so the agnosticism that makes the canon's custodian able to judge a
stranger's proposal does not bind the same way. The merge stays with a person either way (§6), and
that is what covers the smaller conflict.

**What does not travel:** this role's occupant, its funding arrangement, its model approvals. A
copy inherits the slot, not what sits in it.

## Open

- The branch-name dependency in `pr-guard.sh`, above.
- `plan-lineage.md`'s file layout is superseded. `.canon` no longer ships on `main`; the design is
  `.upstream` generated at onboarding, plus custody held with the role. The defects it traced —
  a copy of a copy syncing against the root, a fork blinding itself — are unchanged and still real.
