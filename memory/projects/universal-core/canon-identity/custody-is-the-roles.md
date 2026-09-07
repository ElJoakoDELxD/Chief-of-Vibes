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

## The naming, settled 07-09-2026

`.canon` **is not on `main`**. It sits with the role, on the branch where custody is held, so it
never travels. A copy writes **its own** marker, and it is not called `.canon`, so the two never
mean the same thing in two places.

| Repository | File, on the role's branch | What it says |
|---|---|---|
| the canon | `.canon` | custody sits here |
| a copy | **`.blueprint`** | the blueprint is at `owner/repo` |

`.blueprint` is the name the Principal has been using for the canon all day, and it reads
correctly from inside a copy: the file names where the blueprint is. The pair matches the post
pair exactly — `custodian` holds `.canon`, `steward` holds `.blueprint`.

**And the rule that reads them is the one already settled: `.blueprint` present means derived.**
Absence of provenance is what makes a repository the root. Nothing has to assert it.

**This corrects a sentence written an hour earlier.** The README note said provenance belongs in
prose rather than in a file a machine follows. Half wrong: the README line is what a **person**
reads, and `.blueprint` is what the **drift check** reads. Two readers, two records, and neither
substitutes for the other.

## Open

- **`tools/pr-guard.sh` still has no answer, and this is the unresolved cost.** It runs in CI on a
  checkout of the pull request's head, which is template content and carries no marker of either
  name. Its question is whether this repository issues the master version, and with `.canon` off
  `main` it cannot ask. `actions/checkout` already fetches with `fetch-depth: 0`, so reading the
  marker from the role's branch is possible — at the price of the guard knowing that branch's
  name. Flagged this morning, restated at 14:56, still open.
- The branch-name dependency that fix introduces.
- `plan-lineage.md`'s file layout is superseded. `.canon` no longer ships on `main`; the design is
  `.upstream` generated at onboarding, plus custody held with the role. The defects it traced —
  a copy of a copy syncing against the root, a fork blinding itself — are unchanged and still real.
