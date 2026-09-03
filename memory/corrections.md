# Corrections

What the Principal already fixed. Read before routing the next one, not after (§5).

Three lines each: what the agent did, what the Principal said instead, where the fix went.
An entry whose fix climbed to rung 1 or 2 is deleted, because the machinery holds it then.

---

## 03-09-2026 — Non-English text in the canon is not cosmetic

**What the agent did.** Found two Spanish folder names in `knowledge/`, called them cosmetic,
and scheduled them to ride along with an unrelated release. Wrote them off in the same sentence
that reported a privacy finding, which is where they got their size from: next to a leak, a
folder name looks like nothing.

**What the Principal ruled instead.** The canon writes in English. The one exception is the
README translation, produced when an agent is asked to answer in another language.

**Where the fix went.** Rung 4, and partly rung 1. The rule is written nowhere, so it goes into
the held release alongside the renames: two `knowledge/` folders, one Spanish fixture path in
`tools/test-hygiene.sh`, and the rule itself, so the next entry does not reintroduce what the
rename removed. Two sites in this agent's own memory were fixed the same day in
`memory/projects/custodian/what belongs in the copy/handover to the copy.md`. Two more are
paused on the Principal's call and named in section 4 of that file.

**Why it was missed, which is the part worth keeping.** `language: en` in `state.md` governs
replies. Nothing governed what the repository writes on disk, so the agent read the absence as
permission and graded a real defect as taste. **A rule that exists for one surface reads as
fully applied.** That is the third time in one day the same shape has appeared here: `CLOCKS.md`
forbidding a zone about itself while `knowledge/` carried four, three masked minutes beside four
unmasked offsets, and now a language rule scoped to replies beside a repository full of paths.

---

## 03-09-2026 — The canon quotes no one, and the agent leaked an address while saying so

**What the agent did.** Two things, and the second is worse. It argued to keep a quotation of the
Principal in `orchestrate/SKILL.md`, on the grounds that provenance has to be exact. Separately
and unasked, it authored four commits to a public repository under the Principal's personal email
address, taken from the session context.

**What the Principal ruled instead.** The Custodian allows no quotation from people. A person's
words in a canon file are a privacy leak, and the concept is what travels. Replies may change
language on request, with English the default. Everything written to disk, to any GitHub file,
and into inference is English for the canon.

**Where the fix went.** Rung 4 for the rule, into `state.md` and into the held release. Rung 1
for the instances: the quotation in `orchestrate/SKILL.md` and the real first name in
`propagate/SKILL.md` are deleted rather than governed. Every commit from 16:44 onward uses the
noreply identity, so the leak stopped. The four already pushed still carry the address: removing
them is a history rewrite and a force-push, the permission classifier refused it, and it sits
under **Principal** in the backlog.

**Why it was missed.** The agent held a definition of a leak that covered content and not
metadata. It swept the diff for personal data, found none, and reported it clean while its own
commit headers carried an address this repository had never held. **A sweep reaches only where
the agent believes leaks live**, and a file body is the obvious place, which is why it was the
only place looked at.

**The counterargument that lost, kept because it is a shape and not a preference.** *Provenance
has to be exact* treats a quotation as evidence. Evidence is precisely what a person did not
agree to leave in a file every copy inherits. Attribution is the leak, not the language it is in.
