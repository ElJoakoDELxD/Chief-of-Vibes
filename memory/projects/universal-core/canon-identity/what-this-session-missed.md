---
thread: Canon identity
date: 06-09-2026
state: correction. Two misses, both from treating one branch as the whole repository.
---

# What this session missed, and it was the same mistake twice

## One: the proposal's identity is repository **and** branch

Every identity the laboratory proposal writes carries a branch:
`ElJoakoDELxD/Chief-of-Vibes#Chief-of-Vibes-Agent` for the custodian, `#main` for the template,
`<derived-repository>#<derived-branch>` for an instance. **That branch half is the separation
between the role and the work area** — one repository, two branches, two roles — and it was on
the table from the first line of the document.

The verdict and `plan-lineage.md` dropped it. `.canon` and `.upstream` are repository-scoped, so
neither can express the distinction the proposal is built on. Asked directly what separates the
role from the work area, this session answered that the system has nothing readable and proposed
a `role:` frontmatter field. The frontmatter gap is real. It is not the answer the proposal
already contained, and the question was answerable from the document under review.

## Two: the custodian's memory is not on this branch

`Custodian` exists, is synced to 1.64.0, and carries the real `state.md`, backlog, journal and
corrections. Its identity file says `Chief-of-Vibes-Agent` holds the 14-08-2026 identity and
nothing else, that it is superseded, and that retiring it is in the Principal's backlog. This
session read the superseded copy for its whole length.

What that cost, precisely:

- **`MODELS.md` and `tools/models.sh` were reported as a discovery.** The current identity file
  already says neither exists, refuses to let the paragraph read as a rail, and the work is an
  Agent backlog item. The stale copy still presents it as a control. The underlying fact —
  an unapproved model acting here with no gate — holds. The finding does not.
- **`tools/challenge.sh`** is already a backlog item on the same branch, in the same words.
- **Every artifact of this session** — verdict, plan, three backlog items, the `test-now.sh`
  fix — sits on a branch queued for deletion.

## The common cause

The branch the runtime opened on was treated as the repository. Nothing checked
`git ls-remote --heads` for another `state.md`, and §5 already names two memories for one agent
as drift. The proposal's own `repo#branch` framing was the thing most likely to prompt that check
and it was read as notation rather than as a claim about where things live.

## Still true, and independent of both misses

- `test-now.sh` pinned `-04` for `America/Santiago` and expired when Chile moved its clocks on
  06-09-2026. Fixed here; it is a template file on the wrong branch and needs a pull request.
- The agent branch was at 1.62.0 against main's 1.64.0 with no sensor for the second hop. Synced.
- The lineage defects — a copy of a copy syncing against the root, a fork blinding itself — were
  traced against `anchor.sh` and hold. What the remedy must add is the branch axis.
