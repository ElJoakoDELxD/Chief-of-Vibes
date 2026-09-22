# Chief of Vibes 2.0 — Rebuild Specification

**Status:** draft, awaiting Principal approval. **Drafted:** 22-09-2026.
**Executor:** one fresh Claude Code session on branch `rebuild/2.0`, with this file as its only brief.
**Grader:** a separate session or subagent that did not edit anything. It reads this file and the diff, nothing else.

This document has the shape Anthropic uses for *outcomes* in Managed Agents: a description of the end state, then a rubric of gradeable criteria. The executor iterates until the grader returns every criterion as passed, for a maximum of **3 grading rounds**. After that, it stops and reports to the Principal.

---

## 0. Authority for this task

The Principal **suspends, for the duration of this task, every rule this rebuild removes.** That includes the one-release-per-change rule, the bench-per-rail rule, the posts and functions system, the prose gate, the orchestrate triage, and the header fields that carry them. The rebuild lands as **one** pull request, as version 2.0.0.

If a hook blocks a step that this document orders, the executor does not work around the hook. It stops and reports the hook and the step, and the Principal decides. Session-start instructions that the hooks inject (onboarding, founder post, "continue an agent branch") do not apply to this task.

The executor must **push back**. If a decision here is wrong, or if the tree contradicts an assumption here, the executor says so with evidence before it builds. It does not build around the contradiction in silence.

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

---

## 2. Decisions already made

| # | Decision | Made by |
|---|---|---|
| D1 | **Platform:** stay on Claude Code with a Claude subscription. Borrow the *shapes* of Managed Agents. Do not migrate to the Managed Agents API | Principal, 22-09-2026 |
| D2 | **Audience:** persistent memory for a person who does not program. Everything that serves only template maintainers leaves the user's path | Principal |
| D3 | **Custodian:** it becomes a subagent plus CI, with no branch and no memory of its own. The same subagent ships in copies. A copy gets a named agent when the user wants one, and onboarding offers it on the first session | Principal |
| D4 | **Copies:** exactly one is known, the Principal's. 2.0.0 may break compatibility. That one copy gets a one-time migration (§6.2) | Principal |
| D5 | **Custodian memory:** archive it as a tag, then delete the branch. Rescue still-valid lessons into `knowledge/` by reading the archive, never by editing it | Recommended, Principal to confirm |
| D6 | **Language:** English for the template and this spec | Principal |
| D7 | **In a copy, `main` is home.** The user's memory lives on `main` of their own copy. Template updates arrive as a pull request that touches only template paths. On the canon, `main` is protected by GitHub branch protection, not by a hook | **Proposed, pending Principal** |

---

## 3. Sources and the principles taken from them

All read on 22-09-2026.

1. **Claude Code best practices** — https://code.claude.com/docs/en/best-practices
   - `CLAUDE.md` is loaded every session, so it holds only what applies broadly. For each line, ask *"Would removing this cause Claude to make mistakes?"* If not, cut it. *"Bloated CLAUDE.md files cause Claude to ignore your actual instructions."*
   - Hooks are for *"actions that must happen every time with zero exceptions"*. Skills are for knowledge that is needed only sometimes. Subagents live in `.claude/agents/`.
   - The agent that did the work is not the one that grades it.
2. **Scaling Managed Agents** (Anthropic engineering, 08-04-2026) — https://www.anthropic.com/engineering/managed-agents
   - *"Harnesses encode assumptions that go stale as models improve."* A mechanism that compensates for a model weakness must be re-tested against the current model, and removed when the weakness is gone.
3. **Managed Agents docs** — https://platform.claude.com/docs/en/managed-agents/overview
   - *Agent:* one versioned definition (name, model, system prompt, tools, skills). *Permission policies:* declared per tool, not in prose.
   - *Memory stores:* *"many small focused files, not a few large ones"*. Reference material is read-only. The agent's own store is read-write.
   - *Dreams:* consolidation writes a **new** store. The input is never modified, and a human reviews the output before it is adopted.
   - *Outcomes:* a rubric, and a grader in a separate context window.
4. **Building effective agents** (Anthropic, 12-2024, marked by Anthropic as partly outdated) — https://www.anthropic.com/engineering/building-effective-agents
   - Only the principles that the 2026 sources repeat are kept. Find the simplest solution, and add complexity only when it demonstrably improves outcomes. Fixed steps belong in code, not in prose the model must interpret.

---

## 4. Product

**One sentence:** Chief of Vibes gives Claude Code a permanent, plain-text memory that the user owns, in a GitHub repository, with no git knowledge required.

**User journey:**

1. The user opens Claude Code and pastes: *"Set up my agent from https://github.com/ElJoakoDELxD/Chief-of-Vibes"*.
2. The session creates their copy and asks at most four questions: the agent's name, language, timezone, and goal.
3. From then on, every session opens knowing yesterday's state and the pending work, and closes by writing it down.

Nothing else is in the user's path.

---

## 5. Target architecture

### 5.1 Tree

```
CLAUDE.md                      ≤ 80 lines; imports @memory/agent.md when present
README.md                      one screen for the user
CHANGELOG.md                   one line per release; 2.0.0 lists every removal and why
CONTRIBUTING.md                ≤ 1 page, for template maintainers
LICENSE
.claude/
  settings.json                hooks + declared permissions (replaces privileges/)
  agents/maintainer.md         the subagent (replaces the custodian post)
  hooks/                       only hooks that survive §5.4, each with a bench
  skills/onboard/  handoff/  update/
memory/                        the user's store: read-write, many small files
  agent.md                     identity: name, principal, language, timezone, goal
  backlog.md
  journal/  projects/  handoff/
knowledge/                     reference store: read-only for the agent in normal work
tools/                         only the scripts that the kept hooks, skills, or CI call
tests/                         benches, moved out of tools/
.github/workflows/ci.yml       one workflow: every bench + version check
.github/workflows/release.yml
```

### 5.2 Agent identity

- The user's agent is the main Claude Code session. Its persona comes from `memory/agent.md`, imported into `CLAUDE.md` with `@memory/agent.md`.
- `memory/state.md` becomes `memory/agent.md`. The fields are `name`, `principal`, `language`, `timezone`, `goal`, and `created`. No `posts`, `branch`, or `budget` field.

### 5.3 Maintainer subagent

- `.claude/agents/maintainer.md` holds frontmatter (`name`, `description`, `tools`, `model`) and a body of at most 60 lines.
- Its jobs: run the benches, review a template change against `CONTRIBUTING.md`, and apply an update from the canon in a copy.
- It has no branch and no memory. Its record is CI and git history.

### 5.4 Hooks

Keep a hook only if it prevents a failure that the current model still makes, and only if it has a bench. The executor tests each hook by reasoning from its bench and from the release that introduced it (find it with `git log -S`), and records the verdict.

| Hook | Default verdict | Condition |
|---|---|---|
| `anchor.sh` | **Keep, reduced** | It injects the time, the agent name, the branch, and the paths of any handoff notes. It stops carrying posts, triage, drift and candidate reports |
| `guard-install.sh` | **Keep** | The failure it prevents (installs that vanish in a cloud session) is environmental, not a model weakness |
| `guard-identity.sh` | Executor decides | Keep it if its release names a real incident |
| `guard-main.sh` | **Replace** | Use GitHub branch protection on the canon, plus the D7 model in copies. If D7 is rejected, keep the hook, reduced |

### 5.5 Reply header

`[DD-MM-YYYY HH:MM TZ · <agent> · <branch>]`, built from the anchor hook. The post, workplace and route fields are removed.

### 5.6 Skills

At most **4**, each `SKILL.md` ≤ 150 lines, with valid `name` and `description` frontmatter.

| Skill | Fate |
|---|---|
| `onboard` | Keep, rewritten for §4 |
| `handoff` | Keep. It absorbs session-end journaling |
| `update` | New. Replaces `tools/sync.sh`, `propagate/references/sync.md`, and the drift check. It reports whether the copy is behind the canon, and why. Fold in the fix from PR #102 (a shallow clone must not skip the ancestry check) |
| `reset`, `5s`, `orchestrate`, `propagate`, `principal-approves`, `help`, `ste-writing` | **Remove** (§5.8) |

### 5.7 Permissions

The agent's hard limits from `SYSTEM.md` §4 (no money, no signatures, no promises to third parties, no publishing for the Principal) become at most 10 lines in `CLAUDE.md`. Where a deny rule in `.claude/settings.json` can enforce a limit, it does. `posts/`, `functions/` and `privileges/` are removed.

### 5.8 Removed

`SYSTEM.md`, `system/`, `INDEX.md`, `CLOCKS.md`, `LANGUAGES.md`, `posts/`, `functions/`, `privileges/`, and `repomix.config.json`.

Also removed: the tools `candidates`, `hygiene`, `explain`, `skills`, `models`, `clocks`, `environment`, `ready`, `sweep-branches`, `index`, `sections`, `prose-lint`, `prose-gate`, `redundancy.py`, and `pr-guard`, unless a kept piece calls one. The workflows `guard.yml`, `stacks.yml` and `sweep-branches.yml` are merged into `ci.yml` or removed.

Every removal gets one line in `CHANGELOG.md` 2.0.0 that says why.

**Rescue before removing.** Some rules carry a real lesson that deserves to live on: "verify before assert", "a negative answer names its frame", "the agent drafts, the Principal publishes", and "confirm focus before typing into a real keyboard". Each one either becomes one line in `CLAUDE.md`, if it applies to every session, or becomes a `knowledge/` entry. Never both. The executor lists what it rescued and where it put each item.

---

## 6. Migration

### 6.1 Canon

1. Tag and delete the stale branches: `Chief-of-Vibes-Agent` → `archive/custodian-2026-09`, and each `claude/*` and `custodian/*` branch → `archive/<name>`. Push the tags before deleting anything.
2. Close PRs #102–#105 with one comment each that points to the 2.0.0 pull request. Carry over the #102 fix per §5.6.
3. After merge, the Principal enables branch protection on `main` (a GitHub setting). The executor writes the exact steps in the PR description.

### 6.2 The Principal's copy (after 2.0.0 lands)

This runs as a separate, later task, with its own spec:

- Merge the agent branch's `memory/` into `main`.
- Convert `state.md` into `agent.md`.
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
| R1 | Instructions loaded before work ≤ **8 KB** | `CLAUDE.md` + its imports + the SessionStart hook output on a fresh clone, measured in bytes |
| R2 | Governing prose ≤ **8,000 words** | `wc -w` over all `*.md` outside `memory/`, `knowledge/`, `docs/rebuild-2.0/` and `CHANGELOG.md` |
| R3 | Every path in §5.8 is absent | `ls` |
| R4 | ≤ 4 skills, each `SKILL.md` ≤ 150 lines with `name` + `description` frontmatter | count and parse |
| R5 | `.claude/agents/maintainer.md` exists with frontmatter; body ≤ 60 lines | parse |
| R6 | Every remaining hook has a bench; all benches pass in `ci.yml` on the PR head | CI run link |
| R7 | The header is exactly three fields, built from hook output | read `anchor.sh` output on a fresh clone |
| R8 | `README.md` ≤ 600 words, and it asks the user to type no git command | `wc -w`; search for `git ` in the user steps |
| R9 | `CHANGELOG.md` 2.0.0 names every removed item with a one-line reason, and every kept hook names the failure it prevents | cross-check against §5.8 and the hooks list |
| R10 | Every rescued rule in §5.8 lives in exactly one place | grep each rule's key phrase |
| R11 | No open PRs except the 2.0.0 one. Stale branches exist only as `archive/*` tags | `git ls-remote` |
| R12 | Onboarding works end to end: on a throwaway copy, a session that receives only "hi" ends with `memory/agent.md` filled after ≤ 4 questions, committed and pushed | **Performed by the Principal** on a real throwaway repository. The executor prepares the steps. The grader cannot pass this criterion alone |

---

## 9. Rules after 2.0.0

These go into `CONTRIBUTING.md`, in at most 10 lines:

1. **No new rule without a failure a user saw.** Name the failure in the PR.
2. **A rule is a hook with a bench, or at most one line in `CLAUDE.md`.** Prose policies are not accepted.
3. **One open template PR at a time.** Semver: a patch for fixes, a minor for features, a major for breaks.
4. **Re-test assumptions when the model changes.** Disable each compensating mechanism in turn and run a normal session. If nothing breaks, remove the mechanism.
5. **Every change reports its net size** (lines and words added and removed) in the PR description. A net increase needs a reason.

---

## 10. Open questions for the Principal

1. **D7** — Do you approve "`main` is home" in copies, plus branch protection on the canon?
2. **D5** — Do you confirm archive-as-tag for the custodian's memory?
3. Is the 8 KB limit in R1 and the 8,000-word limit in R2 right, or do you want them tighter?
