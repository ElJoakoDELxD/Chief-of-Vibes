# Chief of Vibes

**Claude Code forgets everything when a chat ends. This repository gives it a permanent memory that you own.**

You get an AI colleague with a name. It remembers yesterday. It keeps its notes in plain text files that you can open, read, and edit. You do not need to know git. Your agent teaches you the few pieces you need, while you work.

## What you get

- **An agent with a name and a memory.** Setup takes minutes. After that, your agent never starts from zero.
- **Memory you own.** Everything your agent knows lives in one folder of plain Markdown files: its identity, a daily journal, a task list, project notes. Open the folder in Obsidian or on GitHub. Take it anywhere. There is no lock-in.
- **Discipline by machinery, not promises.** Every reply opens with a header that shows the real clock and the real workspace. Automatic guards protect the rules. A broken rule is visible at a glance.
- **An honest measure of success.** The system only counts a result when a real outsider responds: a reader, a user, a payment. Your agent cannot grade its own homework.
- **Safety gates.** Your agent never spends money, signs anything, or changes its own rules. Those actions need you.
- **A colleague that teaches as it works.** The first time a mechanism appears, your agent explains it in plain language. You keep the skills, and the output too.

## Start

You need a GitHub account and a Claude subscription. That is all. Nothing installs on your computer.

1. Open [Claude Code](https://claude.com/claude-code): from the Claude app, on the web, or in a terminal.
2. Paste one line: **"Set up my agent from https://github.com/ElJoakoDELxD/Chief-of-Vibes"**.
3. Answer three questions: a name for your agent, your language, your goal.

Claude clones this repository, creates a private copy of it in your GitHub account, and onboards your agent there. Your memory lives in your own repository from the first minute. If the session cannot create a repository for you, your agent says so. Then one button does it: **Use this template**, at the top of this page.

No step asked you for a git command. Your agent does the git, and explains each new mechanism the first time you meet it. To work local instead, your machine needs git, bash, and python3.

## What a day looks like

Every reply from your agent opens with a header that you can verify:

```
[13-07-2026 09:02 -04 · CHIEF-OF-VIBES · Chief of Vibes]
Pending from yesterday: the launch post draft. Two items need you today …
```

Every working day leaves one note in its journal:

```markdown
# memory/journal/2026-07-13.md
done:    launch post drafted
decided: postpone the newsletter until the site earns its first signal
lessons: stop assuming, measure
```

When a chat grows too long, the agent writes a note to its future self: what is done, what comes next, what failed. You open a fresh chat and the agent continues mid-stride.

## Read your agent's mind in Obsidian

The memory folder is a normal Obsidian vault:

1. Clone your copy on the machine where you use Obsidian.
2. In Obsidian, choose **Open folder as vault**.
3. Select the `memory/` folder.

The journal reads as daily notes. Project briefs link to each other. There is no export step.

## What runs automatically

Nothing happens behind your back. This is the complete list. If it is not in this table, it does not happen:

| Mechanism | When it fires | Where you see it |
|---|---|---|
| Anchor hook | each session start and each prompt | the time and workspace that open every reply |
| Drift check | each session start, in your copy only | your agent says so when your copy is behind this repository, and offers the update |
| Main guard | before every edit and shell command | a visible `BLOCKED` message when it acts |
| Install guard | before every shell command | a visible `BLOCKED` message when an install would not survive the session |
| Candidate sensor | each session start, in your copy only | your agent names what it found and has not sent back here yet |
| Hand-back | after you clear the chat, in your copy only | your agent opens the empty window by picking the thread back up from its notes |
| Index check (CI) | on every pull request into `main` | a failed check when `INDEX.md` no longer matches the repository |
| Section check (CI) | on every pull request into `main` | a failed check when the specification's map points at a file that does not hold that section |
| Prose gate (CI) | on every pull request into `main` | the readability score of every published file, and which ones are over the line |
| PR guard (CI) | on every pull request into `main` | a failed check when a change reaches outside the system files or skips the version bump |

All agent state lives in `memory/`. There is no hidden index, no sensor, and no background process.

## Improvements flow both ways

Your copy stays connected to this shared home. When the shared rules improve here, your agent offers to bring the update into your copy. When your agent learns a lesson that would help everyone, it proposes that lesson back here, and a human reviews it.

This page is itself a product of that loop. An agent working toward real income found a controlled writing method, measured it, and sent it back. The linter it built scored this page before you read it.

## Languages

[LANGUAGES.md](LANGUAGES.md) lists every language in which this system has explained itself. A line appears the first time somebody uses the system in that language. Nobody adds a line on request. The list grows by use alone.

## Why not just …

- **… a hand-written instruction file?** Good intentions decay. Here the discipline is mechanical: hooks and an automatic check on every change. The memory has a schema and a lifecycle.
- **… Claude's built-in memory?** That memory is opaque and lives inside someone else's product. This one is a folder of Markdown that you own: readable, editable, versioned.
- **… an agent framework?** There is no server, no code to run, and no extra API key. It lives in a git repository.
- **… an Obsidian AI plugin?** Those chat about your notes. This is an operator that produces and ships work. The notes are its memory, not its product.

## Under the hood

The specification is [SYSTEM.md](SYSTEM.md) and the `system/` folder beside it. You do not need to read either to start. `SYSTEM.md` is the part your agent holds in every session: who decides what, what it may never do, how a session opens and closes. The rest is one file per topic — the memory schema, the guards, the project gates, the update path between this repository and your copy — and your agent opens the one the work needs. A map at the top of `SYSTEM.md` points at each, and a check in CI fails if a pointer stops being true.

## Contributing

To use the system, press **Use this template** and work in your copy. To change the system itself, open a pull request here. One change per pull request. Every merge is a release and bumps the version line in `SYSTEM.md`. [CONTRIBUTING.md](CONTRIBUTING.md) has the rules, what each guard checks, and a worked example. Issues are welcome too. The useful ones name where the system did the wrong thing and which rule you expected to stop it.

## Lineage

The system stands on open source, and names what it learned from each project:

- [open-gsd/gsd-core](https://github.com/open-gsd/gsd-core) taught: verification earns "done", and decisions get recorded before the build.
- [garrytan/gstack](https://github.com/garrytan/gstack) taught: the ethos travels with every skill.
- [pewdiepie-archdaemon/odysseus](https://github.com/pewdiepie-archdaemon/odysseus) taught: the specification stays runtime-agnostic.
- [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) taught: route work to the lightest path that does it well.
- [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) taught: one canonical spec, many runtime adapters.
- [vercel-labs/opensrc](https://github.com/vercel-labs/opensrc) taught: degrade loudly, and never let a failure wear the face of success.
- [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) taught: keep a compressed working layer.
- [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) taught: sweep what you publish.
- [microsoft/markitdown](https://github.com/microsoft/markitdown) taught: ingest documents, do not guess them.
- [yamadashy/repomix](https://github.com/yamadashy/repomix) taught: pack the whole system into one AI-readable file.

## License

MIT. See `LICENSE`. Your agent's memory and everything it produces belong to you.
