## 8. Extending

New capability enters as a skill: one folder under `.claude/skills/<name>/`, and one `SKILL.md` whose description states exactly when it triggers, opening by naming the §3 rules it rides so it is never read detached from the posture governing it. Its frontmatter also carries `summary:`, one plain line for a person rather than for trigger matching, so the §1 roster needs nothing but the directory. Where a skill lacks it the agent supplies it by reading the skill, because describing a capability in one line is the agent's work and not the Principal's. It then writes it in, so the judgment is spent once instead of every session. Every skill records its provenance. Skills are template files: adding one requires Principal approval, and it must have produced at least one real result first.

**Who can invoke a skill is the runtime's field, never a second one of ours.** A skill is a command and fires on its own by default. `user-invocable: false` removes the command, for a skill that answers to a situation and that nobody would type. `disable-model-invocation: true` removes the automatic firing, for a skill whose timing is the Principal's. The roster groups on those two fields because they are the ones enforced. A field only our own script reads is rung 5 wearing a declaration's clothes: it can say a skill has no command while the runtime goes on offering one, and the roster is the half a reader trusts. The `propagate` skill states the general form as a trap — where the runtime controls the thing, a rule of ours is decoration. So the specification does not restate what the runtime already enforces. It says which field to write.

**What a skill costs to run is declared the same way.** §3 already rules the choice: gauge the effort, and take the lightest path that does the work well. That rule sat at rung 4, re-decided every time a skill ran and written down nowhere. `effort:` writes it once, per skill, and the runtime applies it. So every skill declares one, chosen from what the work *is* rather than from how important it feels: `low` where the skill reads something and renders it, `high` where it decides what only this session knows. The sibling field `model:` stays unset on purpose. Effort is cheap to be wrong about and visible when it is; a downgraded model is a quieter kind of wrong, and §3's *ask what a convenience stops looking at* covers exactly that.

**Delegated work is routed by the agent, per call.** A subagent takes the model as an argument, so *gauge the effort* is a live choice on every delegation rather than a preference. Heavy judgment that must not share context with the work goes to a capable model in a fresh one. A wide mechanical sweep goes to a cheap one. The brief is a file either way (§3), and what comes back is read as a reading, never as authority.

Only one thing here belongs to the Principal, and it is narrow: **which model answers them in their own session.** That is their key, the way clearing the window is. Where a request is heavier than their session is set up for, the agent says so and names the key.

The distinction matters because it is easy to state backwards, and stating it backwards turns one narrow limit into a general *cannot*. §3 already names that failure: a correct measurement of a narrow question returns a falsehood carrying the evidence of rigour. Before any *cannot* about the agent's own reach, the survey in §3 applies to the tools in front of it — another executor is one of the frames it names, and a subagent is one.

**Write the trigger as a situation where one exists.** A description the agent can recognise from the work beats one that waits to be named. But a trigger is a judgment, so it sits at rung 4. Judgment is not what makes a capability findable: **discovery is the generated roster in §1.** A well-worded trigger is worth having. It is not a substitute for being listed. A trigger only fires when someone notices, and nobody can see the times it did not.

**The ladder, and where a rule belongs.** Every rule in this document sits on one of five rungs. The test applied to anything new is *which rung can hold this, coherently*:

| Rung | Form | Example |
|---|---|---|
| 1 | **Impossible by construction** | `tools/sync.sh` merges, so an agent branch cannot drift from `main` (§6) |
| 2 | **Blocked by a rail** | `guard-install.sh` refuses an install that will not survive (§4) |
| 3 | **Reported by a sensor** | the drift check names the version gap at session start (§1) |
| 4 | **Written as a rule** | the §3 rules that no machine can decide |
| 5 | **Left to memory** | nothing, ever |

The document is arranged by that column. §1 lists rung 1 under *what cannot happen*, and rungs 2 and 3 in the table of what runs. §3 is the whole of rung 4. Rung 5 has no section because it holds nothing. Reading a rule's rung tells you what would have to change for it to stop depending on someone remembering it.

Higher is better, but only as far as a rung holds the thing honestly. A rail judges what is mechanically decidable, and pushed past that it produces false positives, which teach the agent to route around it. A rail routed around protects less than none, since it also grants false confidence. So rails stay narrow and arrive with a bench pinning what must be blocked *and* what must be left alone. Judgment cannot climb at all. *Search before propose*, *the Principal's voice is the Principal's*, and *ship the work instead of polishing the system* would each need a rail that lies.

**When a rule climbs, the text shrinks.** It keeps only the sentence naming what enforces it and where. Carrying the prose too makes the agent pay twice, once in context and once in the discretion the text reopens. The machinery grows and this document gets shorter. If a change grows both, it has not finished.

**The test is redundancy, not length.** This section guards against saying again what another section already says. That is what gets paid twice. Words that buy comprehension are not that cost. A word count is only a proxy for redundancy, and it stops tracking it as soon as the easy repetition is gone. An agent grinding a release toward a negative number is serving the proxy, and what it cuts next is muscle. So a release names what it added and what it removed and makes the case. It does not owe a negative number to be finished.

**And consistency, which is the half that bites after the cut.** Redundancy asks whether a thing is said twice. Consistency asks whether two things disagree, and only the second can make somebody act wrongly: two copies of a rule cost tokens, while a rule and a contradicting rule cost a decision. **Cutting one of two copies is what manufactures the second problem**, because whatever pointed at the deleted copy now disagrees with the tree. So a release that removes something says what still refers to it, and checks.

Most of it is mechanically decidable, and the model already exists: `tools/index.sh --check` regenerates the index from the tree and compares, which is a contradiction check under another name. The pattern generalizes. Where the system asserts something about itself and both sides can be read, the check reads both — a table of what runs against the machinery that runs, a generated roster against the frontmatter it groups on, a note's date against the version in force. What is left needs a reader who did not write the thing, which is the limit §8's ladder already states about judgment.

**`LANGUAGES.md` is the reach record.** One line per language the system has explained itself in. An agent adds it the first time it renders its roster in a language absent from the file, by pull request like anything else. It is the only artefact here that a stranger can read without trusting anyone, because everything else is invisible until you read this document. It carries the language and the day, and nothing that identifies a Principal (§7). It says on its face what it counts: one rendering, never an adopter. A count of languages read as a count of users is a vanity number wearing evidence's clothes.

**Three documents, fixed roles.** `SYSTEM.md` is the specification. `CLAUDE.md` is the runtime entry point, carrying only what must never be missed. `README.md` is the public description of what the system does. A change to any mechanism updates all three in the same commit. The §1 transparency table is a promise, and a table that lags the machinery is a broken one.

**The specification is a core and its leaves.** `SYSTEM.md` carries §2, §3, §4 and §9. Every other section is one file under `system/`, named `<number>-<title>.md`. The split is by *when a rule is needed*, never by size. **Resident is what an agent must hold before it acts**, because breaking one of those needs no warning: who decides what (§2), what it may never do (§4), how a session opens and closes (§9), and the conduct that governs every reply (§3). A leaf carries the procedure for something already decided, so the work itself is the cue to open it.

The map in the core is what makes reading on demand safe, and it is checked rather than trusted. `tools/sections.sh --check` fails when a row and the tree disagree, in CI and on demand (§1). Without it, moving a section is how a rule quietly stops existing: the pointer still reads fine and nothing behind it is there. That is §3's *never fabricate a reading*, one level up — a map is a reading of the tree.

Two things follow for anyone editing this. A new section is a new leaf **and** a new row, and the check names whichever is missing. And **moving a rule between the core and a leaf is a release**, because it changes what an agent knows without being asked.

**Every merge into `main` is a release.** It bumps this file's version on the way in. Patch for wording and fixes, minor for a new mechanism or rule, major for a change that breaks existing agents. The CI guard enforces the bump, and `git log main` is the changelog, which is why one pull request carries one change.

**A stack is a chain of releases, not a way around them.** Each layer targets the one below and keeps its own bump, so the chain reads as consecutive releases. A stack removes the manual re-basing between links, and not the gate on any of them. It does that only while it is merged without squashing. A squash lands new history on `main` while the layers above still carry the original commits.

Two things are called stacking and only one is the feature. CONTRIBUTING carries the difference and the check that says which one a repository has. What the specification fixes is the consequence. A **registered stack** is evaluated by Actions against the *stack's* base, so a trigger watching `main` covers every layer. Bases **chained by hand** are ordinary pull requests, and a `main`-only trigger would miss every one above the first. The guard covers `claude/**` for that case and is harmless in the other. Registering a stack does not require the session to reach the API. `.github/workflows/stacks.yml` calls it from a runner, which is a different origin, outside whatever egress policy sits in front of the session.

---

*Part of the specification. The core is [`SYSTEM.md`](../SYSTEM.md); [`INDEX.md`](../INDEX.md) maps every section to its file.*
