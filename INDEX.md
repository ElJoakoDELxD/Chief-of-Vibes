# INDEX

Where a rule is stored, and what this repository can do. `tools/index.sh` generates
this file from the tree. Do not edit it: CI regenerates it and fails when it is stale.

Specification version: **1.42.0**

## The specification

`SYSTEM.md` holds the rules. Each section is one address.

| Section | Holds |
|---|---|
| [§1](SYSTEM.md#1-purpose) | Purpose |
| [§2](SYSTEM.md#2-roles) | Roles |
| [§3](SYSTEM.md#3-operating-rules) | Operating rules |
| [§4](SYSTEM.md#4-limits) | Limits |
| [§5](SYSTEM.md#5-memory-an-obsidian-vault) | Memory — an Obsidian vault |
| [§6](SYSTEM.md#6-repositories-and-branches) | Repositories and branches |
| [§7](SYSTEM.md#7-projects) | Projects |
| [§8](SYSTEM.md#8-extending) | Extending |
| [§9](SYSTEM.md#9-header-and-session) | Header and session |

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
| `principal-approves` | Land an approved change everywhere it belongs — one approval, not one per hop. | — |
| `propagate` | Notice when something learned here would help everyone, and turn it into a proposal to the shared template — or decide it should not. | propose, review, sync |
| `reset` | Empty a full chat window without losing the thread: distil what only the conversation knows into memory, push it, then hand the window back clean. | — |
| `ste-writing` | The controlled language this system writes in by default, and the linter that scores it. | — |

## Machinery

| Tool | What it does |
|---|---|
| `tools/candidates.sh` | Reports findings the agent kept instead of sending upstream. |
| `tools/index.sh` | Generates INDEX.md: where every rule is stored, and what this repository can do. |
| `tools/now.sh` | Prints the current time as "DD-MM-YYYY HH:MM ±TZ" in the agent's timezone. |
| `tools/prose-gate.sh` | Scores every piece of published prose against the gate in SYSTEM.md section 7. |
| `tools/prose-lint.sh` | Scores prose against the writing system in .claude/skills/ste-writing/ |
| `tools/skills.sh` | Prints what this agent can do, derived from the skills themselves. |
| `tools/sync.sh` | Brings the template from `main` into the current agent branch by merging it. |
| `tools/test-anchor.sh` | Bench for the resumption half of .claude/hooks/anchor.sh. It pins what must |
| `tools/test-candidates.sh` | Bench for tools/candidates.sh. It pins what must be reported and what must be |
| `tools/test-guard-install.sh` | Test bench for .claude/hooks/guard-install.sh. |
| `tools/test-guard-main.sh` | Test bench for .claude/hooks/guard-main.sh. |
| `tools/test-index.sh` | Bench for tools/index.sh. It pins that the index is generated from the tree and |
| `tools/test-prose-gate.sh` | Bench for tools/prose-gate.sh. It pins that the check reports and never blocks, |
| `tools/test-skills.sh` | Bench for tools/skills.sh. It pins the grouping against the two fields the |
| `tools/test-sync.sh` | Test bench for tools/sync.sh. |
