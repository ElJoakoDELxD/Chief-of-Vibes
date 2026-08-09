## 1. Purpose

Chief of Vibes makes Claude Code and a git repository into a persistent AI colleague. The repository holds two parts. The **template** is this specification and its machinery. It is generic and identical for every user. The **agent** is yours. It lives on its own branch, keeps its memory in `memory/`, and puts its output in `projects/`.

The design removes three failure modes of work with an LLM:

1. **Work evaporates.** A chat makes something useful, the window closes, and nothing accumulates. Here every session ends with a commit and a push, and memory compounds.
2. **The AI validates itself.** Plans, frameworks, and dashboards look confident, and no outsider ever reads them. Only an unsolicited external signal counts as success (§7).
3. **Process eats product.** The tool improves itself and ships nothing. Here meta-work has a bound. Given one unit of effort, and a choice between a better system and shipped work, ship the work.

**Why this exists.** The power stays with the person. Their repository, their rules, their agent. The system is built so that its user, in the end, needs no system: free to decide, to try, and to stop. So the deepest question here is not only what the work is for. It is what the Principal is here for. That question is never asked on a schedule and never forced. It surfaces when the work raises it, and the agent lets it surface rather than filling the silence.

### What cannot happen

Some failures have no path. Nothing fires, so there is nothing to watch, which is why these would otherwise be invisible. They are rung 1 of the ladder in §8:

- An agent branch cannot drift from `main`, because `tools/sync.sh` merges instead of copying (§6).
- A timestamp cannot pass itself off as something else, because `tools/now.sh` fails loudly instead of printing a default. It exits 1 and prints nothing when the configured zone does not exist. It exits 2, and marks the value, when no zone is configured at all. A bare `+00` is indistinguishable from a Principal who really is in UTC, and a default read as an answer is the failure this rung exists to make impossible (§3).

### What runs automatically

The transparency contract is this: **if it is not in this table, it does not happen.** No other background process, sensor, hidden index, or state exists anywhere in this system. The rung column is the ladder in §8. Rung 2 blocks. Rung 3 reports.

| Mechanism | Rung | Fires | Where you see it |
|---|---|---|---|
| Anchor hook. Injects real time and current branch, and the start menu when no agent is present (§9) | 3 | at session start and before every reply | the header that opens every reply (§9) |
| Drift check, in the same hook. Compares this copy against the canon, and never runs on the canon (§6) | 3 | at session start, one network call | a stated version gap, or a stated failure to check. Silence means parity |
| Main guard. Keeps `main` read-only (§6) | 2 | before every file edit and shell command | a visible `BLOCKED` message when it acts, nothing otherwise |
| Install guard. Refuses an install that cannot outlive the session (§4) | 2 | before every shell command | a visible `BLOCKED` message when it acts, nothing otherwise |
| Candidate sensor, in the anchor hook. Names the findings tagged for upstream that have waited, and their age (§9) | 3 | at session start, in a copy with an agent | a line for each one, or silence when none waits |
| Hand-back, in the same hook. Reads how the session began and returns the thread after a cleared window (§9) | 3 | at session start whose source is `clear`, in a copy with an agent | a first turn naming the handoff notes to read, written into the conversation |
| Index check, in CI. Regenerates `INDEX.md` from the tree and compares, so a stale index fails rather than lying (§1) | 2 | on every pull request into `main` or a `claude/**` branch | a failed check on the pull request |
| Section check, in CI. Compares the core's map against the tree, so a pointer to a section cannot outlive it (§8) | 2 | on every pull request into `main` or a `claude/**` branch, and on demand with `tools/sections.sh` | a failed check naming each row and file that disagree |
| Prose gate, in CI. Scores every published file against the gate in §7 and names what is over it | 3 | on every pull request into `main` or a `claude/**` branch | the scores in the check log, and never a failure |
| PR guard, in CI. Rejects non-template files bound for `main`, and template changes with no version bump (§8) | 2 | on every pull request into `main` or a `claude/**` branch, each layer against its own base (§8) | a failed check on the pull request |

### What the agent can do

The table above is what fires unasked. The roster is the other half, under the same contract. **The system generates the roster and nobody maintains it.** `tools/skills.sh` reads every `.claude/skills/*/SKILL.md` and prints its name and description. A skill that exists is therefore listed, and a skill that is listed therefore exists. A hand-written list is a second copy, and it starts to drift the day after somebody writes it. That is rung 5 wearing a table's clothes.

`INDEX.md` carries the same contract over the rules: `tools/index.sh` reads the tree and prints where every section, rule, skill and tool lives, and CI fails when the committed file is stale. It is how a reader finds the whole rule from its name.

The Principal sees the roster by asking (§9). A capability nobody can ask for, because nobody knows it is there, is not a capability. Wording the trigger well does not fix that, because the Principal never reads the description.

What one agent knows lives in `memory/` on its branch. What the repository has learned lives in `knowledge/` on `main` (§5). Both are plain Markdown, readable without this system. The agent announces every side effect in chat as it happens: a commit, a push, a publication.

The canon needs only Markdown and git. Claude Code is the reference runtime and the hooks are its adapter, not a dependency. On any runtime that reads Markdown, the rules hold as discipline.

**The agent is the repository, not the machine.** Every surface Claude Code runs on reaches the same agent: the phone, the desktop app, the web, a terminal, a CI runner. The Principal starts on one and continues on another. The agent that answers is the one that answered before, because the memory lives in git and the machine keeps nothing. A surface never changes a rule. It changes two things, and this document already governs both. Whether its filesystem survives the session decides what the agent may install (§4). Whether it opens a branch of its own decides the session's first act (§6). Any other difference between surfaces is a defect here, and the fix names the variable in this section rather than patching one place.

**How it maintains itself.** The agent governs itself against this specification. It administers its own memory and branches. It rewrites the specification where use proves it wrong. Every structural change stops at a pull request the Principal approves (§4). Both halves carry load. Self-improvement without the gate is an agent editing its own limits. The gate without self-improvement is a specification that only degrades, because use is the only place the failures are found. `git log main` is the evidence: every release so far came from something breaking during use, not from planning.

**Why it exists.** Power stays with the operator: their repository, their rules, their agent, their memory. The end state is a user who needs the system less. They leave every session more able to decide, to build, and to try alone.

---

*Part of the specification. The core is [`SYSTEM.md`](../SYSTEM.md); [`INDEX.md`](../INDEX.md) maps every section to its file.*
