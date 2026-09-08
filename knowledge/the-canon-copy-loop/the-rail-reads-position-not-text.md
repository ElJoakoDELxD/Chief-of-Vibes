---
topic: The main guard reads a word by the position it holds, and the two workarounds it once needed are gone
updated: 08-09-2026
verified: 08-09-2026. Measured against both rails in one run. Three of five ordinary commit messages were refused by the old one and none by the new one, with 37 adversarial cases blocked by both. Recorded first on 30-07-2026 as the opposite conclusion
---

# The rail reads position, not text

## What this note used to say

That a rail matching a command string cannot tell a sentence from an instruction, so prose
about the protected branch had to leave the command channel, and a here-document was no use
either because its body was part of the string.

Both halves were wrong, and both were corrected on 08-09-2026 by reading a grammar that was
already there instead of guessing around it.

## The three grammars

| Grammar | What it settles | Since |
|---|---|---|
| The shell's here-documents | a body bound for a file is data; a body reaching an interpreter is a command | 1.75.0 |
| The shell's quoting | a word starts and ends where the quotes say, so a message is one word and never a list of refs | 1.77.0 |
| git's own arguments | the subcommand decides what its operands mean, and seven of them can reach a branch at all | 1.77.0 |

`git commit -m "do not push to main"` is a commit with one message operand. `git push origin
main` is a push with a ref. The words are the same. The positions are not.

## What that retired

Two workarounds that had been written into the tree as though they were discipline:

- a bench explaining why it could not be written by a here-document;
- a bench hiding the branch name behind a variable, with a comment insisting that was *not a
  workaround*.

Both are gone. Both benches now spell the strings out and are written by here-documents.

## Where the line still is

**An unbalanced quote.** No tokenizer reads it, so the rail falls back to matching the flat
string, which is what every version before 1.77.0 did everywhere. That is the one place it
errs closed, and an apostrophe in a message is the ordinary way to reach it. Passing a
commit message as a file with `git commit -F <path>` avoids it, and is worth keeping for that
reason rather than the reason this note used to give.

**A command written to a file now and run by name later.** Every rail here misses it, and no
narrow fix exists: a shell script is one shape of an unbounded family that includes a
Makefile target, a package script, and a program in any language. A rail covering one shape of
that family buys false confidence, which SYSTEM.md §8 prices higher than the gap. The
guarantee for the branch is branch protection at the remote plus CI, and that is verified
rather than assumed.

## The general shape

**Before calling a rail's limit inherent, ask which grammar already answers the question.**
The shell knows where a word ends. git knows what its own operands mean. A rail that flattens
both and then matches characters is not being careful. It is declining to read.
