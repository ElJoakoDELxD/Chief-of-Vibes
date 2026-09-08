---
thread: What a rail may read, and what it must hand to judgment
date: 08-09-2026
state: shipped as 1.75.0, pull request #87, awaiting the Principal's approval to merge
---

# What a rail can decide

## The Principal's correction

This agent wrote that a hook cannot tell text from intent, and treated that as a property to
err closed around. The Principal answered that it is a property to use, not to obey blindly,
and that what belongs to intention cannot be delegated to a hook at all — only to better
judgment.

Both halves land. The reasoning was doing two different jobs under one sentence, and only one
of them was true.

## What was actually undecidable, and what was not

A here-document body on its way to a file is data. That is the shell's own grammar, and it is
the grammar the rail is already reading to find the words it refuses. Reading half of it and
calling the other half unknowable was the defect. §8 had already written the cost: a rail
pushed past what is mechanically decidable produces false positives, which teach the agent to
route around it.

The routing around had already happened here, twice, without being named as such:

- `tools/test-guard-identity.sh` carried a paragraph explaining that it could not be written
  by a here-document, and the file was authored with an editor tool instead.
- `tools/test-guard-main.sh` used an `$M` variable so the branch name never appeared, with a
  comment calling that *not a workaround*. It was one.

While this change was being made the install rail refused the write of the main rail's bench,
because a case string inside the body named a download piped to a shell. That is the false
positive, measured live, in the same session that was arguing it could not be avoided.

## Where the line sits now

Mechanical, so the rail keeps it: a body bound for a file is data, a body reaching an
interpreter is a command, each segment is judged alone, and a `-C` naming an absolute path
outside the working tree runs against another repository.

Intent, so no rail touches it: whether running a given command is the right thing. That goes
to the post holding the session and is written as a rule. **A rail that claims the intent half
is rung 4 wearing rung 2's clothes**, and it pays for the claim in false positives.

## What stays coarse, honestly

A branch name inside an executed argument, as in `git commit -m "..."`, still reads as a ref.
That argument runs, so the rail cannot call it data. The knowledge note carries the way round
it, which is `-F` and a file.

And the limit that was always there: a command written to a file now and run by name in the
next call walks past every rail here. `guard-install.sh` already said so. These rails stop the
reflex; they do not defeat an adversary, and saying otherwise would be the more expensive lie.

## What the Principal added next

That the agent also lacks the third test: it sees repetition and contradiction and not a rule that
is illogical or counterproductive. Shipped as 1.76.0, pull request #88.

The objection worth keeping: an agent that grades its own rules will find the inconvenient ones
faulty, which is the exact failure `memory/corrections.md` records about the identity rail. It does
not survive against the duty to report, only against a licence to set aside. So the rule holds while
the proposal travels, and the objection carries an event or it is a preference.

**Both defects in 1.75.0 were of the two shapes named there.** The rail's stated reason did not
support it, and the rail worked as written while costing more than it bought. Every check in the
tree was green over both, for weeks. That is the measurement the new test exists on.

## The third grammar, and the thing I nearly left alone

The Principal asked whether the coarse half had a fix. Answering it honestly meant admitting I had
not looked: *coarse on purpose* was a conclusion, not a measurement, written in the same reply that
shipped a rule against exactly that.

It had a fix. Quoting says where a word ends; git says which subcommand takes a ref. Both were
sitting there. **The pattern across three releases is one pattern**: every limit I called inherent
was a grammar I had declined to read.

What genuinely has no fix is the deferred command — write a script now, run it by name later. Not
because it is undecidable for a shell script (it is decidable, and I checked: the repository's own
tooling would survive the inspection) but because a shell script is one shape of an unbounded
family. Covering one shape sells confidence the rail cannot honour. The branch's guarantee is
`protected: true` at the remote, verified rather than repeated from a comment.

## Where the thread ended

The rails were the small half. The Principal took the same question — what can be decided without
inference — up to the structure, and it produced a rule the rails could not: **`main` holds one
thing, and a finding is authored in `memory/` and nowhere else.**

A version then names one tree. That is the condition every measurement across copies needed and
never had, and it is why the door has never been used: with two admission standards there was no
reason to propose anything, since a copy could simply keep it.

The line worth carrying forward: **you cannot study a variable system unless the constants are
actually constant.** The template is meant to be the constant. Until 1.80.0 it was not.

