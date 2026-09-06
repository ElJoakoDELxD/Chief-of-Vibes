## 5. Memory — an Obsidian vault

The agent's memory is a folder of plain Markdown with YAML frontmatter: `memory/`. Open it as a vault in Obsidian, or in any editor, and everything the agent knows is there. Nothing about the agent is stored anywhere else.

```
memory/
├── state.md              # who the agent is — one file, YAML frontmatter below
├── backlog.md            # two lists: ## Agent (next actions) · ## Principal (only-you items)
├── journal/
│   └── YYYY-MM-DD.md     # one note per working day: done · decided · lessons
├── corrections.md       # what the Principal already fixed — read before routing the next one
├── handoff/
│   └── <thread title>-handoff.md   # live state of a thread in flight, for resuming in a fresh chat
└── projects/
    └── <topic>/          # one line of work — brief.md here when it is a §7 project
        └── <thread>/     # one chat's workplace, named the way that chat titles itself
```

Two folders carry the word *projects*. `memory/projects/` is the thinking: the brief and its scope log, and the notes of every thread that worked the topic. The deliverables live in a top-level `projects/<name>/` on the agent branch, and that tree stays flat, because session structure is not part of a product. Memory is what the agent knows, and `projects/` is what it made.

### The workplace

A chat titles itself on its first message, and that title is the only thing separating one thread from another. With no folder to match it, one thread's traces scatter under three different names: a handoff note titled for the chat, a loose file named for the subject, and dated lines in the journal.

So **a session declares its workplace before its first substantive edit, and says so in its first reply**. It picks a topic, then either continues a thread folder that exists or opens one, and it names which of the two it did. The thread folder is named the way a handoff note already is, below: three to six ordinary words in the agent's language, with spaces. One convention, used twice.

This tree is the agent's conversation history, and unlike a chat surface's list of auto-titled sessions it outlives the window that produced it.

A topic is a line of work and not always a project. `brief.md` sits at the topic level and is §7's approval gate for a topic that publishes something; a topic whose output never leaves the repository has no brief and does not pretend to. That brief is the only file the topic level holds. Everything else belongs to a thread, and the hygiene sensor reports what sits outside that shape (§1).

Journal notes are appended, never rewritten. Links between notes are relative Markdown, so they render in GitHub and in Obsidian alike. `.obsidian/` is gitignored. Moving this memory to another tool is copying one folder.

`memory/state.md` frontmatter, all of it:

```yaml
---
agent: Chief of Vibes      # the agent's name
principal: Director        # how it addresses you
language: en               # replies are ALWAYS in this language, never mirroring input
timezone: UTC              # IANA zone; drives every timestamp. Outranks $COV_TZ,
                           # which answers only where this file cannot be read
goal: <one sentence>       # the standing objective all priorities serve
branch: <agent-branch>     # the agent's home branch
created: YYYY-MM-DD
---
```

### `knowledge/` — what a repository knows

`memory/` belongs to one agent on one branch. `knowledge/` belongs to the repository, sits on `main`, and is read by every agent there. **The agent writes an entry the first time it works a procedure out, and not later.** A folder that waits for a reason to exist never gets one, and every agent then rediscovers the same thing. This section is the only place its shape is defined.

The distinction is what the writing is *for*. The journal records that a thing happened, dated and closed. An entry here records how to do it again.

**It exists in the canon as well, and the two do not admit the same thing.** A copy's folder holds whatever that repository learned, including what is true only there: this Principal's tools, this account, this machine. The canon's holds **only what is agnostic**: knowledge about operating this system, improvements toward it, and reflections on it. Nothing about one Principal, one agent, or one project reaches it, because an entry there is inherited by every copy that ever syncs, and a wrong one propagates further than any single repository can correct.

**So `verified:` stops being hygiene and becomes the gate.** In a copy it records what was run. In the canon it is the condition of entry: an entry nobody ran is a guess wearing a procedure's format, and a guess that every copy inherits is worse than an empty folder, because it will be trusted.

**The register is honest, serious, self-critical, and without preferences.** An entry that flatters the system is not knowledge about it. What earns a place is what was measured, including what the measurement said about the writer — and *especially* that, because it is the part no one else can supply.

**One folder per topic, and the folder is the point.** An entry lives at `knowledge/<topic>/<entry>.md`, never loose at the top. Choosing the folder forces the question *has this already been thought* before a second copy of the same thought gets written, which is the cheapest place to catch it. The same shape governs `memory/projects/` for the same reason, and the two are one discipline rather than two conventions.

```markdown
---
topic: <one line — the task this covers>
updated: DD-MM-YYYY            # the day, and no finer. A clock time carries a zone,
                               # a zone is a location, and every copy inherits this (§7)
verified: <what was actually run or checked to know this works>
---

## When this applies
## Procedure
## Traps
## How to tell it worked
```

**Traps** earns the file. The happy path is in any documentation. The value is what went wrong the first time. That is the required flag nobody documents, the check that reports success while doing nothing, and the guard that fires on the wrong thing.

Entries are **verified, not theorised**, and `verified:` names what was run, because a guess here is worse than an empty folder: it will be trusted. Entries are **corrected in place** and **deleted** once false. Three things are out of scope. Today's events belong to the journal. This agent's identity belongs to `state.md` and `backlog.md`. Anything only one agent could use belongs in its project's brief.

Entries arrive by pull request into `main`, the same gate as a template change (§6). A claim of repository-wide truth should be read by the Principal before every future agent inherits it. They carry no version bump, since a version is a template release and this is not one.

### `corrections.md` — what the Principal already fixed

One file, appended and never rewritten, and **read before a correction is routed rather than after**. Each entry is three lines. What the agent did, what the Principal said instead, and where the fix was put, naming the rung and the file.

Its point is not the record of having been wrong. It is that **the second occurrence of a correction is a different event from the first, and nothing else makes that visible.** The first time, the fix goes wherever it belongs. The second time the entry is already there. That proves the address was wrong, and that the fix sat at a rung too low to hold. The answer is to climb, not to promise harder. Without the file every correction looks like the first one. An agent's memory of its own conduct is exactly what a fresh session does not have.

Reading it restates the corrected behaviour in the agent's own words before it acts. That is the nearest thing a system with no training loop has to reinforcement. It is why the file earns its place open rather than closed. It stays short by construction. An entry whose fix climbed to rung 1 or 2 is deleted, because the machinery holds it now. A thing nobody can do wrong does not need remembering.

### Handoff notes

A handoff is working state, not memory of record. It is the answer to a context window filling up. It carries a thread still in flight, with enough that a chat knowing nothing resumes mid-stride instead of replaying the old conversation.

One file per thread: `memory/handoff/<thread title>-handoff.md`, titled the way a chat names itself on its first message. Three to six plain words in the agent's language, saying what the work is: `landing page rewrite-handoff.md`, `pro plan pricing-handoff.md`. Ordinary words and spaces, not identifiers. Only `/` and `:` are off-limits, because filesystems reject them. The folder appears with the first note, and every note stays in it: reading that one folder is what tells a session what is in flight, and filing the notes under their topics loses that sweep. A note lives as long as its thread, while the thread's folder outlives it, so the note carries the path. The shape is fixed:

```markdown
---
thread: <one line — what this thread is doing>
updated: DD-MM-YYYY HH:MM TZ    # tools/now.sh, never estimated
branch: <agent branch>
folder: memory/projects/<topic>/<thread>/   # where the thread's own notes live
---

## State — what is done, what is half-done
## Next step — the single next action, concrete enough to start cold
## Open decisions — what the Principal or the agent must still settle
## Files — what was touched and where the work lives
## Dead ends — what was tried and failed, so it is not retried
```

**Lifecycle.** A handoff is written when a session ends with work in flight, or while the context window is still healthy, and never after quality has degraded. The next session reads it before acting and deletes it once the thread lands. An abandoned thread's handoff goes too, with one journal line saying so. What stays is the journal's residue. Handoffs never accumulate: a stale one is a second memory drifting out of sync with the only record of what happened.

---

*Part of the specification. The core is [`SYSTEM.md`](../SYSTEM.md); [`INDEX.md`](../INDEX.md) maps every section to its file.*
