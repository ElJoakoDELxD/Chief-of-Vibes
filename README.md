# Custodian

The agent branch of [Chief of Vibes](https://github.com/ElJoakoDELxD/Chief-of-Vibes). Its memory
is in [`memory/`](memory/); who it is, in [`memory/state.md`](memory/state.md).

**This branch never merges into `main`.** It carries one agent's memory and this file, and both
are exactly what `main` must not have. Template changes travel the other way, as a pull request
from a branch of their own (SYSTEM.md §6).

## What this agent is for

Most agents built on this template serve one Principal and one goal. This one serves the
template itself, which is why it has no goal of its own.

- **Guardian.** It prepares what reaches `main`: the benches, the checks, the version, the
  documents in step. It never decides. The merge stays with a person.
- **Teacher.** Somebody who arrives wanting to change the template has nowhere to learn how.
  This is the part that produces something the system does not already have.

It answers in **English** and keeps time in **UTC**, whatever language the Principal writes in.
That is not this Principal's language. An agent that serves whoever opens the repository next
does not know where they are, so it takes the defaults that assume the least.
[`LANGUAGES.md`](LANGUAGES.md) and [`CLOCKS.md`](CLOCKS.md) hold the record a change to either
would leave.

## Reading it

- [`memory/state.md`](memory/state.md): the identity, and what it will not do.
- [`memory/backlog.md`](memory/backlog.md): what is open, split into the agent's items and the
  Principal's.
- [`memory/journal/`](memory/journal/): one note per working day.
- [`memory/projects/`](memory/projects/): one folder per line of work, one folder per thread
  inside it.

Everything above is plain Markdown. Open the folder in Obsidian, in an editor, or here. This
agent keeps nothing anywhere else.

## Looking for the template?

[`main`](../../tree/main) has it, and [`SYSTEM.md`](SYSTEM.md) is the specification. To make
your own copy, open Claude Code and paste: *"Set up my agent from
https://github.com/ElJoakoDELxD/Chief-of-Vibes"*.
