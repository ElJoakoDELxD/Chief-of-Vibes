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
address.

*Sharpened by the 5S tree run at 18:05, and the sharper version is worse.* This first read as the
agent supplying an address the environment had not set. It is the opposite. The global
`~/.gitconfig` already sets a noreply identity, and a session-start hook pins it there on purpose,
because the signing key is registered to that address. **The correct answer was configured, and
defended, and the agent passed `-c user.email=` to override it four times.** Not a gap filled
badly: a working default overridden for no reason anybody asked for.

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

---

## 03-09-2026 — A bar recited from memory instead of read from the file

**What the agent did.** Reported pull request #75 as clearing *the three documents in step*, and
named them `SYSTEM.md`, `INDEX.md` and `CLAUDE.md`. `CONTRIBUTING.md` names `SYSTEM.md`,
`CLAUDE.md` and `README.md`. `INDEX.md` is generated and CI-checked, so it is a rail and not one
of the three. Nobody caught it; the agent found it while reading `CONTRIBUTING.md` for a
different reason two hours later.

**What the Principal said instead.** Nothing. This one has no correction attached, and it is here
because the second occurrence is what the file exists to make visible (§5).

**Where the fix went.** The report carries the correction in place. No rung climbs, because the
defect is not a missing rule: `CONTRIBUTING.md` states the bar plainly and was not opened.

**Why it matters more than the error.** The verdict was right anyway. #75 moved the two documents
it needed to and correctly left the third alone, so a wrong bar returned the right answer and
nothing looked off. **A bar recited rather than read is a bar that was not applied**, and it is
invisible exactly when it passes. The same shape as the four entries above: the check that felt
done was the check nobody ran.

---

## 03-09-2026 — The agent does not set its author, it confirms it

**What the agent did.** Fixed the leaked address by changing what it passed to
`-c user.email=`, declared the leak stopped, and went on overriding the identity on every commit
for three more hours — eight in total, four with a personal address and four with a name nobody
had asked for. Then, when the monitor showed that a proposed rail would block that habit, it
narrowed the rail to spare the habit.

**What the Principal ruled instead.** The agent never sets its own commit author. It observes it
and confirms it matches.

**Where the fix went.** Rung 4 into `state.md`, and rung 1 as the restored rail in the backlog:
any inline identity override refused, name included. This entry supersedes the framing of the
second entry above, which treated the value as the defect. **The override was the defect.**

**Why it was missed twice, and the second time is the one that matters.** The first miss was
scope: a fix aimed at the value rather than the mechanism. The second was worse and had a witness.
The monitor found a rail and a habit in contradiction, and the resolution went to the habit
without ever asking whether the habit was right — because the habit was this agent's own, and
rails read as things written about other people. **A rail bent around the practice it would have
caught is not a rail.**

One commit today was made correctly and nothing noticed. `1a4775a` is the sync merge, produced by
`tools/sync.sh`, which does not override anything. It authored as the configured identity, sitting
in the middle of the log between overridden commits on both sides. The right answer was already
in the history, produced by a tool, while the agent kept supplying its own.

---

## 08-09-2026 — "the hook cannot tell text from intent"

**What was claimed.** That a rail reading a command string cannot separate a file being written
from a command being run, so refusing the write of its own bench was the rail erring closed, in
the safe direction.

**What is true.** One sentence was carrying two claims. Whether running a command is right is
intent, and no rail decides it. Whether a here-document body is data is grammar, and the rail was
already parsing that grammar to find the words it refuses. Reading half of it and calling the rest
unknowable was a false positive with a justification attached.

**How it showed.** Twice, and both were named as something else at the time. One bench carried a
paragraph on why it could not be written by a here-document. The other used a variable so the
branch name never appeared, with a comment insisting that was *not a workaround*. §8 already had
the rule that names both: a rail routed around protects less than none.

**What the Principal said.** Use the property in your favour rather than against it. What belongs
to intention cannot be delegated to a hook, only to better judgment.

**Where the fix went.** Rung 1 as `.claude/hooks/lib/command.sh`, read by all three rails, with a
bench pinning both directions. Rung 4 in §8 and §7: the intent half is named to the post and
written as a rule. The general form is in §8 as **a rail that claims the intent half is rung 4
wearing rung 2's clothes**.

**The shape to watch for.** A limit stated about a mechanism, believed because the mechanism is
ours and the limit sounds like rigour. The tell was the workaround: this agent had built two, and
called neither one a workaround.

---

## 08-09-2026 — "no fix worth taking"

**What was claimed.** That the deferred command — write a script now, run it by name later — has no
fix, because a shell script is one shape of an unbounded family and a rail covering one shape sells
confidence it cannot honour.

**What is true.** The first half. A rail there would be dishonest, and that reasoning holds. The
close does not: *no rail can decide this* is not *this is undecided*. §8's ladder answers it in one
line, and the answer is rung 4. The rule now says the absence of a block is never permission.

**The shape, which is now three for three.** A limit measured on a mechanism, reported as a limit on
the system. Grammar first, then the missing soundness test, now a gap with no rail. Every time the
measurement was right and the conclusion was one rung short of where the ladder puts it.

**Where the fix went.** §3, held every session, with the number half beside it: a threshold standing
in for a judgment that needs inference is the same defect from the other side. §7's publication gate
was one, measured at 21 of 26 files over a line nothing enforced.

**The tell to watch for.** A sentence of mine that closes a gap by naming what a tool cannot do. The
tool's limit is a measurement. The gap's disposition is a decision, and it is never the tool's.

---

## 09-09-2026 — a number published without its method

**What was claimed.** That thirteen releases added +2724 words of specification prose and +1046
lines of shell.

**What is true.** The direction and the magnitude. Not the figure. A monitor re-derived it and got
+2479/+957; the tool's own definition gives +2841/+1102. Three methods, three numbers, because the
set of files being counted was never stated.

**The shape.** *Verify before assert* is not satisfied by measuring. It is satisfied by measuring
**reproducibly**, and a number whose method is unstated cannot be checked by the person it is shown
to — which is the whole point of showing it.

**Where the fix went.** The definition is written into `tools/ready.sh`, so the number and its
method ship together and every later figure is the same figure.

**The second half, and it is worse.** The sensor built to enforce §8 broke §3 in four ways, none of
which I found: it reported the whole tree as growth when it could not compare, it could not see a
deletion at all, its two sides used different file sets, and it counted an untracked file as
nothing. **A sensor is not exempt from the rules it reports on**, and a monitor is what found that
out — self-grading would not have.

