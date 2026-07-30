# Chief of Vibes

**A persistent AI colleague that lives in your git repository.** It remembers everything between sessions, only calls something a success when a real outsider responds to it, and cannot touch what it must not touch — by machinery, not promises.

Built for Claude Code. Your agent's memory is an Obsidian vault you own.

## The problem

Working with an LLM has three failure modes:

1. **Work evaporates.** Every chat starts from zero; nothing accumulates.
2. **AI self-validates.** It produces confident plans and frameworks that no outside person ever reads, uses, or pays for.
3. **Process eats product.** The setup gets endlessly improved while nothing ships.

Chief of Vibes is a repository template that removes all three: memory compounds in git, success is defined outside the system, and meta-work is structurally bounded.

## What you get

- **An agent with a name and a memory.** Onboarding takes minutes; from then on your agent lives on its own branch and never starts from zero.
- **Memory you own — an Obsidian vault.** Everything the agent knows is plain Markdown in one folder (`memory/`): identity, daily journal, backlog, project briefs, handoff notes. Open it in Obsidian, read it on GitHub, grep it, take it anywhere. No export step, no lock-in.
- **Discipline enforced by hooks, not promises.** Every reply opens with a verifiable header — real clock, real branch. The `main` branch is mechanically untouchable. A wrong header is visible at a glance.
- **A shipping discipline.** One project in construction at a time; scope-creep is logged, never slid past; only unsolicited external signals — a reader, a user, a payment — count as success.
- **Safety gates.** Your agent never spends money, signs anything, commits you to third parties, or edits its own rules. Those require you.
- **No install theatre.** A web session's filesystem is thrown away when the session ends. Your agent will not install tooling there and call it done — it says the install cannot be made durable, and hands it to a session running on your own machine.
- **A colleague that teaches as it works.** Every mechanism is explained in plain language the first time you meet it — commits, branches, pull requests — and hands-on work is shared, not just watched. You leave with the skills, not only the output.

## What runs automatically

Nothing happens behind your back. This is the complete list — **if it is not in this table, it does not happen**:

| Mechanism | Fires | Where you see it |
|---|---|---|
| Anchor hook | each session start and prompt | its time/branch open every reply as the header; with no agent yet, it also picks the start menu for this repository |
| Main guard | before every edit and shell command | a visible `BLOCKED` message when it acts |
| PR guard (CI) | on every pull request into `main` | a failed check when the change reaches outside the template or skips the version bump |

All agent state lives in `memory/`. There is no hidden index, sensor, or background process.

## Start — three steps

Requirements: git, bash, and python3 (the hooks use them); Claude Code with any Claude subscription.

1. Create your own copy: **Use this template** (or fork) on [the canon repository](https://github.com/ElJoakoDELxD/Chief-of-Vibes) → a repository you own. The canon is untouchable public property — your copy is your workshop, and making it is the system's first proof of utility.
2. Open your copy in Claude Code on `main`. The session compares `origin` against `.canon`, sees it is standing in your copy rather than the template, and greets you with the menu that offers onboarding — say **"onboard my agent"**. Name it, pick your language and timezone, state your goal. Minutes.
3. Work. Your agent lives on its own branch from then on; open `memory/` in Obsidian whenever you want to read its mind.

## What a day looks like

Every reply from your agent opens with its verifiable header, and every working day leaves one note in the vault:

```
[13-07-2026 09:02 -04 · CHIEF-OF-VIBES · Chief of Vibes]
Pending from yesterday: the launch post draft. Two backlog items need you …
```

```markdown
# memory/journal/2026-07-13.md
done:    launch post drafted; findability check on the docs site passed
decided: postpone the newsletter until the site earns its first signal
lessons: scheduling posts on Monday mornings doubled nothing — stop assuming, measure
```

When a thread cannot finish in one sitting — the work is long, or the chat's context window is filling — the agent writes a handoff note in `memory/handoff/` before quality degrades: state, next step, open decisions, dead ends. You open a fresh chat with a clean window and the agent picks the thread up mid-stride. The note is deleted once the work lands; the journal keeps what mattered.

## Open your agent's memory in Obsidian

The vault exists once your agent does (`memory/` lives on the agent branch, never on `main`):

1. Clone the repository on the machine where you use Obsidian and check out your agent branch: `git clone <your-repo> && cd <repo> && git checkout <AGENT-BRANCH>`.
2. In Obsidian: **Open folder as vault** → select the `memory/` folder inside the clone. Done — `state.md` shows as Properties, `journal/` reads as daily notes, briefs are linkable.
3. Keep it in sync: `git pull` after remote agent sessions, `git push` if you edit notes yourself — or install the community **Git** plugin (Vinzent03/obsidian-git) for automatic commit-and-sync inside Obsidian.

Obsidian's own config (`.obsidian/`) is gitignored, so opening the vault never dirties the repo.

## Why not just…

- **…a hand-written CLAUDE.md?** That is a file of good intentions. Here the discipline is mechanical (hooks and a CI guard), the memory has a schema, and the lifecycle exists: onboarding, daily journal, project gates, template updates via `tools/sync.sh`.
- **…Claude's built-in memory?** That memory is opaque, unversioned, and lives in someone else's product. This one is a folder of Markdown you own: readable, editable, greppable, versioned in git, and structured around work rather than chat recall.
- **…an agent framework?** No code to run, no server, no API keys beyond the Claude subscription you already pay. It lives in a git repo.
- **…an Obsidian AI plugin?** Those chat about your notes. This is an operator that produces and ships work — the notes are its memory, not its product.

## Map

`SYSTEM.md` — the full specification, readable in one sitting · `CLAUDE.md` — the runtime entry point · `.canon` — names the canon repository, so every session knows whether it is standing in the template or in your copy · `.claude/` — hooks and skills · `tools/` — clock and template-sync · `memory/` — what your agent knows · `projects/` — what it made (both exist only on agent branches, never on `main`) · `repomix.config.json` — run `npx repomix` to pack the whole template into one AI-readable file, e.g. to hand this entire system to any LLM.

## Contributing

Pull requests to the canon are welcome. Template files only — the CI guard rejects anything else — and one change per pull request, because `git log main` is the changelog. Every merge is a release, so bump `SYSTEM.md`'s version line in the same pull request: patch for wording, minor for a new mechanism, major for anything that breaks existing agents. Agent memory never leaves your own repository.

## Lineage

Chief of Vibes absorbs articulations from the open source it stands on; each line names what was learned, re-voiced in this system's own words:

- [open-gsd/gsd-core](https://github.com/open-gsd/gsd-core) — done is earned by verification against what was planned; decisions recorded before the build; a subagent's brief is a file, not a recap.
- [garrytan/gstack](https://github.com/garrytan/gstack) — the ethos travels with every skill.
- [pewdiepie-archdaemon/odysseus](https://github.com/pewdiepie-archdaemon/odysseus) — the canon stays runtime-agnostic; the runtime is an adapter.
- [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) — models and providers are routable resources; route work to the lightest path that does it well.
- [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) — one canonical spec, many runtime adapters.
- [vercel-labs/opensrc](https://github.com/vercel-labs/opensrc) — degrade loudly; never let a failure wear success's face.
- [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) — the compressed working layer.
- [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) — the publication register sweep.
- [microsoft/markitdown](https://github.com/microsoft/markitdown) — ingest documents, don't guess them.
- [yamadashy/repomix](https://github.com/yamadashy/repomix) — the single-file pack of the template.

## Contributing

To *use* the system, press **Use this template** and work in your copy. To change the template itself, this repository takes reviewed pull requests: what counts as a template file, how the version bump works, what the guards check, and a worked example of a release are all in [`CONTRIBUTING.md`](CONTRIBUTING.md). Issues are welcome too, and cheaper — the useful ones name where the system did the wrong thing and which rule you expected to stop it.

## License

MIT — see `LICENSE`. Your agent's memory and everything it produces are yours.
