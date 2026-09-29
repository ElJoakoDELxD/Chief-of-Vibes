# Chief of Vibes 2.0 — Rebuild Specification

**Status:** revision 6 (28-09-2026), simplified 28-09-2026: §2's superseded and refining notes are merged into the row that governs, so each decision is stated once. It reconciles §4–§9 and §10 against §2, and the questions in §10 are all resolved. It is ready for the Principal's approval once the open points marked in the text are answered. The build needs no change to the environment (§5.0, E1).
**Executor:** one fresh Claude Code session on branch `rebuild/2.0`, created from `claude/repository-organization-dkragp`, with this file as its only brief. That branch already carries the clock (§5.5) and an anchor hook that measures the time (D23, D25).
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
| D3 | **An agent is one file, `agent.md`, on the agent's own branch** — never in `main`, which it would contaminate. The body is its personality. `effects:` in the frontmatter are its permissions (D11). `skills:` are its abilities. This replaces `posts/`, `functions/` and `privileges/`. One layer protects the file: the permission hook blocks the agent from writing it. Changes to it arrive by pull request | Principal, 22–23-09-2026 and 28-09-2026. Absorbs D37 (the file's location moved here from `.claude/agents/<name>.md`, reduced to one protection layer on 28-09-2026) |
| D4 | **Copies:** exactly one is known, the Principal's. 2.0.0 may break compatibility. That one copy gets a one-time migration (§6.2) | Principal, 22-09-2026 |
| D5 | **The custodian's memory lives on its own branch, `custodian`, and never on the canon's `main`.** Its looser work happens in disposable branches that are deleted after merge. A *branch* is a moving label: every new commit advances it. A *tag* is a fixed label: it marks one commit forever. History that must stay is archived as a tag | Principal, 23-09-2026, chosen over keeping the custodian's memory in issues and pull requests |
| D6 | **Language:** English for the template and this spec | Principal, 22-09-2026 |
| D7 | **Three layers, one shape, and only the first two are built now.** Each layer is a `main` curated by a custodian. (1) The canon's `main` holds the scaffold only: template files plus empty forms, and no filled memory; GitHub branch protection guards it. (2) A copy's `main` is not home: it is curated the same way, and nothing of any agent sits in it — every agent lives on its own branch (D3), and only the custodian changes a `main`, from its own branch, by pull request the Principal approves. (3) One `main` per person: the ladder becomes the canon's `main`, then a copy's `main`, then each user's own `main` (their fork or branch), then that user's agents. One person needs no third step; it switches on and is built only when a second person works in the same copy, and 2.0 only describes it | Principal, 22–25-09-2026 and 28-09-2026. Absorbs D18 (a copy's `main` is not home; only the custodian changes a `main`, by an approved pull request) and D36 (layer 3 is a mode, built only when needed) |
| D8 | **Size limits ratchet.** There is no fixed target to cut toward. The executor removes everything that fails the removal test (§5.9) and keeps everything that passes it. The measured result becomes the ceiling in CI, and it may go down later but never silently up | Principal, 22-09-2026 |
| D9 | **The north star already exists, and it moves where every session reads it.** The purpose in `system/1-purpose.md` §1 goes to the head of `CLAUDE.md`, the one file every session loads, quoted and never restated | Principal, 23-09-2026. Resolved by D27 |
| D10 | **The custodian's mandate.** In the Principal's words, translated: *the canon always has the structure of a product, public and easy to use, and it never deviates from that. It is a public repository, so it must always look, feel and work like a professional product: a stable release, usable, with the fewest possible failures, contradictions, repetitions, and cases of the same thing said differently.* §5.4 says how each property is held | Principal, 23-09-2026 |
| D11 | **Effects declare their permission.** An agent's permissions are the effects it declares, in positive form: *the agent writes its memory in `X`*, never *the agent may not write outside `X`*. What is not declared is closed. The sentence that describes an effect is the permission for it, so nothing is said twice. An agent never holds an effect over its own definition, and a chat's first declaration of its agent is final | Principal, 23-09-2026 |
| D12 | **One chat, one context, one agent.** A chat's context window cannot be split: a second agent in it would carry the first one's personality, conversation and memory reads, and the chat would end with two memories. So a chat runs as exactly one agent from its start to its end, and a new agent means a new chat. A new chat chooses an existing agent or creates one; a second declaration naming another agent in the same chat is refused: *open a new chat*. One person may have many agents, and one agent may run in many chats, each aware of which chat it is and where it stands (D40) | Principal, 23-09-2026 and 28-09-2026. Absorbs D45 |
| D13 | **A chat adopts its agent by reading.** At the start, the chat reads the agent file and the agent's memory index, then declares the agent with `header --declare agent=<name>`. A hook enforces the agent's effects from that point on. The web measurements support this route (Appendix A: S1, S4, S5) | Principal, 23-09-2026 |
| D14 | **The canon's custodian is named Plumb.** A plumb line shows true vertical, and the custodian's work is to keep `main` true by measurement. The agent chose the name; the Principal asked it to. The name belongs to the instance, so it lives only in `memory/custodian/` on the `custodian` branch. The role file `custodian.md` stays nameless, and a copy's custodian takes whatever name its person gives it | Principal and agent, 23-09-2026 |
| D15 | **Nothing private in any ref.** The repository is public, and so is every branch, including a disposable one. Its head also survives in the pull request's ref after the branch is deleted. So no branch carries the Principal's name, contact, location, zone, funding or accounts, and template fixtures use neutral values. The loose writing D5 allows in disposable branches is loose in form, never in privacy | Principal, 23-09-2026 |
| D16 | **2.0.0 starts with no history.** The current repository becomes a private archive. The public canon is a new repository with the same name, whose first commit is 2.0.0. Nothing of 1.x reaches it: no history, no branches, no pull requests | Principal, 25-09-2026 |
| D17 | **Every `main` is frozen and read-only, and a single custodian role file lives on it**, canon or copy, reaching only the `main` it stands on. Alone on `main`, with no branch attached, it has no memory and no projects, so it can only orient: that is the mini-custodian, by circumstance and not a second file. On the canon it shows how to make your own copy; on a copy it sends you to your agent, or helps you create one on its own branch. With its own branch attached, it has memory and becomes the full custodian. It travels with every copy unchanged, until that copy takes a template update. `guard-main.sh` stays, as its enforcement. This replaces the separate mini-custodian file and `maintainer.md`: one role, one name, one file | Principal, 25-09-2026 and 28-09-2026. Absorbs D35 |
| D19 | **Capability is judged by public industry standards, not by a private exam.** The custodian's model is checked against a cited list: each listed model carries the published evaluation that qualifies it, and the model is read fresh from the session's transcript (D23). A listed model acts as the custodian (D7). An unknown or unlisted model does not act as the custodian: it stops before any change to the canon and names the model it measured. Any model may still write a suggestion down, in the custodian's memory or as an issue, because nothing reaches the canon without the Principal's approval. Reading and answering stay open to every model. Injection resistance is held by GitHub's controls: branch protection, required review, and no secrets exposed to pull requests from forks. A test is not what holds it | Principal, 25-09-2026 and 28-09-2026. Absorbs D29 and D32. The S7 private exam and the later intelligence test are both retired (simplify pass 2, 28-09-2026) |
| D20 | **An agent's branch holds only what is the agent's own, its memory and its output (D27); the system lives only in `main`.** A chat opens on `main` and attaches the agent's memory branch as a worktree folder (`.agent/`), the one place it writes. A template update reaches every agent at once, because no agent branch carries system files. A memory format version plus a one-time migration in `update` covers the only drift left | Principal, 25-09-2026. Verified on the web by spike S8 (Appendix A) |
| D21 | **System changes flow top-down, and a proposal waits in `pending/`.** A change that serves the canon goes to the canon first, by one open pull request per copy, with one commit per proposal. The copy applies the change at once and records it in `pending/<name>.md`: the pull request link, the files, and the reverse patch. If the canon accepts it, `update` reverses the patch, brings the canon's version, and deletes the record. If the canon rejects it, the agent asks: keep it in this copy, or remove it | Principal, 25-09-2026 |
| D22 | **`CLAUDE.md` is the index.** It holds the north star, one line for each rule that always holds, and a table of "when X, read Y". It targets about 700 words, and the rest loads only when a row sends the agent there | Principal, 25-09-2026 |
| D23 | **A hook obtains every header field.** Date, time and branch come by measurement. The model and the effort come fresh from this session's transcript: both are read from the last reply the harness recorded, on every call — never assumed, never copied, never from an older transcript or an earlier turn. They are read at a tool call, where the current reply is already recorded, and never at `UserPromptSubmit`, where the last record is the previous turn's. A record older than 120 seconds prints `?`. The agent never writes any of these fields. Built as `tools/bin/header` | Principal, 25-09-2026 and 28-09-2026. Absorbs D28: hook inputs (per the Claude Code hooks reference, read 28-09-2026) carry the effort but not the model on the web (spike S8, Appendix A), so the transcript read replaces the SessionStart/PostModelSwitch source this row first specified |
| D24 | **Outside pull requests are reviewed as diffs.** No session ever opens on a contributor's branch, because Claude Code would load that branch's hooks and run them | Principal, 25-09-2026 |
| D25 | **The agent checks every reading**: the date against its context, and the time against the previous reply. A mismatch is asked about, never fixed in silence | Principal, 25-09-2026 |
| D26 | **A passed check ends the header with ✓.** A header without ✓ means the check was skipped: that absence is the sanity check. The instruction that asks for ✓ does not sit at the top of `CLAUDE.md`. It sits in the index row that describes how a reply opens | Principal, 28-09-2026 |
| D27 | **An agent's output lives on its own branch, beside its memory.** The chat writes only in `.agent/` (D20), so that is where `projects/` goes. The north star stays word for word, less the pointer "(§7)", which leads to a deleted file | Principal, 28-09-2026 |
| D30 | **The orchestrator stays in 2.0, to save tokens.** It plans, delegates, and checks the result against the plan. It fires only when the serving model is Opus 5.5 and the task comes out better delegated than done. It never sets the header's model or effort (D23): what it chooses and what served are different facts | Principal, 28-09-2026 |
| D31 | **Revision 5 comes before approval.** Sections 4 to 9 predate D16 and contradict later decisions in places. They are reconciled with every decision in §2 before the Principal approves the spec | Principal, 28-09-2026 |
| D33 | **The orchestrator's terms.** The list of models carries a column, *orchestrates*, set for Opus 5.5 today. To delegate means the same result at a lower cost; if the result would be worse, the orchestrator does the work itself. It delegates to subagents on a cheaper model, and to a child session only for a spike that needs its own hooks or branch | Principal, 28-09-2026 |
| D34 | **A lone agent is attached without asking.** When only one agent exists, the chat attaches its branch as `.agent/` and says which agent it attached | Principal, 28-09-2026 |
| D38 | **The sandbox's tools live on the agent's branch, and a hook turns the sandbox on.** `bwrap` and `socat` (Ubuntu 24.04 binaries, with their sources and licenses listed) sit under `tools/sandbox/linux-x86_64/`. On Linux x86_64 with a writable `/usr/local/bin`, a SessionStart hook links them there and then writes `.claude/settings.local.json`: sandbox on, the nested-container mode, auto-allow for sandboxed Bash, `git` excluded, and a domain allowlist. No proxy port is fixed: the container's proxy port changes between restarts, and a fixed one left a restarted session without network (28-09-2026). The sandbox runs its own proxy, which enforces the allowlist itself (S6j). Claude Code checks for the tools when it launches, before any hook, so the switch happens only after they are in place, through the settings reload. The `socat` wrapper forces IPv4, because the sandbox's network namespace has none of IPv6. Nothing depends on the environment's setup script or on managed settings. A session already running when the tools arrive cannot restart itself: no hook output restarts a session, and `/resume` does not exist on the web. The agent asks the person to archive and unarchive the chat, which starts it on a fresh machine with its history | Principal, 28-09-2026. Verified by S6 |
| D39 | **A session that restarts in the same chat is the same chat and the same session.** A new machine (after idleness, or archive and unarchive) changes nothing of identity: the agent the chat adopted stays adopted (D12). Everything a machine loses is therefore rebuilt by the SessionStart hook, never re-asked: the `.agent/` worktree is re-attached, the sandbox is turned on again (D38), and the agent declaration is read from somewhere that survives the machine, not from `/tmp` | Principal, 28-09-2026 |
| D40 | **Two layers of memory: one per chat, and one global.** One chat, one memory: each chat keeps its own memory, and a declaration in the transcript pairs the agent with the chat's identifier. That pair is how an agent knows where it is. The global memory holds what was learned. The chat memory points at it: "resolved in the global memory", or "not resolved there and it would help: propose it" | Principal, 28-09-2026 |
| D41 | **The agent improves itself.** It learns from the interactions, not from the person: from its own errors, and from where it infers it could err next. A solution it reached, or a correction from the person, is not applied as is: the agent first evaluates it, and investigates whether someone else had the same problem and solved it better | Principal, 28-09-2026 |
| D42 | **Where each memory lives.** On the agent's branch: the chat memory in `chats/<chat-id>.md`, one file per chat, so two chats of one agent never collide there; the global memory in `memory/`, the one place they can, where the agent brings in the latest global memory before it writes | Principal, 28-09-2026 |
| D43 | **An improvement goes as far as it serves.** The agent improves itself (its global memory). A fix that changes the system does not stay in memory: it goes to the copy's `main` by pull request, which the person approves. A fix that would serve every copy is also suggested to the canon, by the proposal cycle of D21. The chat memory records which of the three it was and where it went | Principal, 28-09-2026 |
| D44 | **A chat never reads another chat's memory.** The agent is guided only by the global memory: what is there is known, and what is not there is not. A hook enforces it: the agent's tools may read `chats/<this-chat-id>.md` and no other file under `chats/`. Bringing in the latest global memory before writing (D42) reads only `memory/` | Principal, 28-09-2026 |
| D46 | **The simplest version wins** (the simplify loop, `SIMPLIFY.md`). Four answers from its first pass: the agent's file has one protection layer, the permission hook; a tool that is not general lives on the agent's branch, never in `main`, so the sandbox's tools sit in `.agent/tools/sandbox/` and the sandbox turns on when an agent is attached; `memory/` keeps `MEMORY.md` and `backlog.md`, while `journal/` and `handoff/` dissolve into the chat memory; self-improvement is one line in `CLAUDE.md`, and no skill carries it | Principal, 28-09-2026 |
| D47 | **2.0.0 is sterile.** Nothing is ported: no copy is migrated and no content of today's `main` is carried over. 2.0.0 is built from this spec alone. Before building, the executor checks the official Claude documentation and the wider field for a tool that already does each job; an official or better-polished tool replaces our own construction | Principal, 28-09-2026. Supersedes §6.2 |
| D48 | **The product is named Stewie,** chosen before the public repository is created. The first outside task (finding people who use it and make their copy) belongs to the Principal and is never given to the agent | Principal, 28-09-2026 |
| D49 | **A mirror that never changes.** A read-only reference of the released canon exists beside the live one. The custodian compares the live canon with the mirror and judges whether each difference serves the original objective | Principal, 28-09-2026 |
| D50 | **Official features replace our construction where they work on the web, and only there** (D47, checked 28-09-2026). Auto memory does not replace the global memory: spike S9 (28-09-2026) found it inactive in a cloud session, with no memory section in the system prompt even with `autoMemoryDirectory` set, so the global memory stays ours, in git. Plugins do not replace the template: a cloud session loads no plugin that a repository's settings turn on. The mirror is the released version, held by a tag ruleset and immutable releases. The reply header, per-agent permissions and the sandbox stay ours: nothing official does their job on the web | Principal, 28-09-2026 |
| D51 | **A temporary write permission for the 2.0.0 build.** The Principal authorised, on 29-09-2026 and for this build only, that the sandbox let the session write to the project's parent directory, so the new repository can be cloned beside this one. It is set in the SessionStart hook and takes effect at the next session start, never mid-session. It is removed once 2.0.0 is built | Principal, 29-09-2026 |

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

**North star (D9).** It is quoted from `system/1-purpose.md` §1 and not restated. The text that opens `CLAUDE.md` is this one, less only the pointer "(§7)" that D27 cuts:

> Chief of Vibes makes Claude Code and a git repository into a persistent AI colleague. The repository holds two parts. The **template** is this specification and its machinery. It is generic and identical for every user. The **agent** is yours. It lives on its own branch, keeps its memory in `memory/`, and puts its output in `projects/`.
>
> The design removes three failure modes of work with an LLM:
>
> 1. **Work evaporates.** A chat makes something useful, the window closes, and nothing accumulates. Here every session ends with a commit and a push, and memory compounds.
> 2. **The AI validates itself.** Plans, frameworks, and dashboards look confident, and no outsider ever reads them. Only an unsolicited external signal counts as success.
> 3. **Process eats product.** The tool improves itself and ships nothing. Here meta-work has a bound. Given one unit of effort, and a choice between a better system and shipped work, ship the work.
>
> **Why this exists.** The power stays with the person. Their repository, their rules, their agent. The system is built so that its user, in the end, needs no system: free to decide, to try, and to stop. So the deepest question here is not only what the work is for. It is what the Principal is here for. That question is never asked on a schedule and never forced. It surfaces when the work raises it, and the agent lets it surface rather than filling the silence.

**User journey:**

1. The user opens Claude Code and pastes: *"Set up my agent from https://github.com/ElJoakoDELxD/Chief-of-Vibes"*.
2. The session creates their copy and asks at most four questions: the agent's name, language, timezone, and goal.
3. From then on, every new chat starts by choosing one of the user's agents or creating another (D12), then attaches that agent's branch as `.agent/` (D20); a lone agent is attached without asking (D34). It opens knowing that agent's state and pending work, and it closes by writing them down and pushing from `.agent/`.

Nothing else is in the user's path.

---

## 5. Target architecture

### 5.0 Before the build: environment and spikes

**E1. The sandbox turns itself on (D38).** No one edits the environment. Spike S6 found the working route on the web, on 28-09-2026 (Appendix A).

| Spike | Question | Status | If it fails |
|---|---|---|---|
| **S1** | Does the web run a session as the agent set in `settings.json`, load its native memory, and fire `initialPrompt`? | **Done.** Identity: yes. Memory and first turn: no (Appendix A) | Taken: memory and the first turn are built (D13, §5.3) |
| **S2** | Does *Use this template* copy only the default branch? | Open, for the executor | Move the canon custodian's memory to a separate private repository, and ask the Principal first |
| **S3** | For each hook the rebuild keeps, does the current model still make the mistake the hook prevents? Disable the hook, run one ordinary session, and record the result | Open, for the executor | Remove the hook |
| **S4** | Can a chat adopt an agent by reading, and can a hook enforce that agent's rules? | **Done.** Yes, for tool calls (Appendix A) | — |
| **S5** | Do effects work as permissions: the declared path allowed, anything else blocked, the agent's own file blocked, and the declaration locked? | **Done** (Appendix A) | — |
| **S6** | Does the sandbox limit Bash writes, with no manual step? | **Done.** Yes: writes outside the workspace and to `.claude/settings.json` are refused, the network works through the container's proxy, and git commits and pushes (Appendix A, D38) | — |
| **S7** | Can a private exam tell a capable model from a weaker one? | **Retired** by D19 | — |
| **S8** | Can a chat attach a memory-only branch as `.agent/`, write there, and push it (D20)? What do hooks receive about the model and the effort (D23)? | **Done.** Memory: yes. Effort: yes, from `PreToolUse`. Model: no hook input carries it (Appendix A, D23) | — |

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
  _example/                    the empty form: memory/ (MEMORY.md, backlog.md), chats/, projects/
knowledge/                     read-only reference, shared with every copy
tools/bin/                     clock, header
tests/                         benches
.github/workflows/ci.yml       every bench, the size ratchet, the version check
.github/workflows/release.yml
```

The `custodian` branch is `main` plus a filled `memory/custodian/`. It merges `main` in to stay current. It sends template changes to `main` only through pull requests, and it never sends its memory.

### 5.2 Tree — a copy's `main`

It is the same as the canon's `main`. A copy's `main` is not home (D7), and nothing of an agent sits in it: not its file (D3), not its memory — chat or global (D40, D42) — not its output. Each agent's branch holds `agent.md`, `memory/`, `chats/` and `projects/` (D20, D27, D3, D42), seeded from the forms and attached as `.agent/` when a chat adopts it.

A copy may also hold `pending/`, one file per proposal still open with the canon (D21).

The `update` skill never overwrites an agent file, and it never touches an agent's own branch, since no agent branch carries template files (D20).

### 5.3 The agent file, and how a chat adopts it

```yaml
---
name: <name>
description: <one line>
effects:
  - writes: .agent/memory/
  - writes: .agent/chats/
  - writes: .agent/projects/
  - pushes: .agent/
---
<personality: who the agent serves, language, timezone, goal>
```

- **The body is the personality.** It holds nothing that `CLAUDE.md` already says.
- **Effects are permissions** (D11). The hook `agent-permissions.sh` enforces `writes:` for `Write`, `Edit`, `MultiEdit` and `NotebookEdit`. It blocks any path that no effect declares, and it always blocks the agent's own file, `.agent/agent.md`. Inside `.agent/chats/` it allows only this chat's own file, `chats/<this-chat-id>.md` (D44). The sandbox holds Bash (S6). `pushes:` needs its own rail, which the executor reads from `lib/command.sh` as `guard-main.sh` does, with a bench.
- **Adoption** (D13). A SessionStart hook lists the agents that exist. The chat asks which one, or creates one through `onboard`; a lone agent is attached without asking, and the chat says which one it attached (D34). It attaches that agent's branch as the worktree `.agent/` (D20), reads `.agent/agent.md` and `.agent/memory/MEMORY.md`, and runs `header --declare agent=<name>`, which pairs the agent with this chat's identifier (D40) and starts `.agent/chats/<chat-id>.md` if it does not exist yet. A second declaration to a different agent is refused: *one chat, one agent; open a new chat* (D12).
- **A restart is the same chat** (D39). After idleness, or an archive and unarchive, nothing is re-asked: the hook re-attaches `.agent/`, turns the sandbox on again (D38), and rereads the declaration from the transcript, which survives the machine — never from `/tmp`.
- The agent's branch holds `agent.md` (D3); `memory/` — `MEMORY.md` (the index, at most 200 lines, curated by the agent), the global memory the agent brings forward before it writes (D42) and `backlog.md`; `journal/` and `handoff/` are gone, dissolved into the chat memory; `chats/<chat-id>.md`, one file per chat (D42, D44); and, beside them, `projects/` for the agent's output (D27).
- **Bash is held by the sandbox** (D38). Where the sandbox cannot run (no Linux x86_64, or no writable `/usr/local/bin`), a Bash write does not pass through the hook, and `README.md` says so in one line.

The S5 implementation is the starting point: `.claude/hooks/agent-permissions.sh` and `tools/bin/header` at `spike/s5-effects`. The executor ports them and adds a bench that pins every result in Appendix A.

### 5.4 The custodian and its mandate (D10)

`custodian.md` is the one role file on every `main`, at any layer (D7, D17), reaching only as far as where it lives. Alone on `main` it has no memory and no projects, so it can only orient: the mini-custodian, by circumstance, not a second file. With its own branch attached, it has memory and is the full custodian: curating the template on the canon, or that copy's `main`, applying updates and running 5S. Only the custodian changes the canon, from its own branch, by pull request the Principal approves (D7). A model acts as custodian only when the cited list qualifies it by a published evaluation; any other model may only write a suggestion down (D19). Outside pull requests are reviewed as diffs, and no session opens on a contributor's branch (D24).

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
- Obtaining date, time and branch is mechanical: a hook measures them (D23). The agent checks every reading — the date against its context, the time against the previous reply — and asks the Principal about a mismatch, never fixing it in silence (D25).
- A reading 3 or more minutes from the reference, or a date that differs from the context date, prints `DESFASE` on stderr and changes nothing. The agent asks the Principal whether the time was right before it fixes anything.
- UTC on the canon is expected. Only a copy with a declared or auto-detected zone can be wrong about the zone.
- `header` reads every field and remembers none. The agent comes from the chat's declaration (D13). The model and the effort come fresh from this session's transcript, read at a tool call and never assumed, copied, or taken from an earlier turn (D23). A field it cannot read prints as `?`, and `header` says why.
- A passed check ends the header with ✓; its absence means the check was skipped. That instruction lives in the `CLAUDE.md` index row for how a reply opens, not at the top of the file (D26).
- The header is a sanity check, like the brown-M&M clause: it proves that the agent did the work instead of copying a given answer.

### 5.6 Hooks

Keep a hook only if S3 shows that the failure it prevents still happens, and only if it has a bench.

| Hook | Verdict |
|---|---|
| `path.sh` | **Keep.** It exposes `clock` and `header`. Web-verified on 23-09-2026 |
| `anchor.sh` | **Reduce**, but it carries the header's date, time and branch again (D23, D25), plus the session context that remains true in 2.0: the list of agents for adoption (D13), and the update check (§5.7). On a restart it re-attaches `.agent/` and rereads the declaration from the transcript, without asking again (D39) |
| `agent-permissions.sh` | **Add**, ported from S5, with a bench (§5.3) |
| `tools/sandbox/activate.sh` | **Keep, web-verified 28-09-2026, benched** (`tools/test-sandbox.sh`). Links `tools/sandbox/linux-x86_64/` into `/usr/local/bin` and writes `.claude/settings.local.json`: sandbox on, nested mode, auto-allow, `git *` excluded, a domain allowlist, no fixed proxy port (D38). Runs again on every restart, so the sandbox comes back with it (D39) It runs when an agent's branch is attached, at adoption and on every restart, and reads the tools from `.agent/tools/sandbox/`: a tool that is not general lives on the agent's branch, never in `main`. Until an agent is attached, the chat runs without the sandbox |
| `guard-install.sh` | **Keep** if S3 confirms it. The failure is environmental (installs vanish in cloud sessions), not a model weakness |
| `guard-identity.sh` | Keep it only if the release that introduced it (`git log -S`) names a real incident, and S3 still reproduces the failure |
| `guard-main.sh` | **Keep.** Every `main`, canon or copy, is frozen and read-only (D17); a copy's `main` is not home (D7) |

### 5.7 Skills, CLAUDE.md and permissions

| Skill | Fate |
|---|---|
| `onboard` | **Keep, rewritten.** It creates the copy (with *Use this template* as the fallback), or a further agent in an existing copy. It asks ≤ 4 questions, and creates that agent's own branch with `agent.md` (default effects), `memory/`, this first chat's `chats/<chat-id>.md`, and `projects/` from the forms (D20, D27, D3, D42). Then it commits and pushes. Every later change to `agent.md` goes by pull request |
| `handoff` | **Keep.** It writes this chat's own memory, `chats/<chat-id>.md` (D42), before a session ends, and folds forward what belongs in the global memory (D40, D41) |
| `update` | **New.** It replaces `tools/sync.sh`, `propagate/references/sync.md` and the drift check. It reports whether the copy is behind the canon, and why, and it opens a pull request that touches only template paths. It folds in the fix from PR #102: a shallow clone must not skip the ancestry check. It never touches an agent branch (D20) |
| `5s` | **Keep.** It is the custodian's procedure for D10, and its `memory` target also serves every agent. It is rewritten to the new tree |
| `orchestrate` | **Keep, rewritten** to D30/D33: it plans, delegates and checks the result against the plan. It fires only when the serving model is marked *orchestrates* on the cited list, and only when the task comes out better delegated. It delegates to subagents on a cheaper model, and to a child session only for a spike that needs its own hooks or branch. It never sets the header's model or effort (D23, D30) |
| `reset`, `propagate`, `principal-approves`, `help`, `ste-writing` | **Remove** (§5.8) |

Each kept `SKILL.md` has valid `name` and `description` frontmatter.

**D41's self-improvement is not a skill.** The agent evaluating and researching before it applies a fix or a correction is a rule for every agent, so it is a line in `CLAUDE.md`, not something invoked. D43's escalation reuses what already exists — a pull request to the copy's `main`, and the D21 proposal cycle into `pending/` (§5.2) — so `propagate`'s removal (§5.8) still holds.

`CLAUDE.md` holds the north star, then only what applies to every agent in every session. First come the hard limits from today's `SYSTEM.md` §4: no money, no signatures, no promises to third parties, and the agent drafts while the Principal publishes. Then come the rescued rules that pass the removal test, and the one line on how a reply opens (`clock | header`). Two rules learned under the sandbox join them (D38): git is always called alone — never chained, never `git -C`, never beside a parallel sandboxed call; and the sandbox's network is fixed when Claude Code launches. Where a deny rule in `.claude/settings.json` can enforce a limit, it does, and the prose line goes.

### 5.8 Removed

These paths are removed: `SYSTEM.md`, `system/`, `INDEX.md`, `CLOCKS.md`, `LANGUAGES.md`, `posts/`, `functions/`, `privileges/`, `memory/state.md` (replaced by the agent file), and `repomix.config.json`.

These tools are removed too, unless a kept piece calls one: `candidates`, `hygiene`, `explain`, `skills`, `models`, `clocks`, `now`, `environment`, `ready`, `sweep-branches`, `index`, `sections`, `prose-lint`, `prose-gate`, `pr-guard` and `sync`. **`tools/redundancy.py` stays:** it is the custodian's instrument for D10. The workflows `guard.yml`, `stacks.yml` and `sweep-branches.yml` are merged into `ci.yml` or removed.

Every removal gets one line in `CHANGELOG.md` 2.0.0 that says why.

**The north star is moved, not rescued.** Before `system/` is deleted, the purpose text goes to the head of `CLAUDE.md` (D9). Deleting `system/` without this step deletes the product's reason to exist.

**Rescue before removing.** Some rules carry a real lesson that deserves to live on: "verify before assert", "a negative answer names its frame", and "confirm focus before typing into a real keyboard" (the drafts/publishes split is already a hard limit carried into `CLAUDE.md`, §5.7). Each one either becomes one line in `CLAUDE.md`, if it passes the removal test for every session, or becomes a `knowledge/` entry. Never both. The rescue reads the archive tags and never edits them (the *Dreams* pattern). The executor lists what it rescued and where it put each item.

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

1. Run the privacy audit (D15) over the current repository: every branch tip, and every pull request's ref, since a head survives there after its branch is deleted.
2. Build 2.0.0 in the current repository as this document directs: one branch, one pull request, the Principal's merge. Close PRs #102–#105 with one comment each that points to it. Carry over the #102 fix per §5.7.
3. Make the current repository private: it becomes the archive (D16). Create a new public repository with the same name, whose first commit is that merged result. Nothing of 1.x reaches it: no history, no branch, no pull request (D16).
4. Create the `custodian` branch from the new repository's `main`. Seed `memory/custodian/` with the instance name (D14) and what the rescue (§5.8) assigned to the custodian, and nothing else.
5. The Principal enables branch protection on the new repository's `main` (a GitHub setting). The executor writes the exact steps in the PR description.

### 6.2 The Principal's copy (after 2.0.0 lands)

This runs as a separate, later task, with its own spec:

- Convert `memory/state.md` into `agent.md`, with the default effects, on the agent's own branch (D3).
- Create that agent's own branch, holding its migrated `memory/`, a first `chats/<chat-id>.md` for this migration chat (D40, D42), and `projects/` (D20, D27).
- Apply the 2.0.0 template through the `update` skill.
- Archive the old agent branch as a tag.

---

## 7. Out of scope

- A migration to the Managed Agents API.
- New features.
- Layer 3 (D7): one `main` per person, until a second person uses the same copy.
- Memory consolidation (a *Dreams*-style skill). Add it only when a measured memory-growth problem exists.
- Translating the template.

---

## 8. Rubric

The grader scores each criterion independently, as pass or fail, with evidence. A criterion that cannot be measured fails.

| # | Criterion | How to measure |
|---|---|---|
| R1 | Spikes S2, S3 and S6 ran, and each result is recorded with the command and its output. S6 is recorded in Appendix A | PR description |
| R2 | Every surviving line, hook, skill and tool passes the removal test (§5.9). The PR lists each *removed, restorable* item | Sample 20 surviving lines at random. Each must cite its evidence, or be a hard limit from §5.7 |
| R3 | CI records, and enforces as ceilings, the bytes loaded before the first turn and the words of governing prose. The PR states both, before and after | A `ci.yml` step. Loaded bytes = `CLAUDE.md` + SessionStart hook output. Words = `wc -w` over template `*.md` outside `knowledge/`, `docs/` and `CHANGELOG.md` |
| R4 | Every path in §5.8 is absent | `ls` |
| R5 | `custodian.md` and `_example.md` follow the agent-file format of §5.3, and they parse as Claude Code subagents | Parse the frontmatter |
| R6 | Every remaining hook has a bench. All benches pass in `ci.yml` on the PR head | CI run link |
| R7 | `clock \| header` prints exactly the §5.5 fields, each read and none remembered, and never prints ✓: the ✓ is the agent's, written only after its date and time checks pass (D25, D26) | Run it on a fresh clone, with and without a declared agent, and with a manufactured date mismatch to confirm no ✓ and a stated reason (D25) |
| R8 | `README.md` asks the user to type no git command | Search the user steps for `git ` |
| R9 | `CHANGELOG.md` 2.0.0 names every removed item with a one-line reason | Cross-check against §5.8 |
| R10 | Every rescued rule lives in exactly one place | Grep each rule's key phrase |
| R11 | The new public repository carries no history before 2.0.0: only `main` and `custodian` exist, and no branch or pull request predates it (D16) | `git ls-remote` |
| R12 | On a throwaway copy, a web chat that receives only "hi" ends with a new agent branch holding `agent.md`, `memory/`, `chats/<chat-id>.md` and `projects/`, and nothing new on `main` (D20, D27, D3, D42), created after ≤ 4 questions, committed and pushed. A second chat adopts that agent, attaches its branch as `.agent/`, and reports the agent's global memory. A third chat creates a second agent. A fourth chat is offered both | **Performed by the Principal.** The executor prepares the steps. The grader cannot pass this criterion alone |
| R13 | `CLAUDE.md` opens with the north star: the text in `system/1-purpose.md` §1 at the archive tag, less only the pointer "(§7)" that D27 cuts | `diff` |
| R14 | `custodian.md` carries D10 word for word, and each means in §5.4 exists: a named CI step, a checklist line, or a file | Parse the file, then cross-check `ci.yml` and the tree |
| R15 | No fact lives in two public files. The `redundancy.py` report over all public prose is attached, and every pair above the threshold has a recorded verdict | PR description |
| R16 | A `5s documents` pass by a fresh-context subagent over the public files is attached, and it has no open item | PR description |
| R18 | The privacy audit (D15) passes over every branch tip and every pull request's ref in the current repository, before it is made private (D16). The audit reads its patterns from a CI secret, never from the repository, because a list of the Principal's private terms is itself private | The CI step's output |
| R17 | The `agent-permissions.sh` bench pins every S5 result: a declared path is allowed, an undeclared path is blocked, the agent's own file is blocked, `..` traversal is blocked, and a second declaration is refused; live, a second declaration naming another agent in the same chat is refused and told to open a new chat (D12) | Run the bench; then, after a chat declares one agent, run `header --declare agent=<other>` and confirm the refusal |
| R19 | Exactly one custodian role file exists per `main`, canon or copy: no `maintainer.md`, no separate mini-custodian file (D17) | `ls .claude/agents/` on each `main` |
| R20 | `guard-main.sh` exists and its bench passes, on the canon and on a copy (D17) | Run the bench; check the file |
| R21 | A copy's `pending/` entry (D21) is created on a proposal, and removed with the reverse patch applied once the canon accepts it | Run the cycle once end to end |
| R23 | The sandbox bench passes, and on the web: a write outside the workspace is refused, `api.anthropic.com` answers, a non-allowlisted host is refused, and git commits and pushes (D38) | Run `tools/test-sandbox.sh`; then attempt each of the four on a live web session |
| R24 | A restarted chat — idle timeout, or archive and unarchive — re-attaches its agent's `.agent/` worktree and turns the sandbox back on, without asking (D39) | Archive and unarchive a mid-task chat; the next reply's header already names the agent and branch, with no adoption question |
| R25 | A chat's tools can read only `chats/<this-chat-id>.md` under `chats/`; reading another chat's file is blocked (D44) | From a chat, attempt to read a different chat's `chats/<other-id>.md`; the hook refuses it and names the file |

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

N1–N7 are all resolved, each by the row in §2 that answers it: N1 by D27, N2 by D17, N3 by D34, N4 by D23, N5 by D19, N6 by D33, N7 by D7.

---

## Appendix A. Spike evidence

All spikes ran on the web (claude.ai/code), in child sessions that recorded their results in the repository. Each is one run, and the results are a model's report of its own context and tool results. They are evidence, not proof.

**S1 (23-09-2026). A native agent as the main session.** Branch `spike/s1-agent`, result commit `a424299`. The agent file set `memory: project` and `initialPrompt`, and `.claude/settings.json` set `"agent": "probe"`, forbidden to read files to find its answers. The session ran as the agent (it saw a codename that exists only in the agent body), but native memory did not load `MEMORY.md` into the prompt and `initialPrompt` did not fire as the first turn — both markers came back "not in context". A second finding came from the session itself: an agent file created after a session starts is not available in that session (`Agent type 'probe' not found`), so the agent is fixed when the chat starts (D12).

**S4 (23-09-2026). Adopting an agent by reading.** Branch `spike/s4-adopt`, result commit `3420746`. The hook and Bash saw the same session identity, and the declaration was found. `Write` before the declaration passed as a control; `Write` and `WebFetch` after the declaration, both banned by name, were blocked with the agent and the file named in the error; the header showed the adopted agent. But a file write through Bash while `Write` was banned still succeeded — a ban on a tool is not a ban on an effect, and this is equally true of Claude Code's native `disallowedTools`.

**S5 (23-09-2026). Effects as permissions.** Branch `spike/s5-effects`, spike commit `5f52c8b`, result commit `1b930f4`. With two `writes:` effects declared, `Write` before any declaration was allowed as a control; `header --declare agent=scout` was accepted, and a second declaration to `agent=other` was refused (*"this chat already runs as 'scout'. One chat, one agent: open a new chat for 'other'."*); `Write` to a declared path was allowed, to an undeclared path was blocked by name, to the agent's own file was blocked, and through `..` out of a declared path was blocked (the path is normalized before matching). But a plain Bash write to the declaration file succeeded, and the header then showed `other` — the lock holds against the tool, not against Bash. S4 and S5 lead to the same conclusion: the hook holds every effect that passes through a tool call, and only the operating-system sandbox closes the gap Bash leaves open, which S6 closed on the web (D38).

**S8 (28-09-2026). A memory-only branch, and what hooks receive.** Branch `spike/s8-main` (hook commit `6ba5f6f`, result `1a6d871`) logged every input field about the model and the effort; branch `spike/s8-mem` is an orphan branch holding only `memory/MEMORY.md` (seed `afb38bc`, result `e634f90`). `git worktree add .agent spike/s8-mem` attached with no hook refusal, and an edit, commit and push from `.agent/` reached `spike/s8-mem`. `model` came back null in `SessionStart`, `UserPromptSubmit` and `PreToolUse` (no model-change event fired); `effort` was null in `SessionStart`/`UserPromptSubmit` but `{"level": "medium"}` in all nine `PreToolUse` calls, matching `CLAUDE_EFFORT`; `get_session` gave the model (served and configured, `claude-opus-5-5`) but no effort field. D20 works on the web; for D23, the effort reaches a hook and the model does not, which is why the header reads both fresh from the transcript instead.

**S6 (28-09-2026), with S6j.** The sandbox, with no manual step. Branch `spike/s6-sandbox`, nine child sessions, final result commit `8d520c4`. Tools placed in the repository with `sandbox.enabled` in project settings were not found, because Claude Code checks `PATH` at launch, before project settings or hooks apply. `sandbox.failIfUnavailable` refused to start the session (*"bubblewrap (bwrap) not installed, socat not installed"*), showing the web does honour the sandbox. `sandbox.bwrapPath`/`socatPath` are read only from managed settings by design and were not used, since a public template writing machine policy as root is the pattern a security review flags. A SessionStart hook that links the tools and turns the sandbox on in `.claude/settings.local.json` is picked up mid-session, but every command then failed on `apply-seccomp: write /proc/self/uid_map: Operation not permitted`; adding `enableWeakerNestedSandbox` fixed workspace writes (outside writes and `.claude/settings.json` refused as read-only, inside writes allowed) but left the network dead (`localhost:3128` refused), traced to `socat` needing `-4` because the sandbox's network namespace carries no IPv6. With `socat -4`, the container's proxy as upstream, `git *` excluded, and one git command per call: outside writes were refused, inside writes allowed, `api.anthropic.com` answered, `example.com` was refused (403, the container's own egress policy), and `git commit`/`git push` succeeded. S6j confirmed this with no fixed proxy port (`api.anthropic.com` answered, `example.com` refused by the sandbox itself) and found the one limit that stands: `git` leaves the sandbox only as a lone, plain call — `git -C <path> …`, a chain with another command, or git beside a parallel sandboxed call all stay inside the sandbox, where `git commit` fails on signing; the sandboxed working tree also shows 0-byte placeholders for denied paths (`.bashrc`, `.mcp.json`, `.claude/agents`, others), so a sandboxed `git add -A` would stage them. The rule that follows: git is always called alone.
