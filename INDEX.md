# INDEX

Where a rule is stored, and what this repository can do. `tools/index.sh` generates
this file from the tree. Do not edit it: CI regenerates it and fails when it is stale.

Specification version: **1.62.0**

## The specification

`SYSTEM.md` is the core, read every session. `system/` holds the leaves, read when the
work reaches them. Each section is one address.

| Section | Holds | File |
|---|---|---|
| [§1](system/1-purpose.md#1-purpose) | Purpose | `system/1-purpose.md` |
| [§2](SYSTEM.md#2-roles) | Roles | `SYSTEM.md` |
| [§3](SYSTEM.md#3-operating-rules) | Operating rules | `SYSTEM.md` |
| [§4](SYSTEM.md#4-limits) | Limits | `SYSTEM.md` |
| [§5](system/5-memory-an-obsidian-vault.md#5-memory-an-obsidian-vault) | Memory — an Obsidian vault | `system/5-memory-an-obsidian-vault.md` |
| [§6](system/6-repositories-and-branches.md#6-repositories-and-branches) | Repositories and branches | `system/6-repositories-and-branches.md` |
| [§7](system/7-projects.md#7-projects) | Projects | `system/7-projects.md` |
| [§8](system/8-extending.md#8-extending) | Extending | `system/8-extending.md` |
| [§9](SYSTEM.md#9-header-and-session) | Header and session | `SYSTEM.md` |

### The rules of §3, by name. There are 19.

- Act, do not queue.
- A negative answer names its frame.
- Verify before assert.
- Done is earned by verification.
- Decide before you build.
- A subagent's brief is a file.
- Search before propose.
- A suggestion arrives with its address.
- Ask what a convenience stops looking at.
- Never fabricate a reading.
- Gauge the effort, and try cheap first.
- A named cost is not a solved one.
- Write in the controlled language, by default.
- Ingest, do not guess.
- Write it down, in the folder that fits.
- Prose stays out of the command channel.
- The Principal's voice is the Principal's.
- The Principal never looks for what they must read.
- Involve and teach.

## Capabilities

Read from `.claude/skills/`, the same source `tools/skills.sh` reads.

| Skill | Summary | Leaves |
|---|---|---|
| `5s` | Tidy something that has grown — the specification, the repository, or the agent memory — against a budget you declare first. | documents, memory, tree |
| `handoff` | Write the handoff note that lets a fresh chat pick up a thread mid-stride, then commit and push it. | — |
| `help` | Show everything this agent can do — what you can ask for, and what runs on its own. | — |
| `onboard` | Create your agent: name it, pick its language and timezone, set its goal, and give it a branch and a memory. | — |
| `orchestrate` | Split a task into planning, doing and judging, give each to a model that fits, and let the judge read the plan instead of the worker. | — |
| `principal-approves` | Land an approved change everywhere it belongs — one approval, not one per hop. | — |
| `propagate` | Notice when something learned here would help everyone, and turn it into a proposal to the shared template — or decide it should not. | propose, review, sync |
| `reset` | Empty a full chat window without losing the thread: distil what only the conversation knows into memory, push it, then hand the window back clean. | — |
| `ste-writing` | The controlled language this system writes in by default, and the linter that scores it. | — |

## Machinery

| Tool | What it does |
|---|---|
| `tools/candidates.sh` | Reports findings the agent kept instead of sending upstream. |
| `tools/clocks.sh` | Reports when this platform's clock is not yet in CLOCKS.md, the reach record |
| `tools/environment.sh` | Reports the session's environment: what it can reach, what it keeps, and what |
| `tools/hygiene.sh` | Reports three ways the agent's memory goes out of sync. The first two returned |
| `tools/index.sh` | Generates INDEX.md: where every rule is stored, and what this repository can do. |
| `tools/now.sh` | Prints the current time as "DD-MM-YYYY HH:MM ±TZ" in the agent's timezone. |
| `tools/pr-guard.sh` | The two rejections a pull request bound for main has to pass: it touches only |
| `tools/prose-gate.sh` | Scores every piece of published prose against the gate in SYSTEM.md section 7. |
| `tools/prose-lint.sh` | Scores prose against the writing system in .claude/skills/ste-writing/ |
| `tools/ready.sh` | Answers one question before a change is proposed to the canon: can this |
| `tools/redundancy.py` | Lists near-identical sentence pairs across the parts of one or more documents. |
| `tools/sections.sh` | Checks that the specification's map and its tree agree. |
| `tools/skills.sh` | Prints what this agent can do, derived from the skills themselves. |
| `tools/sync.sh` | Brings the template from `main` into the current agent branch by merging it. |
| `tools/test-anchor.sh` | Bench for the resumption half of .claude/hooks/anchor.sh. It pins what must |
| `tools/test-candidates.sh` | Bench for tools/candidates.sh. It pins what must be reported and what must be |
| `tools/test-clocks.sh` | Bench for tools/clocks.sh, the sensor behind CLOCKS.md. It pins both |
| `tools/test-environment.sh` | Bench for tools/environment.sh. It pins the two things the report must never |
| `tools/test-guard-install.sh` | Test bench for .claude/hooks/guard-install.sh. |
| `tools/test-guard-main.sh` | Test bench for .claude/hooks/guard-main.sh. |
| `tools/test-hygiene.sh` | Bench for tools/hygiene.sh. It pins both directions: what must be reported, |
| `tools/test-index.sh` | Bench for tools/index.sh. It pins that the index is generated from the tree and |
| `tools/test-now.sh` | Bench for tools/now.sh. This is the only rung-1 guarantee in the system with a |
| `tools/test-pr-guard.sh` | Bench for tools/pr-guard.sh, the check that decides what reaches main. It had |
| `tools/test-prose-gate.sh` | Bench for tools/prose-gate.sh. It pins that the check reports and never blocks, |
| `tools/test-ready.sh` | Bench for tools/ready.sh. The probe exists to stop a session editing the |
| `tools/test-sections.sh` | Bench for tools/sections.sh. It pins each way the map and the tree can |
| `tools/test-skills.sh` | Bench for tools/skills.sh. It pins the grouping against the two fields the |
| `tools/test-sync.sh` | Test bench for tools/sync.sh. |
