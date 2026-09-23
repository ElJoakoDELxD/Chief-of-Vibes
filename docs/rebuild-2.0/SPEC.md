# Chief of Vibes 2.0 — Rebuild Specification

**Status:** revision 4 (23-09-2026). It consolidates every decision and spike to date. It is ready for the Principal's approval once the questions in §10 are answered. The build also needs one change to the environment (§5.0, E1).
**Executor:** one fresh Claude Code session on branch `rebuild/2.0`, created from `claude/repository-organization-dkragp`, with this file as its only brief. That branch already carries the clock (§5.5) and an anchor hook that hands over no time.
**Grader:** a separate session or subagent that did not edit anything. It reads this file and the diff, nothing else.

This document has the shape Anthropic uses for *outcomes* in Managed Agents: a description of the end state, then a rubric of gradeable criteria. The executor iterates until the grader returns every criterion as passed, for a maximum of **3 grading rounds**. After that, it stops and reports to the Principal.

---

## 0. Authority for this task

The Principal **suspends, for the duration of this task, every rule this rebuild removes.** That includes the one-release-per-change rule, the posts and functions system, the prose gate, the orchestrate triage, and the header fields that carry them. The rebuild lands as **one** pull request, as version 2.0.0. Everything already on the source branch ships inside that release, not before it.

If a hook blocks a step that this document orders, the executor does not work around the hook. It stops and reports the hook and the step, and the Principal decides. Session-start instructions that the current hooks inject (onboarding, founder post, "continue an agent branch") do not apply to this task.

**Stop in the middle, and ask.** At each milestone, stop and ask the Principal, in these words: *am I still following the original objective, or have I drifted?* Do not restate the objective, and do not answer the question yourself: a restatement is an assumption, and the answer is the Principal's decision.

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

The files are tidy. The problem is purpose and weight. The system became its own product, which is failure 3 of its own north star (§4). The north star said so, but it lived in a file no session had to read.

A second finding makes the rebuild simpler than a trim. **Claude Code now defines agents natively**, as one Markdown file each, and spikes on the web (Appendix A) measured which parts of that hold there:

- An agent file sets the identity. This holds.
- A setting sets the agent a session runs as. This holds.
- Native agent memory does not load on the web.
- The automatic first turn does not fire on the web.

The rebuild uses what holds, and it builds the rest as small, benched parts.

---

## 2. Decisions

| # | Decision | Status |
|---|---|---|
| D1 | **Platform:** stay on Claude Code with a Claude subscription. Borrow the *shapes* of Managed Agents. Do not migrate to the Managed Agents API | Principal, 22-09-2026 |
| D2 | **Audience:** persistent memory for a person who does not program. Everything that serves only template maintainers leaves the user's path | Principal, 22-09-2026 |
| D3 | **An agent is one file: `.claude/agents/<name>.md`.** The body is its personality. `effects:` in the frontmatter are its permissions (D11). `skills:` are its abilities. This replaces `posts/`, `functions/` and `privileges/` | Principal, 22–23-09-2026 |
| D4 | **Copies:** exactly one is known, the Principal's. 2.0.0 may break compatibility. That one copy gets a one-time migration (§6.2) | Principal, 22-09-2026 |
| D5 | **History is archived with tags, and living memory stays on a branch.** A *tag* is a fixed label: it marks one commit forever, and nobody works on it. A *branch* is a moving label: every new commit advances it. Every stale branch becomes an `archive/*` tag | Drafter's recommendation; the Principal delegated the choice, 22-09-2026 |
| D6 | **Language:** English for the template and this spec | Principal, 22-09-2026 |
| D7 | **Three layers, one shape.** Each layer is a `main` curated by a custodian. (1) The canon's `main` holds the scaffold only: template files plus empty forms, and no filled memory. GitHub branch protection guards it. (2) A copy's `main` is home for one person, and all of that person's agents and memory live there. (3) One branch per person, each acting as that person's own `main`, while the copy's `main` is curated for all of them | Principal, 23-09-2026. **2.0 builds layers 1 and 2.** Layer 3 is the documented extension path, and it is built when a second person uses the same copy. The Principal did not object to this deferral; it is recorded here as an assumption |
| D8 | **Size limits ratchet.** There is no fixed target to cut toward. The executor removes everything that fails the removal test (§5.9) and keeps everything that passes it. The measured result becomes the ceiling in CI, and it may go down later but never silently up | Principal, 22-09-2026 |
| D9 | **The north star already exists, and it moves where every session reads it.** The purpose in `system/1-purpose.md` §1 goes to the head of `CLAUDE.md`, the one file every session loads, quoted and never restated | Principal, 23-09-2026. **The exact text waits on §10 N1** |
| D10 | **The custodian's mandate.** In the Principal's words, translated: *the canon always has the structure of a product, public and easy to use, and it never deviates from that. It is a public repository, so it must always look, feel and work like a professional product: a stable release, usable, with the fewest possible failures, contradictions, repetitions, and cases of the same thing said differently.* §5.4 says how each property is held | Principal, 23-09-2026 |
| D11 | **Effects declare their permission.** An agent's permissions are the effects it declares, in positive form: *the agent writes its memory in `X`*, never *the agent may not write outside `X`*. What is not declared is closed. The sentence that describes an effect is the permission for it, so nothing is said twice. An agent never holds an effect over its own definition, and a chat's first declaration of its agent is final | Principal, 23-09-2026 |
| D12 | **One chat, one agent.** A chat runs as exactly one agent from its start to its end. A new chat chooses an existing agent or creates one. One person may have many agents | Principal, 23-09-2026 |
| D13 | **A chat adopts its agent by reading.** At the start, the chat reads the agent file and the agent's memory index, then declares the agent with `header --declare agent=<name>`. A hook enforces the agent's effects from that point on. The web measurements support this route (Appendix A: S1, S4, S5) | Principal, 23-09-2026 |

**Why D5 and D7 fit together.** GitHub's *Use this template* copies only the default branch. The canon's custodian therefore keeps its filled memory on a `custodian` branch, which no copy ever receives. The executor verifies this behaviour before relying on it (spike S2).

---

## 3. Sources and the principles taken from them

All read on 22–23-09-2026.

1. **Claude Code best practices** — https://code.claude.com/docs/en/best-practices
   - `CLAUDE.md` is loaded every session, so it holds only what applies broadly. For each line, ask *"Would removing this cause Claude to make mistakes?"* If not, cut it. *"Bloated CLAUDE.md files cause Claude to ignore your actual instructions."*
   - Hooks are for *"actions that must happen every time with zero exceptions"*. Skills are for knowledge that is needed only sometimes.
   - The agent that did the work is not the one that grades it.
2. **Scaling Managed Agents** (Anthropic engineering, 08-04-2026) — https://www.anthropic.com/engineering/managed-agents
   - *"Harnesses encode assumptions that go stale as models improve."* A mechanism that compensates for a model weakness must be re-tested against the current model, and removed when the weakness is gone.
3. **Managed Agents docs** — https://platform.claude.com/docs/en/managed-agents/overview
   - *Agent:* one versioned definition file. *Permission policies:* declared, not written as prose.
   - *Memory stores:* *"many small focused files, not a few large ones"*. Reference material is read-only. The agent's own store is read-write.
   - *Dreams:* consolidation writes a **new** store. The input is never modified, and a human reviews the output before it is adopted.
   - *Outcomes:* a rubric, and a grader in a separate context window.
4. **Building effective agents** (Anthropic, 12-2024, marked by Anthropic as partly outdated) — https://www.anthropic.com/engineering/building-effective-agents
   - Only the principles that the 2026 sources repeat are kept. Find the simplest solution, and add complexity only when it demonstrably improves outcomes. Fixed steps belong in code, not in prose the model must interpret.
5. **Claude Code subagents** — https://code.claude.com/docs/en/sub-agents
   - An agent is a Markdown file in `.claude/agents/`, with frontmatter and the system prompt as the body. The `agent` setting runs one as the main session.
6. **Claude Code memory** — https://code.claude.com/docs/en/memory
   - Auto memory lives outside the repository, and a cloud session discards it. This product therefore keeps its memory inside the repository.
7. **Claude Code sandboxing** — https://code.claude.com/docs/en/sandboxing
   - The sandbox limits what Bash can write, at the operating-system level, with `sandbox.filesystem` rules. On Linux it needs `bubblewrap` and `socat`.

---

## 4. Product

**North star (D9).** It is quoted from `system/1-purpose.md` §1 and not restated. The text that opens `CLAUDE.md` is this one, with only the cuts that the Principal approves in §10 N1:

> Chief of Vibes makes Claude Code and a git repository into a persistent AI colleague. The repository holds two parts. The **template** is this specification and its machinery. It is generic and identical for every user. The **agent** is yours. It lives on its own branch, keeps its memory in `memory/`, and puts its output in `projects/`.
>
> The design removes three failure modes of work with an LLM:
>
> 1. **Work evaporates.** A chat makes something useful, the window closes, and nothing accumulates. Here every session ends with a commit and a push, and memory compounds.
> 2. **The AI validates itself.** Plans, frameworks, and dashboards look confident, and no outsider ever reads them. Only an unsolicited external signal counts as success (§7).
> 3. **Process eats product.** The tool improves itself and ships nothing. Here meta-work has a bound. Given one unit of effort, and a choice between a better system and shipped work, ship the work.
>
> **Why this exists.** The power stays with the person. Their repository, their rules, their agent. The system is built so that its user, in the end, needs no system: free to decide, to try, and to stop. So the deepest question here is not only what the work is for. It is what the Principal is here for. That question is never asked on a schedule and never forced. It surfaces when the work raises it, and the agent lets it surface rather than filling the silence.

**User journey:**

1. The user opens Claude Code and pastes: *"Set up my agent from https://github.com/ElJoakoDELxD/Chief-of-Vibes"*.
2. The session creates their copy and asks at most four questions: the agent's name, language, timezone, and goal.
3. From then on, every new chat starts by choosing one of the user's agents or creating another (D12). It opens knowing that agent's state and pending work, and it closes by writing them down.

Nothing else is in the user's path.

---

## 5. Target architecture

### 5.0 Before the build: environment and spikes

**E1. The environment must be able to sandbox Bash.** This is the Principal's action, because a cloud environment's setup script is a setting that only the Principal can change. Add these lines to the setup script of the environment in claude.ai/code:

```bash
apt-get update -qq
apt-get install -y -qq bubblewrap socat
```

Measured 23-09-2026: `bwrap: command not found` in this environment. It runs Ubuntu 24.04, and the sandbox documentation warns that AppArmor on that release can block `bubblewrap` user namespaces. Spike S6 measures whether it works.

| Spike | Question | Status | If it fails |
|---|---|---|---|
| **S1** | Does the web run a session as the agent set in `settings.json`, load its native memory, and fire `initialPrompt`? | **Done.** Identity: yes. Memory and first turn: no (Appendix A) | Taken: memory and the first turn are built (D13, §5.3) |
| **S2** | Does *Use this template* copy only the default branch? | Open, for the executor | Move the canon custodian's memory to a separate private repository, and ask the Principal first |
| **S3** | For each hook the rebuild keeps, does the current model still make the mistake the hook prevents? Disable the hook, run one ordinary session, and record the result | Open, for the executor | Remove the hook |
| **S4** | Can a chat adopt an agent by reading, and can a hook enforce that agent's rules? | **Done.** Yes, for tool calls (Appendix A) | — |
| **S5** | Do effects work as permissions: the declared path allowed, anything else blocked, the agent's own file blocked, and the declaration locked? | **Done** (Appendix A) | — |
| **S6** | With E1 in place, does the sandbox limit Bash writes to the adopted agent's declared effects? | Open. It needs E1 | Bash stays unenforced, and `README.md` and `CONTRIBUTING.md` say so in one line each |

The executor records every spike result in the PR description, with the command it ran and what it returned.

### 5.1 Tree — the canon's `main` (the scaffold)

```
CLAUDE.md                      the north star (D9), then rules for every agent (§5.7)
README.md                      one screen for the user
CHANGELOG.md                   one line per release; 2.0.0 lists every removal and why
CONTRIBUTING.md                ≤ 1 page, for template maintainers
LICENSE
.claude/
  settings.json                hooks and permissions; no "agent" key
  agents/
    custodian.md               the curator of a main, at any layer (§5.4)
    _example.md                the empty form that onboarding copies from
  hooks/                       only hooks that pass S3, each with a bench
  skills/onboard/  handoff/  update/  5s/
memory/
  _example/                    the empty form: MEMORY.md + backlog.md + journal/ + projects/ + handoff/
knowledge/                     read-only reference, shared with every copy
tools/bin/                     clock, header
tests/                         benches
.github/workflows/ci.yml       every bench, the size ratchet, and the version check
.github/workflows/release.yml
```

The `custodian` branch is `main` plus a filled `memory/custodian/`. It merges `main` in to stay current. It sends template changes to `main` only through pull requests, and it never sends its memory.

### 5.2 Tree — a copy's `main` (home for one person)

It is the same as the canon's `main`, plus one pair of entries for each agent that the person has:

- `.claude/agents/<name>.md`, created by `onboard`.
- `memory/<name>/`, created by `onboard` from `memory/_example/`.

**Proposed, §10 N2:** memory lives in the visible `memory/<name>/` rather than `.claude/agent-memory/<name>/`. The hidden path existed only for native memory loading, and S1 measured that loading as absent on the web. A person who does not program should find their agent's memory without knowing about hidden folders, and the Obsidian vault in `README.md` depends on it.

The `update` skill never overwrites an agent file or anything under `memory/<name>/`.

### 5.3 The agent file, and how a chat adopts it

```yaml
---
name: <name>
description: <one line>
effects:
  - writes: memory/<name>/
  - writes: projects/<name>/
  - pushes: the branch this person works on
---
<personality: who the agent serves, language, timezone, goal>
```

- **The body is the personality.** It holds nothing that `CLAUDE.md` already says.
- **Effects are permissions** (D11). The hook `agent-permissions.sh` enforces `writes:` for `Write`, `Edit`, `MultiEdit` and `NotebookEdit`. It blocks any path that no effect declares, and it always blocks the agent's own file. S6 decides how Bash is held. `pushes:` needs its own rail, which the executor reads from `lib/command.sh` as `guard-main.sh` did, with a bench.
- **Adoption** (D13). A SessionStart hook lists the agents that exist. The chat asks which one, or creates one through `onboard`. Then it reads the agent file and `memory/<name>/MEMORY.md`, and runs `header --declare agent=<name>`. A second declaration to a different agent is refused: *one chat, one agent; open a new chat*. **Proposed, §10 N3:** when exactly one agent exists, the chat adopts it without asking, and it says which agent it adopted.
- The memory folder holds `MEMORY.md` (the index, at most 200 lines, curated by the agent), `backlog.md`, `journal/` (one file per day), `projects/`, and `handoff/`.
- **The limit of D11 today:** a hook reads tool calls, so a file written through Bash does not pass through it. Until S6 passes, `README.md` states this in one line.

The S5 implementation is the starting point: `.claude/hooks/agent-permissions.sh` and `tools/bin/header` at `spike/s5-effects`. The executor ports them and adds a bench that pins every result in Appendix A.

### 5.4 The custodian and its mandate (D10)

**Proposed, §10 N2:** one agent file, `custodian.md`, is the curator of a `main` at every layer (D7). On the canon it curates the template. In a copy it curates that copy's `main`: it applies updates from the canon and runs 5S. This replaces the separate `maintainer.md`: one role, one name, one file.

`custodian.md` carries D10 word for word, and the means below:

| Property | How it is held |
|---|---|
| **Few failures** | Every bench runs in CI. A release is cut only from a `main` that is green and graded |
| **Stable release** | `main` changes only by release, with semver, a `CHANGELOG.md` line and a tag. **The custodian's default action is none.** It batches fixes into releases and never ships one release per finding. This is the brake: the previous custodian had nearly this mandate (*"Keep this template correct"*) and shipped 89 releases in 5 weeks. Polish without a brake is churn, and churn is the opposite of stable |
| **Easy to use** | R12 (onboarding end to end) runs again for every release that touches onboarding, adoption, the README, or the forms |
| **No repetition, and nothing said twice in other words** | Each fact has one home, and every other mention links to it. The 5S skill's *shine* step asks *is this said twice?* and *is this the same thing said in other words?* `tools/redundancy.py` ranks the candidate pairs for it, and it also runs in CI as a report. The custodian decides each pair and records the verdict |
| **No contradictions** | The 5S *shine* step asks *do these two disagree?* Before each release, a subagent with a fresh context, which did not write the change, runs `5s documents` over the public files. This is a reading by a model, not a mechanical check, so the custodian resolves each finding or records why it is not one |
| **Looks and feels professional** | `README.md`, `LICENSE`, `CHANGELOG.md`, `CONTRIBUTING.md` and the release notes exist and agree. Public files carry no internal vocabulary (rungs, posts, sensors) that a user must learn to use the product |
| **Measured from outside** | North star, failure 2: the custodian cannot certify its own work. The evidence that the product is usable is an outsider using it, and the release notes report that |

### 5.5 Clock and reply header

**The format is the constant, and the method is not.** The 2.0 default is:

`[DD-MM-YYYY HH:MM TZ · <agent> · <branch> · <workplace> · <model>·<effort>]`

The post field is removed together with posts. A copy may change the format.

`tools/bin/clock` and `tools/bin/header` already exist, with the bench `tools/test-clock.sh`:

- `clock` tests candidate methods against an independent reference, the HTTPS `Date` header. Only then does it save the passing method in `tools/clock/methods.tsv`, keyed by an environment signature (OS and runtime, nothing finer). The next session in that environment reuses the saved method, and it tests the method again each time.
- A reading 3 or more minutes from the reference, or a date that differs from the context date, prints `DESFASE` on stderr and changes nothing. The agent asks the Principal whether the time was right before it fixes anything.
- UTC on the canon is expected. Only a copy with a declared or auto-detected zone can be wrong about the zone.
- `header` reads every field and remembers none. The agent comes from the chat's declaration (D13). The model comes from the transcript, and the effort from the environment. A field it cannot read prints as `?`, and `header` says why.
- The header is a sanity check, like the brown-M&M clause: it proves that the agent did the work instead of copying a given answer. No hook hands it over (`.claude/hooks/path.sh` only puts `tools/bin` on PATH), and it is not the first instruction the agent reads.

### 5.6 Hooks

Keep a hook only if S3 shows that the failure it prevents still happens, and only if it has a bench.

| Hook | Verdict |
|---|---|
| `path.sh` | **Keep.** It exposes `clock` and `header`. Web-verified on 23-09-2026 |
| `anchor.sh` | **Reduce** to the session context that remains true in 2.0: the list of agents for adoption (D13), and the update check (§5.7). It never carries the time or the branch |
| `agent-permissions.sh` | **Add**, ported from S5, with a bench (§5.3) |
| `guard-install.sh` | **Keep** if S3 confirms it. The failure is environmental (installs vanish in cloud sessions), not a model weakness |
| `guard-identity.sh` | Keep it only if the release that introduced it (`git log -S`) names a real incident, and S3 still reproduces the failure |
| `guard-main.sh` | **Remove.** The canon uses branch protection (D7), and in a copy `main` is home |

### 5.7 Skills, CLAUDE.md and permissions

| Skill | Fate |
|---|---|
| `onboard` | **Keep, rewritten.** It creates the copy (with *Use this template* as the fallback), or creates a further agent in an existing copy. It asks ≤ 4 questions and writes the agent file and `memory/<name>/` from the forms, with the default effects. Then it commits and pushes |
| `handoff` | **Keep.** It absorbs session-end journaling |
| `update` | **New.** It replaces `tools/sync.sh`, `propagate/references/sync.md` and the drift check. It reports whether the copy is behind the canon, and why, and it opens a pull request that touches only template paths. It folds in the fix from PR #102: a shallow clone must not skip the ancestry check |
| `5s` | **Keep.** It is the custodian's procedure for D10, and its `memory` target also serves every agent. It is rewritten to the new tree |
| `reset`, `orchestrate`, `propagate`, `principal-approves`, `help`, `ste-writing` | **Remove** (§5.8) |

Each kept `SKILL.md` has valid `name` and `description` frontmatter.

`CLAUDE.md` holds the north star, then only what applies to every agent in every session. First come the hard limits from today's `SYSTEM.md` §4: no money, no signatures, no promises to third parties, and the agent drafts while the Principal publishes. Then come the rescued rules that pass the removal test, and the one line on how a reply opens (`clock | header`). Where a deny rule in `.claude/settings.json` can enforce a limit, it does, and the prose line goes.

### 5.8 Removed

These paths are removed: `SYSTEM.md`, `system/`, `INDEX.md`, `CLOCKS.md`, `LANGUAGES.md`, `posts/`, `functions/`, `privileges/`, `memory/state.md` (replaced by the agent file), and `repomix.config.json`.

These tools are removed too, unless a kept piece calls one: `candidates`, `hygiene`, `explain`, `skills`, `models`, `clocks`, `now`, `environment`, `ready`, `sweep-branches`, `index`, `sections`, `prose-lint`, `prose-gate`, `pr-guard` and `sync`. **`tools/redundancy.py` stays:** it is the custodian's instrument for D10. The workflows `guard.yml`, `stacks.yml` and `sweep-branches.yml` are merged into `ci.yml` or removed.

Every removal gets one line in `CHANGELOG.md` 2.0.0 that says why.

**The north star is moved, not rescued.** Before `system/` is deleted, the purpose text goes to the head of `CLAUDE.md` (D9). Deleting `system/` without this step deletes the product's reason to exist.

**Rescue before removing.** Some rules carry a real lesson that deserves to live on: "verify before assert", "a negative answer names its frame", "the agent drafts, the Principal publishes", and "confirm focus before typing into a real keyboard". Each one either becomes one line in `CLAUDE.md`, if it passes the removal test for every session, or becomes a `knowledge/` entry. Never both. The rescue reads the archive tags and never edits them (the *Dreams* pattern). The executor lists what it rescued and where it put each item.

### 5.9 The removal test (D8)

Every line of prose, and every hook, skill and tool, answers two questions in order.

1. *Does it serve the north star (D9) or the custodian's mandate (D10)?* If yes, go to question 2. If not, but it corrects an error, it **leaves the always-loaded context**. Keep only the part that corrects the error, somewhere that loads when needed (a hook, a bench, a skill), or reformulate it so that it serves the purpose. If it neither serves the purpose nor corrects an error, remove it.
2. *Would removing it cause Claude to make a mistake that the current model actually makes?*
   - **Yes, with evidence** (a spike, a bench, or an incident named in `git log`): keep it.
   - **No, or no evidence:** remove it.
   - **Unsure:** remove it, and list it in the PR description as *removed, restorable*.

No line is cut to reach a number, and no line is kept to protect one.

---

## 6. Migration

### 6.1 Canon

1. Tag, then delete, the stale branches. Push every tag before deleting anything.

   | Branch | Tag |
   |---|---|
   | `Chief-of-Vibes-Agent` | `archive/custodian-2026-09` |
   | each `claude/*`, `custodian/*` and `spike/*` branch | `archive/<name>` |

2. Close PRs #102–#105 with one comment each that points to the 2.0.0 pull request. Carry over the #102 fix per §5.7.
3. After the merge, create the `custodian` branch from `main`. Seed `memory/custodian/` with what the rescue (§5.8) assigned to the custodian, and nothing else.
4. The Principal enables branch protection on `main` (a GitHub setting). The executor writes the exact steps in the PR description.

### 6.2 The Principal's copy (after 2.0.0 lands)

This runs as a separate, later task, with its own spec:

- Convert `memory/state.md` into `.claude/agents/<name>.md`, with the default effects.
- Move the agent's memory into `memory/<name>/`.
- Move all of it to the copy's `main`.
- Apply the 2.0.0 template through the `update` skill.
- Archive the old agent branch as a tag.

---

## 7. Out of scope

- A migration to the Managed Agents API.
- New features.
- Layer 3 of D7 (one branch per person), until a second person uses the same copy.
- Memory consolidation (a *Dreams*-style skill). Add it only when a measured memory-growth problem exists.
- Translating the template.

---

## 8. Rubric

The grader scores each criterion independently, as pass or fail, with evidence. A criterion that cannot be measured fails.

| # | Criterion | How to measure |
|---|---|---|
| R1 | Spikes S2, S3 and S6 ran, and each result is recorded with the command and its output. S6 may record "E1 not in place" | PR description |
| R2 | Every surviving line, hook, skill and tool passes the removal test (§5.9). The PR lists each *removed, restorable* item | Sample 20 surviving lines at random. Each must cite its evidence, or be a hard limit from §5.7 |
| R3 | CI records, and enforces as ceilings, the bytes loaded before the first turn and the words of governing prose. The PR states both, before and after | A `ci.yml` step. Loaded bytes = `CLAUDE.md` + SessionStart hook output. Words = `wc -w` over template `*.md` outside `knowledge/`, `docs/` and `CHANGELOG.md` |
| R4 | Every path in §5.8 is absent | `ls` |
| R5 | `custodian.md` and `_example.md` follow the agent-file format of §5.3, and they parse as Claude Code subagents | Parse the frontmatter |
| R6 | Every remaining hook has a bench. All benches pass in `ci.yml` on the PR head | CI run link |
| R7 | `clock \| header` prints exactly the §5.5 fields, each read and none remembered | Run it on a fresh clone, with and without a declared agent |
| R8 | `README.md` asks the user to type no git command | Search the user steps for `git ` |
| R9 | `CHANGELOG.md` 2.0.0 names every removed item with a one-line reason | Cross-check against §5.8 |
| R10 | Every rescued rule lives in exactly one place | Grep each rule's key phrase |
| R11 | No open PRs except the 2.0.0 one. No stale branches remain; they exist only as `archive/*` tags | `git ls-remote` |
| R12 | On a throwaway copy, a web chat that receives only "hi" ends with an agent file and `memory/<name>/` created after ≤ 4 questions, committed and pushed. A second chat adopts that agent and reports its backlog. A third chat creates a second agent. A fourth chat is offered both | **Performed by the Principal.** The executor prepares the steps. The grader cannot pass this criterion alone |
| R13 | `CLAUDE.md` opens with the north star: the text in `system/1-purpose.md` §1 at the archive tag, minus only the cuts the Principal approved in §10 N1 | `diff` |
| R14 | `custodian.md` carries D10 word for word, and each means in §5.4 exists: a named CI step, a checklist line, or a file | Parse the file, then cross-check `ci.yml` and the tree |
| R15 | No fact lives in two public files. The `redundancy.py` report over all public prose is attached, and every pair above the threshold has a recorded verdict | PR description |
| R16 | A `5s documents` pass by a fresh-context subagent over the public files is attached, and it has no open item | PR description |
| R17 | The `agent-permissions.sh` bench pins every S5 result: a declared path is allowed, an undeclared path is blocked, the agent's own file is blocked, `..` traversal is blocked, and a second declaration is refused | Run the bench |

---

## 9. Rules after 2.0.0

These go into `CONTRIBUTING.md`, in at most 10 lines:

1. **No new rule without a failure a user saw.** Name the failure in the PR.
2. **A rule is a hook with a bench, a declared effect, a deny rule, or at most one line in `CLAUDE.md`.** Prose policies are not accepted.
3. **One open template PR at a time.** Semver: a patch for fixes, a minor for features, a major for breaks.
4. **Re-test assumptions when the model changes.** Rerun S3 for every hook, and apply the removal test to `CLAUDE.md`.
5. **Sizes only ratchet down.** A PR that raises a CI ceiling states why in its description, and the Principal approves it.
6. **The custodian's default is no change.** A finding alone is not a release. Fixes are batched.
7. **Before every release:** benches green, a `5s documents` pass clear, its redundancy pairs decided, and R12 run again when onboarding, adoption, the README or the forms changed.

---

## 10. Open questions for the Principal

**N1. The north star mixes purpose with mechanism, and the mechanism is changing.** Quoted verbatim, three parts of it would contradict the rebuilt tree in the one file every session loads. That breaks D10.

| Text in the north star | What 2.0 does instead |
|---|---|
| *"It lives on its own branch"* | The agent lives on the copy's `main`, beside the person's other agents (D7, layer 2) |
| *"keeps its memory in `memory/`, and puts its output in `projects/`"* | Memory is in `memory/<name>/`, and output is in `projects/<name>/` (§5.3) |
| *"(§7)"* | `system/` is deleted, so the pointer leads nowhere |

The drafter's proposal is to cut those three pieces and change nothing else: architecture belongs in the tree, and purpose belongs in the north star. The purpose sentences, the three failure modes and *Why this exists* stay word for word. The Principal decides. Until then, R13 cannot pass.

**N2. Two simplifications, proposed by the drafter on 23-09-2026 and not yet decided:**

- Memory lives in the visible `memory/<name>/`, not in `.claude/agent-memory/<name>/` (§5.2).
- One `custodian.md` curates a `main` at every layer, and it replaces `maintainer.md` (§5.4).

**N3. Adoption when only one agent exists.** Should the chat adopt that agent without asking, and say which agent it adopted (§5.3)? The drafter proposes yes: asking a question with one possible answer is friction. The cost is one line of output that the Principal must read to notice a wrong agent.

---

## Appendix A. Spike evidence

All spikes ran on the web (claude.ai/code), in child sessions that recorded their results in the repository. Each is one run, and the results are a model's report of its own context and tool results. They are evidence, not proof.

**S1 (23-09-2026). A native agent as the main session.** Branch `spike/s1-agent`, result commit `a424299`. The agent file set `memory: project` and `initialPrompt`, and `.claude/settings.json` set `"agent": "probe"`. The probe was forbidden to read files to find its answers.

| Part | Result |
|---|---|
| The session runs as the agent | **Yes.** It saw a codename that exists only in the agent body |
| Native memory loads `MEMORY.md` into the prompt | **No.** The marker was "not in context" |
| `initialPrompt` fires as the first turn | **No.** The marker was "not in context" |

A second finding came from this session itself: an agent file created after a session starts is not available in that session (`Agent type 'probe' not found`). The agent is fixed when the chat starts, which is D12.

**S4 (23-09-2026). Adopting an agent by reading.** Branch `spike/s4-adopt`, result commit `3420746`.

| Check | Result |
|---|---|
| The hook and Bash see the same session identity | **Yes.** The session ID is the same in both, and the declaration is found |
| `Write` before the declaration (control) | Passed |
| `Write` and `WebFetch` after the declaration, both banned by name | **Blocked**, with the agent and the file named in the error |
| The header shows the adopted agent | **Yes** |
| A file write through Bash while `Write` is banned | **Succeeded.** A ban on a tool is not a ban on an effect, and this is equally true of Claude Code's native `disallowedTools` |

**S5 (23-09-2026). Effects as permissions.** Branch `spike/s5-effects`, spike commit `5f52c8b`, result commit `1b930f4`. The agent file declared two `writes:` effects.

| Check | Result |
|---|---|
| `Write` before any declaration (control) | Allowed |
| `header --declare agent=scout` | Accepted |
| A second declaration, `agent=other` | **Refused:** *this chat already runs as 'scout'. One chat, one agent: open a new chat for 'other'.* |
| `Write` to a declared path | Allowed |
| `Write` to an undeclared path | **Blocked:** *agent 'scout' declares no effect that writes spike/outside.txt* |
| `Edit` of the agent's own file | **Blocked:** *agent 'scout' may not change its own definition* |
| `Write` through `..` out of a declared path | **Blocked.** The path is normalized before it is matched |
| A plain Bash write to the declaration file | **Succeeded.** The header then showed `other`. The lock holds against the tool, not against Bash |

S4 and S5 lead to the same conclusion. The hook holds every effect that passes through a tool call. Bash passes around it, both for file writes and for the declaration itself. Only the operating-system sandbox closes that gap, and it needs E1 (§5.0). Until S6 passes, D11 prevents honest mistakes. It is not yet a security boundary, and the product says so.
