---
topic: The main guard reads text, so a branch name inside an executed argument is blocked like the command
updated: 08-09-2026
verified: 08-09-2026. The here-document half was corrected against the rails themselves: the write that authors `tools/test-guard-main.sh` is now accepted, and the same body piped into a shell is still refused. Both are bench cases. Recorded first on 30-07-2026
---

# The guard reads text, not intent

## The trap

`guard-main.sh` blocks commands that reach the protected branch. It decides by matching
the command string, so an argument that only **quotes** such a command looks the same.

This is refused, and it pushes nothing:

```
git commit -m "explains how a push to that branch breaks the history"
```

Three words sit in one segment: the branch name, `push`, and `git`. That argument is
executed text, so the rail cannot call it data, and it errs closed.

## What to do

**Put the message in a file. Point the commit at it.**

```
git commit -F <path>
```

A shell here-document writes that file, and so does an editor tool. The same holds for a
pull request body, an issue comment, or any prose about the branch that would otherwise
travel inside an executed argument.

## What the rail no longer confuses

Until 08-09-2026 this note said a here-document was no use either, because its body was
part of the command string. That was a defect wearing the note's own reasoning. A body on
its way to a file is data by the shell's own grammar, and `.claude/hooks/lib/command.sh`
reads that grammar, so the three rails now judge what the shell will run. Writing a bench
that holds the strings a rail refuses is accepted. The same body piped into a shell is
refused, and that half is what makes the first one safe.

Two more things are mechanical and now decided rather than guessed. A `-C` naming an
absolute path outside this working tree runs against another repository, whose branches
are not the ones this rail holds. And each segment is judged alone, so an `echo` is never
evidence about a neighbouring push.

## What not to do

Do not rephrase a message to slip past the match. The wording is not the problem, and a
message bent around a rail says less than the one you meant. Move the text out of the
executed argument instead.

Do not loosen the guard by exempting a context. The obvious version is to skip the check
when the command runs somewhere else, which makes the rail avoidable by putting a
directory change in front of it. Narrowing to what the shell will run is the opposite
move: it removes false positives without granting an exemption anyone can claim.

## The general shape

**A rail decides what is mechanically decidable, and a rail pushed past that produces
false positives, which teach the agent to route around it** (SYSTEM.md §8). Whether
running a given command is right is intent, and no rail settles it. That half belongs to
the post holding the session, and it is written down as a rule rather than matched as a
string.
