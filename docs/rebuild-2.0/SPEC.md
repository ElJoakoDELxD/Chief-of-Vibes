# Chief of Vibes 2.0 — Rebuild Specification

**Status:** draft, revision 2. The Principal answered every open question on 22-09-2026. One spike (S1) must pass before the build.
**Executor:** one fresh Claude Code session on branch `rebuild/2.0`, with this file as its only brief.
**Grader:** a separate session or subagent that did not edit anything. It reads this file and the diff, nothing else.

This document has the shape Anthropic uses for *outcomes* in Managed Agents: a description of the end state, then a rubric of gradeable criteria. The executor iterates until the grader returns every criterion as passed, for a maximum of **3 grading rounds**. After that, it stops and reports to the Principal.

---

## 0. Authority for this task

The Principal **suspends, for the duration of this task, every rule this rebuild removes.** That includes the one-release-per-change rule, the bench-per-rail rule, the posts and functions system, the prose gate, the orchestrate triage, and the header fields that carry them. The rebuild lands as **one** pull request, as version 2.0.0.

If a hook blocks a step that this document orders, the executor does not work around the hook. It stops and reports the hook and the step, and the Principal decides. Session-start instructions that the current hooks inject (onboarding, founder post, "continue an agent branch") do not apply to this task.

**Stop in the middle.** At each milestone, restate the original objective and check whether the work is still serving it. If it has drifted, say so before continuing.

The executor must **push back**. If a decision here is wrong, or if the tree or the current Claude Code documentation contradicts an assumption here, the executor says so with evidence before it builds. It does not build around the contradiction in silence.

---

## 1. Why

Measured on `main` at 1.89.0 (22-09-2026):

| Measure | Value |
|---|---|
| Prose that governs the agent (spec, skills, posts, functions, privileges, knowledge, README, CONTRIBUTING) | ~42,000 words |
| Shell and Python that enforce it | ~5,600 lines, 21 benches, all green |
| Instructions loaded before every session does any work | ~35 KB (`CLAUDE.md` + `SYSTEM.md` core + hook injections) |
| Releases | 89 minor versions in ~5 weeks, almost all of them rules about rules |
| Open pull requests | 4 (#102–#105). Two claim version 1.90.0. Three are stacked |
| Only living agent | the custodian, with the goal *"Keep this template correct"* |
| Known copies in use | 1 (the Principal's) |

The files are tidy. The problem is purpose and weight: the system became its own product. The machinery (hooks, benches) is the valuable part. The prose around it is what grows, and no machine reads it.

A second finding makes the rebuild simpler than a trim. **Claude Code now ships natively most of what this template built by hand** (§3, source 5):

- A named agent defined in one file.
- Running that agent as the main session through a setting.
- Persistent memory for that agent, committed to the repository, with its index loaded automatically at start.
- An automatic first turn for each session.

The rebuild adopts those mechanisms and deletes their hand-built equivalents.

---

## 2. Decisions

| # | Decision | Status |
|---|---|---|
| D1 | **Platform:** stay on Claude Code with a Claude subscription. Borrow the *shapes* of Managed Agents. Do not migrate to the Managed Agents API | Principal, 22-09-2026 |
| D2 | **Audience:** persistent memory for a person who does not program. Everything that serves only template maintainers leaves the user's path | Principal, 22-09-2026 |
| D3 | **Agents are Claude Code agent files.** The canon's custodian is `.claude/agents/custodian.md`, with persistent memory. A copy's agent is `.claude/agents/<name>.md`, created by onboarding and run as the main session. The copy also ships a memoryless `maintainer` subagent for template updates | Principal, 22-09-2026 (revised from rev. 1: the custodian keeps a memory) |
| D4 | **Copies:** exactly one is known, the Principal's. 2.0.0 may break compatibility. That one copy gets a one-time migration (§6.2) | Principal, 22-09-2026 |
| D5 | **History is archived with tags, and living memory stays on a branch.** A *tag* is a fixed label: it marks one commit forever, and nobody works on it. A *branch* is a moving label: every new commit advances it. The old custodian branch and every stale branch become `archive/*` tags. The new custodian's memory lives on one long-lived branch named `custodian` | Recommended by the drafter, Principal delegated the choice, 22-09-2026 |
| D6 | **Language:** English for the template and this spec | Principal, 22-09-2026 |
| D7 | **The canon's `main` is the scaffold only:** template files plus empty forms that show the structure, and no filled memory. GitHub branch protection guards it. The custodian's memory lives on the `custodian` branch. **In a copy, `main` is home:** the user's agent and its memory live on `main`, and template updates arrive as a pull request that touches only template paths | Principal, 22-09-2026 |
| D8 | **Size limits ratchet.** There is no fixed target to cut toward. The executor removes everything that fails the removal test (§5.9) and keeps everything that passes it. The measured result becomes the ceiling in CI, and it may go down later but never silently up | Principal, 22-09-2026 |

**Why D5 and D7 fit together.** GitHub's *Use this template* copies only the default branch, `main`. The canon's `main` therefore has to stay clean, or every new copy would inherit the custodian's memory. The `custodian` branch never reaches a copy. The executor verifies this behaviour before relying on it (spike S2).

---

## 3. Sources and the principles taken from them

All read on 22-09-2026.

1. **Claude Code best practices** — https://code.claude.com/docs/en/best-practices
   - `CLAUDE.md` is loaded every session, so it holds only what applies broadly. For each line, ask *"Would removing this cause Claude to make mistakes?"* If not, cut it. *"Bloated CLAUDE.md files cause Claude to ignore your actual instructions."*
   - Hooks are for *"actions that must happen every time with zero exceptions"*. Skills are for knowledge that is needed only sometimes.
   - The agent that did the work is not the one that grades it.
2. **Scaling Managed Agents** (Anthropic engineering, 08-04-2026) — https://www.anthropic.com/engineering/managed-agents
   - *"Harnesses encode assumptions that go stale as models improve."* A mechanism that compensates for a model weakness must be re-tested against the current model, and removed when the weakness is gone.
3. **Managed Agents docs** — https://platform.claude.com/docs/en/managed-agents/overview
   - *Agent:* one versioned definition file (name, model, system prompt, tools, skills). *Permission policies:* declared per tool, not in prose.
   - *Memory stores:* *"many small focused files, not a few large ones"*. Reference material is read-only. The agent's own store is read-write.
   - *Dreams:* consolidation writes a **new** store. The input is never modified, and a human reviews the output before it is adopted.
   - *Outcomes:* a rubric, and a grader in a separate context window.
4. **Building effective agents** (Anthropic, 12-2024, marked by Anthropic as partly outdated) — https://www.anthropic.com/engineering/building-effective-agents
   - Only the principles that the 2026 sources repeat are kept. Find the simplest solution, and add complexity only when it demonstrably improves outcomes. Fixed steps belong in code, not in prose the model must interpret.
5. **Claude Code subagents** — https://code.claude.com/docs/en/sub-agents
   - An agent is a Markdown file in `.claude/agents/`, with frontmatter (`name`, `description`, `tools`, `model`, `memory`, `hooks`, `initialPrompt`, and others) and the system prompt as the body.
   - `memory: project` gives the agent a directory at `.claude/agent-memory/<name>/`, *"shareable via version control"*, and the docs recommend it as the default scope. The first 200 lines or 25 KB of its `MEMORY.md` load into the agent's system prompt automatically.
   - The `agent` setting, or `claude --agent <name>`, runs that agent as the main session. `initialPrompt` is *"auto-submitted as the first user turn when this agent runs as the main session agent"*. Frontmatter hooks also fire in that case.
6. **Claude Code memory** — https://code.claude.com/docs/en/memory
   - Auto memory lives in `~/.claude/projects/<project>/memory/`, outside the repository. A cloud session discards it. That is why this product keeps its memory inside the repository.

---

## 4. Product

**One sentence:** Chief of Vibes gives Claude Code a permanent, plain-text memory that the user owns, in a GitHub repository, with no git knowledge required.

**User journey:**

1. The user opens Claude Code and pastes: *"Set up my agent from https://github.com/ElJoakoDELxD/Chief-of-Vibes"*.
2. The session creates their copy and asks at most four questions: the agent's name, language, timezone, and goal.
3. From then on, every session opens as that agent, knowing yesterday's state and the pending work, and closes by writing it down.

Nothing else is in the user's path.

---

## 5. Target architecture

### 5.0 Spikes — run these before building, and report the results

| Spike | Question | If it fails |
|---|---|---|
| **S1** | With `"agent": "<name>"` in `.claude/settings.json` and `memory: project` in the agent file, does a session on the **web** (claude.ai/code) and in the **CLI** (a) run as that agent, (b) load `.claude/agent-memory/<name>/MEMORY.md`, and (c) fire `initialPrompt`? | Fall back to rev. 1: a `memory/` folder imported from `CLAUDE.md` with `@memory/agent.md`, and a SessionStart hook for the first turn. Report which part failed |
| **S2** | Does *Use this template* copy only the default branch, so that the `custodian` branch never reaches a copy? | Move the custodian's memory to `memory: local` plus a push to a separate private repository, and ask the Principal first |
| **S3** | For each hook the rebuild would keep, does the current model still make the mistake the hook prevents? Disable the hook, run one ordinary session, and record the result | Remove the hook |

The executor records every spike result in the PR description, with the command it ran and what it returned.

### 5.1 Tree — canon `main` (the scaffold)

```
CLAUDE.md                      short; project-wide rules only (§5.7)
README.md                      one screen for the user
CHANGELOG.md                   one line per release; 2.0.0 lists every removal and why
CONTRIBUTING.md                ≤ 1 page, for template maintainers
LICENSE
.claude/
  settings.json                hooks + permissions; no "agent" key on the canon
  agents/
    custodian.md               the canon's agent (memory: project)
    maintainer.md              memoryless subagent that ships to copies
    _example.md                empty form onboarding copies from
  agent-memory/
    _example/                  empty form: MEMORY.md index + backlog.md + journal/ + projects/
  hooks/                       only hooks that survive S3, each with a bench
  skills/onboard/  handoff/  update/
knowledge/                     read-only reference, shared with every copy
tests/                         benches
.github/workflows/ci.yml       every bench + size ratchet + version check
.github/workflows/release.yml
```

The `custodian` branch = `main` + `.claude/agent-memory/custodian/` filled. It merges `main` in to stay current. It sends template changes to `main` only through pull requests, and never its memory.

### 5.2 Tree — a copy's `main` (home)

Same as the canon, plus:

- `.claude/agents/<name>.md` and a filled `.claude/agent-memory/<name>/`, both created by `onboard`.
- `"agent": "<name>"` in `.claude/settings.json`.

The copy does not use the canon's custodian. The `update` skill must never overwrite the user's agent file, the user's memory, or the `agent` key.

### 5.3 The agent file

- Frontmatter: `name`, `description`, `model`, `memory: project`, `initialPrompt`.
- The body is the system prompt: the agent's identity (principal, language, timezone, goal), its duties at session start and session end, and nothing that `CLAUDE.md` already says.
- `initialPrompt` replaces the anchor hook's session-start instructions. It tells the agent to read its backlog and any handoff note, then report the pending work.
- The memory directory has these parts:
  - `MEMORY.md`: the index, at most 200 lines, curated by the agent.
  - `backlog.md`.
  - `journal/`: one file per day.
  - `projects/`.
  - `handoff/`.

### 5.4 Hooks

Keep a hook only if S3 shows that the failure it prevents still happens, and only if it has a bench.

| Hook | Default verdict |
|---|---|
| `anchor.sh` | **Reduce to exposure only.** It stops injecting the time. The clock is a sanity check the agent must perform, and a hook that hands over the answer turns it into something the agent can copy without doing it. `.claude/hooks/path.sh` puts `tools/bin` on PATH, and the agent runs `clock \| header` itself (§5.5) |
| `guard-install.sh` | **Keep** if S3 confirms it. The failure is environmental (installs vanish in cloud sessions), not a model weakness |
| `guard-identity.sh` | Keep it only if the release that introduced it (`git log -S`) names a real incident, and S3 still reproduces the failure |
| `guard-main.sh` | **Remove.** The canon uses branch protection (D7), and in a copy `main` is home |

### 5.5 Clock and reply header

The **format is the constant**: `[DD-MM-YYYY HH:MM TZ · <agent> · <branch> · <post>/<function> · <workplace> · <model>·<effort>]` is the canon's default. A copy may change it. **The method is not constant.** Built on 23-09-2026 as `tools/bin/clock` and `tools/bin/header`, with its bench in `tools/test-clock.sh`. The rebuild keeps them, and it adjusts the fields when posts are removed:

- `clock` tests candidate methods against an independent reference, the HTTPS `Date` header. Only then does it save the passing method in `tools/clock/methods.tsv`, keyed by environment signature (OS / runtime, nothing finer). The next session in that environment reuses the saved method and re-tests it every time.
- A reading 3 or more minutes from the reference, or a date that differs from the context date, prints `DESFASE` on stderr and changes nothing. The agent asks the Principal whether the time was right before it fixes anything.
- UTC on the canon is expected. Only a copy with a declared or auto-detected zone can be wrong about the zone.
- The header is a sanity check, like the brown-M&M clause: it proves that the agent did the work instead of copying a given answer. It is never handed out by a hook, and it is not the first instruction the agent reads.

### 5.6 Skills

| Skill | Fate |
|---|---|
| `onboard` | **Keep, rewritten.** It creates the copy (with *Use this template* as the fallback), asks ≤ 4 questions, writes `.claude/agents/<name>.md` and `.claude/agent-memory/<name>/` from the `_example` forms, sets the `agent` key, commits and pushes |
| `handoff` | **Keep.** It absorbs session-end journaling |
| `update` | **New.** It replaces `tools/sync.sh`, `propagate/references/sync.md` and the drift check. It reports whether the copy is behind the canon, and why. It opens a pull request that touches only template paths. Fold in the fix from PR #102: a shallow clone must not skip the ancestry check |
| `reset`, `5s`, `orchestrate`, `propagate`, `principal-approves`, `help`, `ste-writing` | **Remove** (§5.8) |

Each kept `SKILL.md` has valid `name` and `description` frontmatter.

### 5.7 CLAUDE.md and permissions

- `CLAUDE.md` holds only what applies to every agent in every session. First, the hard limits from today's `SYSTEM.md` §4: no money, no signatures, no promises to third parties, and the agent drafts while the Principal publishes. Then the few rescued rules that pass the removal test.
- Where a deny rule in `.claude/settings.json` can enforce a limit, it does, and the prose line goes.
- `posts/`, `functions/` and `privileges/` are removed.

### 5.8 Removed

`SYSTEM.md`, `system/`, `INDEX.md`, `CLOCKS.md`, `LANGUAGES.md`, `posts/`, `functions/`, `privileges/`, `memory/` (replaced by `.claude/agent-memory/`) and `repomix.config.json`.

Also removed: the tools `candidates`, `hygiene`, `explain`, `skills`, `models`, `clocks`, `environment`, `ready`, `sweep-branches`, `index`, `sections`, `prose-lint`, `prose-gate`, `redundancy.py`, `pr-guard` and `sync`, unless a kept piece calls one. The workflows `guard.yml`, `stacks.yml` and `sweep-branches.yml` are merged into `ci.yml` or removed.

Every removal gets one line in `CHANGELOG.md` 2.0.0 that says why.

**Rescue before removing.** Some rules carry a real lesson that deserves to live on: "verify before assert", "a negative answer names its frame", "the agent drafts, the Principal publishes", and "confirm focus before typing into a real keyboard". Each one either becomes one line in `CLAUDE.md`, if it passes the removal test for every session, or becomes a `knowledge/` entry. Never both. The rescue reads the archive tags and never edits them (the *Dreams* pattern). The executor lists what it rescued and where it put each item.

### 5.9 The removal test (D8)

For every line of prose, and for every hook, skill and tool that survives: *would removing it cause Claude to make a mistake that the current model actually makes?*

- **Yes, with evidence** (a spike, a bench, or an incident named in `git log`): keep it.
- **No, or no evidence:** remove it.
- **Unsure:** remove it, and list it in the PR description as *removed, restorable*.

No line is cut to reach a number, and no line is kept to protect one.

---

## 6. Migration

### 6.1 Canon

1. Tag, then delete, the stale branches. Push every tag before deleting anything:

   | Branch | Tag |
   |---|---|
   | `Chief-of-Vibes-Agent` | `archive/custodian-2026-09` |
   | each `claude/*` and `custodian/*` branch | `archive/<name>` |
2. Close PRs #102–#105 with one comment each that points to the 2.0.0 pull request. Carry over the #102 fix per §5.6.
3. After the merge, create the `custodian` branch from `main`. Seed `.claude/agent-memory/custodian/` with what the rescue (§5.8) assigned to the custodian, and nothing else.
4. The Principal enables branch protection on `main` (a GitHub setting). The executor writes the exact steps in the PR description.

### 6.2 The Principal's copy (after 2.0.0 lands)

This runs as a separate, later task, with its own spec:

- Convert the old `memory/state.md` into `.claude/agents/<name>.md`.
- Move `memory/` into `.claude/agent-memory/<name>/`.
- Move all of it to `main`.
- Apply the 2.0.0 template through the `update` skill.
- Archive the old agent branch as a tag.

---

## 7. Out of scope

- A migration to the Managed Agents API.
- New features.
- Multi-user support.
- Memory consolidation (a *Dreams*-style skill). Add it only when a measured memory-growth problem exists.
- Translating the template.

---

## 8. Rubric

The grader scores each criterion independently, as pass or fail, with evidence. A criterion that cannot be measured fails.

| # | Criterion | How to measure |
|---|---|---|
| R1 | Spikes S1–S3 ran, and each result is recorded with the command and its output | PR description |
| R2 | Every surviving line, hook, skill and tool passes the removal test (§5.9). The PR lists each *removed, restorable* item | Sample 20 surviving lines at random. Each must cite its evidence or be obviously a hard limit from §5.7 |
| R3 | CI records, and enforces as ceilings, the bytes loaded before the first turn and the words of governing prose. The PR states both, before and after | `ci.yml` step. Loaded bytes = `CLAUDE.md` + agent file + first 200 lines of `MEMORY.md` + hook output. Words = `wc -w` over template `*.md` outside `knowledge/`, `docs/` and `CHANGELOG.md` |
| R4 | Every path in §5.8 is absent | `ls` |
| R5 | Agent files follow the Claude Code subagent format: `custodian.md`, `maintainer.md`, `_example.md` | Parse the frontmatter against source 5 |
| R6 | Every remaining hook has a bench. All benches pass in `ci.yml` on the PR head | CI run link |
| R7 | The header is exactly three fields, built from measured values | Read hook output on a fresh clone |
| R8 | `README.md` asks the user to type no git command | Search the user steps for `git ` |
| R9 | `CHANGELOG.md` 2.0.0 names every removed item with a one-line reason | Cross-check against §5.8 |
| R10 | Every rescued rule lives in exactly one place | Grep each rule's key phrase |
| R11 | No open PRs except the 2.0.0 one. No stale branches remain; they exist only as `archive/*` tags | `git ls-remote` |
| R12 | Onboarding works end to end on a throwaway copy. A web session that receives only "hi" ends with the agent file and memory created after ≤ 4 questions, committed and pushed. The next session opens as that agent and reports its backlog | **Performed by the Principal.** The executor prepares the steps. The grader cannot pass this criterion alone |

---

## 9. Rules after 2.0.0

These go into `CONTRIBUTING.md`, in at most 10 lines:

1. **No new rule without a failure a user saw.** Name the failure in the PR.
2. **A rule is a hook with a bench, a deny rule, or at most one line in `CLAUDE.md`.** Prose policies are not accepted.
3. **One open template PR at a time.** Semver: a patch for fixes, a minor for features, a major for breaks.
4. **Re-test assumptions when the model changes.** Rerun S3 for every hook, and apply the removal test to `CLAUDE.md`.
5. **Sizes only ratchet down.** A PR that raises a CI ceiling states why in its description, and the Principal approves it.
