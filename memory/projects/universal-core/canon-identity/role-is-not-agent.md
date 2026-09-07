---
thread: Canon identity
date: 07-09-2026
state: the Principal's correction of 07-09-2026, verified against both identity files.
---

# The Custodian is a role, and one agent holds it

Set by the Principal on 07-09-2026: **Custodian is the role. Chief of Vibes is the agent, and
the only agent with access to that role.**

## What the files actually say

Both `state.md` files put the **role name in the `agent` field**, and neither names the agent:

| Branch | `agent:` | `branch:` |
|---|---|---|
| `Chief-of-Vibes-Agent` | `Custodian` | `Chief-of-Vibes-Agent` |
| `Custodian` | `Custodian` | `Custodian` |

The branch named for the agent declares the role; the branch named for the role declares the
same role. So the confusion is symmetric, and it produced two vaults for one agent — the drift
§5 names, arrived at from an angle §5 does not describe. Choosing between the two files was
never the fix. The `agent` field held the wrong kind of noun in both.

The `Custodian` branch had already filed all of its memory under **`memory/projects/custodian/`**,
a project namespace. That is what an agent writes about a line of work it is doing, not what an
agent writes about itself. The content was organised as a role from the start; only the frontmatter
and the branch claimed otherwise.

## The three axes, corrected

| Axis | Question | Held by |
|---|---|---|
| **Agent** | who is this | `state.md` — one per agent, one vault, one branch |
| **Role** | which duty is being exercised, and who may exercise it | a set the agent declares it may hold; one declared per session |
| **Work area** | where this change is made | `main` never; a memory branch; a disposable work branch per release (§6) |

A role is not a persona and not a place. It is a hat, and the question that matters about it is
**who is allowed to wear it**.

## Why the access restriction is load-bearing

The obvious objection to collapsing a role into an agent: the Custodian's whole claim to judge
proposals is that it is **agnostic** — no goal of its own, so its own interest is not on the
other side of the table. An agent with a goal wearing that hat loses it.

The access rule answers it. On the canon this agent's goal *is* the duty, so there is no second
interest. In a copy, an agent serving a product must not hold this role at all, and that is
exactly what *the only agent with access* means. The restriction is not incidental — it is what
keeps the agnosticism true.

## What follows

- The `Custodian` branch's memory folds back into the agent's vault as `memory/projects/custodian/`,
  where it is already filed.
- Its `state.md` splits. Agent facts — language, timezone, the commit-identity rule, the funding
  arrangement — belong in the agent's `state.md`. Role facts — agnostic, guardian, teacher, what
  it never does, which model may exercise it — belong in the role's own document, which a hook or
  a skill can point at instead of a paragraph inside an identity file.
- **The branch queued for retirement reverses.** The `Custodian` backlog names
  `Chief-of-Vibes-Agent` for deletion. Under this model it is the other way round, and the
  decision is the Principal's.

## What it changes in the planned work

The role change was going to add `role:` as a property of a branch. That is wrong for the same
reason the `agent:` field is wrong: it describes the seat rather than the grant. Instead:

- `state.md` gains **`roles:`** — the set this agent may assume.
- A session **declares the role it is acting in**, the way it already declares its workplace, and
  it rides in the header where §9 already keeps the proof that the triage ran.
- The role's constraints live in one document, so *what a custodian never does* is readable by
  something other than the agent's own memory of its own prose.
