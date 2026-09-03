---
thread: What sits in the canon and belongs in the Principal's private copy
date: 03-09-2026
state: separated 03-09-2026, rewritten the same day after four rounds of patching left it
  self-contradictory. Nothing has moved. The copy's own agent takes this file as a brief.
---

# What belongs in the copy, and why the split falls where it does

`Chief-of-Vibes-Agent` held three files beyond `main`, all under `memory/`. Two were carried into
this branch on 03-09-2026 and corrected. The third, the weekly-guard note, was absorbed the same
day into `memory/projects/custodian/the weekly guard/`. **Nothing on that branch is still
unabsorbed.** Retiring it is in the backlog under **Principal**.

That is the absorption. The separation is a different question, and it found more than the brief
asked for.

## The test

A thing belongs in the canon when a copy that is nothing like this one would still want it. It
belongs in the private copy when it is true of **one Principal, one wallet, or one place**. The
canon's own rule for `knowledge/` says it harder: an entry there is inherited by every copy that
ever syncs, so a wrong one propagates further than any repository can correct (§5).

**The copy is not named in this file.** The Principal named it in session on 03-09-2026. This is
a public repository, and the name of a private one is theirs to disclose.

## 1. The funding arrangement — moves

`state.md` carried it from 14-08-2026: the agent runs on a slice of donated inference, one
session a week, from the Principal who maintains this repository, and nobody should be made to
spend more than they agreed to. Two claims welded together, and only one is agnostic.

- **Agnostic, stays.** This agent runs on donated inference. The work points at the commons and
  the fuel comes from whoever uses it. It is small on purpose.
- **Personal, moves.** *One session a week, from this Principal.* A standing claim on one
  person's budget does not belong in a public repository, and the agent that should hold it is
  the one planning against that budget.

**Where it goes.** The copy, in that agent's `memory/`, as a standing commitment: funds the
canon's Custodian, one session a week. Not `knowledge/` — it is not a procedure, and never the
canon's `knowledge/`, which every copy inherits.

## 2. Four timezone offsets in `knowledge/` — do not move, remove

Not in the brief. A finding.

| File | Field |
|---|---|
| `knowledge/el-lazo-canon-copia/sync-the-template.md` | `updated: 04-08-2026 23:10 -04` |
| `knowledge/el-lazo-canon-copia/retargeting-a-pull-request.md` | `updated: 09-08-2026 17:4x -04` |
| `knowledge/el-lazo-canon-copia/the-guard-reads-text-not-intent.md` | `updated: 09-08-2026 17:5x -04` |
| `knowledge/el-entorno/the-cloud-environment.md` | `updated: 13-08-2026 23:1x -04` |

`CLOCKS.md` states the principle about itself: **a zone is a location**, so that record keeps
machines, refuses zones, and refuses any date finer than the day. `knowledge/` is inherited by
every copy and obeys neither half.

Somebody was already thinking about this. Three of the four minutes are masked as `4x`, `5x`,
`1x`. **Masking the minute and keeping the offset protects the wrong half.** The minute is noise.
The offset is a longitude, and four agreeing narrow it to one desk. The fourth is not masked at
all.

**This does not move to the copy. It leaves.** A copy may hold anything about its own Principal;
that is what a private repository is for (§5). The canon carries the procedure and nothing about
who wrote it.

**Fix:** `updated:` drops to the date alone. A procedure entry needs day resolution and never
needed minute resolution, and dropping the time removes the zone question rather than answering
it. One line in the §5 template block, four in the entries.

## 3. Non-English text in the canon — neither, and not cosmetic

**Corrected by the Principal on 03-09-2026.** This section once called the two Spanish folder
names cosmetic and scheduled them as a ride-along. That was wrong, and the rule behind it was one
this agent did not hold:

> **The canon writes in English.** Everything on disk, in any file, and into inference. The one
> exception is the README translation, produced when an agent is asked to answer in another
> language. Replies may change language on request; English is the default.

`el-lazo-canon-copia` and `el-entorno` are paths every copy inherits, so the canon teaches its
own convention by example and currently teaches two. Nothing links to them, so the rename costs
the rename. A third site is a Spanish fixture path in `tools/test-hygiene.sh`, a bench teaching
the same wrong shape.

The two sites in this agent's own memory are fixed.

## 4. Quotation — ruled on 03-09-2026

Two sites were put to the Principal with a recommendation to keep them. **Both recommendations
were rejected**, and the rule is wider than either site:

> **The Custodian allows no quotation from people.** A person's words in a canon file are a
> privacy leak. The concept travels. The sentence does not.

Right of reply is spent (§2) and the decision is final. The reasoning that lost is worth one line
because it is a shape and not a preference: *provenance has to be exact* treats a quotation as
evidence, and evidence is exactly what a person never agreed to leave in a file every copy
inherits. **Attribution is the leak, not the language it is in.**

Three deletions, and none loses a concept.

- **`.claude/skills/orchestrate/SKILL.md`.** A quotation of the Principal, dated, given as the
  origin of gear one. The idea already has its own section above it.
- **`.claude/skills/propagate/SKILL.md`.** **The Principal's real first name**, used as the
  example of identity inside the rule that says to drop identity. Inherited by every copy that
  ever syncs, and the sharpest instance of the day's pattern: the rule was written, it was right,
  and its own example broke it.
- **`system/5-memory-an-obsidian-vault.md`.** A Spanish example filename. Not a quotation, but
  the language rule reaches it.

## 5. The handle, and what a public repository cannot hide

The Principal asked for no account handle anywhere. The honest answer separates three cases,
because one of them is not removable and saying otherwise would be a clean-looking falsehood.

**Removable, and in the release.** `CONTRIBUTING.md` uses the full `owner/repo` path in a shell
example and in a link to an old pull request. Both work as a placeholder and a relative link.

**Not removable by this agent.** `.canon` holds `owner/repo` and the drift check compares
`origin` against it. Removing it breaks the mechanism that tells every session which repository
it stands in. `LICENSE` names the copyright holder, which is a legal identity and outside what
this agent touches at all (§4).

**Not removable by anyone, while the repository lives where it does.** The onboarding line in
`README.md` and in the release notes carries the repository's own public URL, and that URL
contains the owner. A reader following it already sees the handle in their address bar. The only
real fix is moving the repository under an organisation, which is the Principal's call and a
one-time migration.

**So the distinction worth keeping:** a handle in the repository's own address is public by
construction. A real first name in a skill file, a quotation, a personal email in a commit
header, and a private repository's name are not, and those are the ones that came out today.

## 6. What the agent leaked while writing this

Four commits on this branch were authored under the Principal's personal email address, taken
from the session context and never asked for. **Every other commit in this repository uses a
noreply address.** The personal one had never appeared here until today.

Fixed: those commits were re-authored to the identity the history already used. Nothing else
about them changed.

The finding is not the address. It is that the agent swept the diff for personal data, found
none, and reported it clean — while the leak sat in the commit header, which is not a file and
was therefore not in the sweep.

## What this agent does not do

**It does not reach into the copy.** `state.md` says isolation is what keeps this agent agnostic,
and a Custodian that writes into a Principal's private repository has traded that property for a
convenience. Knowing which repository it is removed the ambiguity, not the boundary. The copy's
own agent takes this file as a brief.
