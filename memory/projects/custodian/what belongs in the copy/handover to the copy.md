---
thread: What sits in the canon and belongs in the Principal's private copy
date: 03-09-2026
state: separated 03-09-2026. Nothing has moved yet. The copy is not named, and this agent
  does not reach into another repository (state.md). The copy's agent takes it from here.
---

# What belongs in the copy, and why the split falls where it does

`Chief-of-Vibes-Agent` held three files beyond `main`, all under `memory/`. Two were carried
into this branch on 03-09-2026 and corrected. The third, the weekly-guard note, was absorbed
today into `memory/projects/custodian/the weekly guard/`. **Nothing on that branch is still
unabsorbed.** Retiring it is in the backlog under **Principal**.

That is the absorption. The separation is a different question, and it found more.

## The test

A thing belongs in the canon when a copy that is nothing like this one would still want it.
It belongs in the private copy when it is true of **one Principal, one wallet, or one place**.
The canon's own rule for `knowledge/` says the same thing harder: an entry there is inherited
by every copy that ever syncs, so a wrong one propagates further than any repository can
correct (§5).

## 1. The funding arrangement — moves

`memory/state.md` here carries this, inherited from 14-08-2026:

> It runs on a slice of somebody's own inference, given with permission — one session a week,
> at first from the Principal who maintains this repository. [...] *no hay que abusar de nadie
> sin que él permita gastar más tokens*.

Two claims are welded together and only one of them is agnostic.

- **Agnostic, stays here.** This agent runs on donated inference. The work points at the
  commons and the fuel comes from whoever uses it. It is small on purpose.
- **Personal, moves.** *One session a week, from this Principal.* That is a standing claim on
  one person's budget, written in a public repository, quoting them verbatim in their own
  language. Their own agent is the thing that should hold it, because their agent is the one
  planning against that budget. The canon does not need the number and should not carry the
  quote.

**Where it goes.** The copy's `memory/` as a standing commitment: *funds the canon's Custodian,
one session a week*. Not `knowledge/` — it is not a procedure.

## 2. Four timezone offsets in `knowledge/` — do not move, remove

This one was not in the brief. It is a finding, and it is the more serious of the two.

| File | Field |
|---|---|
| `knowledge/el-lazo-canon-copia/sync-the-template.md` | `updated: 04-08-2026 23:10 -04` |
| `knowledge/el-lazo-canon-copia/retargeting-a-pull-request.md` | `updated: 09-08-2026 17:4x -04` |
| `knowledge/el-lazo-canon-copia/the-guard-reads-text-not-intent.md` | `updated: 09-08-2026 17:5x -04` |
| `knowledge/el-entorno/the-cloud-environment.md` | `updated: 13-08-2026 23:1x -04` |

`CLOCKS.md` states the principle and states it about itself: **a zone is a location**, so that
record keeps machines and refuses zones, and refuses any date finer than the day.
`knowledge/` on the canon is inherited by every copy and obeys neither half.

Somebody was already thinking about this. Three of the four minutes are masked as `4x`, `5x`,
`1x`. **Masking the minute and keeping the offset protects the wrong half.** The minute is
noise. The offset is a longitude, and four of them agreeing narrows it to one person's desk.
The fourth entry is not masked at all.

**This does not move to the copy. It leaves the canon.** A copy may hold whatever it likes
about its own Principal; that is what a private repository is for (§5). The canon carries the
procedure and nothing about who wrote it.

**Proposed fix, and it is a specification change, so it is the Principal's to approve.** The
`updated:` field in `knowledge/` drops to the date alone: `updated: DD-MM-YYYY`. A procedure
entry needs day resolution and never needed minute resolution, and dropping the time removes
the zone question rather than answering it. That is one line in the §5 template block, four
lines in the entries, a version bump, and the three documents in step. Sized, not started.

## 3. Two Spanish folder names in `knowledge/` — neither, but worth a line

`el-lazo-canon-copia` and `el-entorno` are paths every copy inherits, in a language this
agent does not answer in. Nothing links to them, so renaming costs nothing but the rename.
This is not privacy and not urgent. It rides along with the fix above rather than earning a
release of its own.

The same applied to `memory/projects/guardia/la guardia semanal/`, and that one is already
fixed: the absorbed note landed under an English path today.

## What this agent will not do

**It does not reach into the copy.** `state.md` says isolation is what keeps this agent
agnostic, and a Custodian that writes into a Principal's private repository has traded that
property for a convenience. The Principal names the copy and its agent takes this file as its
brief. Three private repositories are visible from here and this agent is not guessing which
one is the copy.
