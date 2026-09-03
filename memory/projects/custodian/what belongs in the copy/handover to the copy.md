---
thread: What sits in the canon and belongs in the Principal's private copy
date: 03-09-2026
state: separated 03-09-2026. The copy is `ElJoakoDELxD/animated-octo-enigma`, named by the
  Principal the same day. Nothing has moved: this agent does not reach into another repository
  (state.md), so its agent takes this file as a brief in a session of its own.
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

`memory/state.md` here carried this, inherited from 14-08-2026. It said the agent runs on a
slice of somebody's own inference, given with permission, one session a week, at first from the
Principal who maintains this repository. It then closed with a sentence in the Principal's own
words, in Spanish, saying that nobody should be made to spend more than they agreed to.

**The sentence is not reproduced here.** It was removed from `state.md` on 03-09-2026 and
quoting it in the note that argues for its removal would put it back. It is in the git history
and that is where it stays.

Two claims were welded together and only one of them is agnostic.

- **Agnostic, stays here.** This agent runs on donated inference. The work points at the
  commons and the fuel comes from whoever uses it. It is small on purpose.
- **Personal, moves.** *One session a week, from this Principal.* That is a standing claim on
  one person's budget, written in a public repository, quoting them verbatim in their own
  language. Their own agent is the thing that should hold it, because their agent is the one
  planning against that budget. The canon does not need the number and should not carry the
  quote.

**Where it goes.** `ElJoakoDELxD/animated-octo-enigma`, in that agent's `memory/`, as a standing
commitment: *funds the canon's Custodian, one session a week*. Not `knowledge/` — it is not a
procedure, and not the canon's `knowledge/` under any circumstances, because an entry there is
inherited by every copy that ever syncs.

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

## 3. Non-English text in the canon — neither, and not cosmetic

**Corrected by the Principal on 03-09-2026.** This section previously called the two Spanish
folder names cosmetic and scheduled them as a ride-along. That was wrong, and the rule behind
it was one this agent did not have:

> **The canon writes in English.** The only text here in another language is the README
> translation, produced when an agent is asked to answer in one.

`el-lazo-canon-copia` and `el-entorno` do not merely read oddly. They are paths every copy
inherits, so the canon teaches its own convention by example and currently teaches two
conventions. Nothing links to them, so the rename costs the rename.

A full sweep on 03-09-2026 found six sites. Two are these folders. One is a Spanish fixture
path inside `tools/test-hygiene.sh`, which is a bench teaching the same wrong shape. Two were
this agent's own writing and are fixed above. The sixth is a quotation, and it is the one case
where the rule and the evidence pull apart — see below.

All of it now belongs to the held release rather than riding along with it, and the release
carries the rule as well as the renames. A rename with no rule written down gets undone by the
next entry.

The same applied to the two Spanish folders the guard note used to live under on
`Chief-of-Vibes-Agent`. That one is already fixed: the absorbed note landed under
`memory/projects/custodian/the weekly guard/` today.

## What this agent will not do

**It does not reach into the copy.** `state.md` says isolation is what keeps this agent
agnostic, and a Custodian that writes into a Principal's private repository has traded that
property for a convenience. The copy is named now, and that does not change the answer: naming
it removed the ambiguity, not the boundary. Its agent takes this file as a brief.


## 4. The two sites this agent will not change without a word from the Principal

**The quotation in `.claude/skills/orchestrate/SKILL.md`.** Line 179 cites the Principal, dated
13-08-2026, in the words they used, as the provenance of gear one. `ste-writing` does not govern
quoted material, and for a reason that holds here: a translated quotation is a paraphrase
wearing quotation marks, and provenance is the one thing in that file that has to be exact.
**Recommendation: keep it, and mark it as a quotation rather than as prose.** Right of reply
used once (§2); the Principal decides.

**The example in `system/5-memory-an-obsidian-vault.md`.** Line 93 gives `precios del plan
pro-handoff.md` as an example handoff filename, in a sentence that says the name is written in
*the agent's language*. That example is not the canon writing Spanish. It is the canon showing
what a Spanish-speaking copy's agent will correctly produce, which is what the `language:` field
exists for. **Recommendation: keep it.** If the rule is meant to reach copies too, then the
field is the thing to change and not the example.

Both are one word from the Principal either way.
