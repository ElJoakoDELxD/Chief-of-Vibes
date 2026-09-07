---
thread: The vault that is not there
date: 07-09-2026
state: proposal written 07-09-2026 on the Principal's instruction. Unimplemented.
verified: both agent branches and the onboard skill were read and compared against §5's tree
  in the same session. Every row of the table below is a `git ls-tree` result, not a memory.
---

# The vault §5 promises, and the parts nothing creates

§5 draws a tree. Onboarding builds part of it. Nothing builds the rest, and the rules are
written as though somebody had.

| §5 names it | onboard creates it | on `Chief-of-Vibes-Agent` | on `Custodian` |
|---|---|---|---|
| `memory/state.md` | yes | yes | yes |
| `memory/backlog.md` | yes | yes | yes |
| `memory/journal/` | yes | **only since 07-09-2026** | yes |
| `memory/corrections.md` | no | **absent** | yes |
| `memory/handoff/` | no, deliberately | absent | absent |
| `memory/projects/` | **no** | yes | yes |
| `projects/` — the deliverables (§5, §7) | **no** | **absent** | **absent** |

## The three real gaps

**1. `memory/projects/` is required before it exists.** §5 says a session declares a workplace
under it *before its first substantive edit*, and §9 puts that path in the header of every reply.
So the first session after onboarding is required to stand somewhere that onboarding never made.
It works, because a directory is free to create. The rule is what is wrong: it reads as though
the folder were there.

**2. `projects/` is a promised address with no origin.** §5 says the deliverables live in a
top-level `projects/<name>/`, and §7 says the work lives there. No skill creates it, no check
looks for it, and neither agent branch has one. A location named twice in the specification and
built by nothing is a location that will be invented differently by whoever needs it first.

**3. `memory/corrections.md` is absent by a good argument with a hole in it.** The argument, from
`Custodian`'s own note: an empty file created in advance teaches the next session there is
nothing to read, which is a different claim from *no correction has happened yet*. That is right.
The hole is that nothing tells a session the file may exist. `tools/ready.sh` already reads it
when it prices the entry fee, so a tool assumes it. §9 says to read it before routing the next
correction. An agent finds it by remembering §5 at the moment a correction arrives, which is
rung 5, and the file's absence is exactly when that matters most.

## What this proposal does not do

**It does not create empty folders.** Git does not track an empty directory, so creating
`memory/handoff/` means committing a placeholder, which is the thing the argument above correctly
refuses. Eager creation would trade a real absence for a fake presence.

So the answer splits by kind:

| Piece | Fix | Why |
|---|---|---|
| `memory/projects/<topic>/<thread>/` | **onboarding creates the onboarding session's own thread folder** | Real content, not a placeholder. The session that creates the agent is itself a thread, and writing its note there makes the convention visible on day one instead of described. |
| `projects/` | **leave absent, and say so in §7** | It appears when the first project passes its brief gate. An empty deliverables tree is a promise, not a product. What is missing is one sentence saying the absence is normal. |
| `memory/corrections.md` | **a sensor, not a file** | `tools/hygiene.sh` already reports memory shape. It should know the file may be absent and say so where a session will read it, rather than leaving the path discoverable only through §5. |
| `memory/handoff/` | **nothing** | The handoff skill owns its creation and does it correctly. |

## And the part that is about being an agent rather than remembering

**Superseded on 07-09-2026 by `../posts and functions/proposal.md`.** This section proposed a
`roles/` directory. The Principal's correction split the word: an agent holds a **post**, and a
post authorizes **functions**. The location, the frontmatter field, the header and the rule that
the Custodian holds projects are all settled there, not here.

## Sizing, honestly

Two releases, not one.

**First: the vault.** `system/5`, `system/7`, the onboard skill, `tools/hygiene.sh` and its bench.
Small, and it stands on its own.

**Second: the post and its functions.** Sized in `../posts and functions/proposal.md`.

The second depends on nothing in the first. Order is a preference, not a constraint.

## What is the Principal's

- Answered 07-09-2026: the naming, the header and the projects question all moved to
  `../posts and functions/proposal.md`. What is left here is the vault alone.
