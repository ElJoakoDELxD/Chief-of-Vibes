---
topic: The main guard reads text, so a message about a command is blocked like the command
updated: 09-08-2026
verified: 09-08-2026. Two attempts to feed `guard-main.sh` a test case were themselves refused, because the test command quoted a push to the protected branch. The refusal is the demonstration. Recorded first on 30-07-2026, and still live
---

# The guard reads text, not intent

## The trap

`guard-main.sh` blocks commands that reach the protected branch. It decides by matching
the command string. A shell command that only **quotes** such a command looks the same.

This is refused, and it pushes nothing:

```
git commit -m "explains how a push to that branch breaks the history"
```

Three words sit in one segment: the branch name, `push`, and `git`. The guard cannot tell
a sentence from an instruction. It errs closed on purpose, and that direction is the safe
one. A command that writes a dangerous command into a file reads exactly like the command.

## What to do

**Put the message in a file. Point the commit at it.**

```
git commit -F <path>
```

Write that file with an editor tool. A shell heredoc will not do: its contents are part of
the command string, and the guard judges them too.

The same holds for a pull request body, an issue comment, or any prose about the branch
that would travel inside a shell argument.

## What not to do

Do not rephrase the message to slip past the match. The wording is not the problem. A
message bent around a rail also says less than the one you meant. Move the text out of the
command instead.

Do not loosen the guard. The obvious fix is to skip the check when the command runs
somewhere else. That makes the rail avoidable: put a directory change in front of it. A
rail you can talk your way out of is not a rail.

## Where the line already is

The guard judges each segment alone. An `echo` in one segment is not evidence about a push
in the next. That much is fixed. What scoping cannot fix is one segment holding both the
prose and the words.

## The general shape

**A rail that reads text will read your description of a thing as the thing.** Where the
description is the work, move it into a file and hand the rail a path.
