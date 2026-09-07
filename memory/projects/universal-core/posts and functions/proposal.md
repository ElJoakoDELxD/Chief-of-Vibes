---
thread: Posts and functions
date: 07-09-2026
state: proposal written 07-09-2026 on the Principal's instruction. Unimplemented.
supersedes: the `roles/` section of `../the vault that is not there/proposal.md`
---

# One word was doing two jobs

The Principal's correction of 07-09-2026: *role* is imprecise. An agent **holds a post**, and a
**post authorizes functions**.

That splits a word that was carrying two meanings at once. *Role* named the standing office and
the particular activity, so nothing could say which one a session was exercising.

```
agent  ──holds──▶  post  ──authorizes──▶  functions  ──one per session──▶  the work
```

- **Agent.** Chief of Vibes. One identity, one vault, one branch.
- **Post.** Custodian. Standing, held by one agent, and the thing that confers authority.
- **Function.** One authorized activity: prepare the door on a proposal, run the weekly guard,
  keep the benches, teach a contributor how to propose, sweep the repository.

**What the split buys is checkability.** A function no post authorizes cannot be exercised, and
that is a sentence a hook can enforce. *Role* could never produce that sentence, because the
office and the act shared a name.

The template is written in English (§6), so the words that ship are **post** and **function**.
*Office* was the other candidate for the first and it is ambiguous in English, where it is also
a room.

## Where they live

**`posts/<post>.md` and `functions/<function>.md`, two template directories beside `knowledge/`.**

`knowledge/` is what a repository knows. `posts/` is what an agent may be. The canon ships
`posts/custodian.md`, and a copy inherits the file and fills the post with its own occupant,
which is what §6 already describes for everything else in the template.

A post file lists the functions it authorizes **by reference**. The bodies live in `functions/`,
written once. The reasoning is below, under the decision it reverses.

`memory/state.md` gains **`posts:`**, the set this agent holds. The charter already drafted at
`../canon-identity/the-custodian-role.md` moves out of memory and becomes `posts/custodian.md`.

## The header

The Principal's specification: **agent, post, function, workplace.**

```
[DD-MM-YYYY HH:MM TZ · <agent> · <branch> · <post>/<function> · memory/projects/<topic>/<thread>/ · <model>·<effort>]
```

**Naming the agent reverses a decision §9 made on purpose, and today falsified the reason.**
§9 dropped the agent's name because *the branch already carries it: a repository holds one agent
per branch, so the name was the branch said twice.* That was sound when it was written.

On 07-09-2026 it broke. Two branches carried one agent's identity, this session read the wrong
one for its whole length, and the branch field showed nothing wrong the entire time. A header
naming the agent would have printed `Custodian` beside a branch called `Chief-of-Vibes-Agent`,
and the mismatch is the defect, visible on the first reply instead of found six hours later.

So the field is not redundancy. It is the check on the assumption the old reasoning rested on.

**Degradation, matching how the workplace field already behaves.** No agent: the first fields
alone. A post held with no function declared: `custodian/no function declared`. No post held:
the field is absent entirely, which is every copy's agent until it is given one.

**The cost is real and it is the same cost §9 already accepted.** Every reply in every copy grows
by two fields. §9's defence of the workplace field is the defence here: putting it on every reply
is what makes the drift visible while it happens rather than in the next 5S.

## The Custodian holds projects

The Principal overrules the earlier proposal, which said the deliverables tree stays absent.

**The post scopes what projects the agent may open.** The Custodian post authorizes projects
aimed at the template and the canon, and nothing else. A copy's agent holds a different post and
opens projects aimed at its Principal's goal.

**And the agent may open one on finding a fault.** That is not the self-improvement the charter
refuses. The charter refuses a search with no stopping condition and no outside signal. A project
opened on a measured fault is the opposite of that: the fault is the signal, and §7's brief gate
still puts the decision in front of the Principal. The two rules do not collide, and the reason
they do not is worth writing into the post file rather than leaving to be re-derived.

**§7 needs no widening.** Its measure already fits: *only unsolicited external signals count — a
reader, a user, a payment, a stranger's issue.* For a template project the signal is a copy
adopting the change, or a stranger opening a proposal.

**But that measure is unmeasurable here today, and saying so is part of the proposal.** No copy
has ever sent anything back to this canon. A Custodian project can therefore pass its brief, ship,
and reach the measurement step with nothing to measure. That is the honest state of the return
flow, and a project of this kind should say in its own brief what signal it is waiting for and
accept that the answer may be silence.

So `projects/` is created by the first project that ships, under the §7 gate. Not eagerly, and
not never.

## Sizing

One release, and it is not small. `system/5` for the frontmatter and the vault shape, `system/9`
for the header and the session declaration, `system/7` for the post-scoped project rule, the
`posts/` directory and its first file, `.claude/hooks/anchor.sh`, the onboard skill,
`tools/pr-guard.sh` for the new template path, `tools/index.sh` and `tools/sections.sh` if either
enumerates template directories, and `CLAUDE.md` rule 2, which quotes the header format.

The vault proposal in the sibling folder is independent and can go first or second.

## Both open decisions, resolved 07-09-2026

### Two directories, and the one-directory recommendation is withdrawn

**Reversed on 07-09-2026, the same day it was made.** The recommendation said one directory until
a function is shared, with a written trigger for splitting. The Principal read further ahead and
the trigger fires almost at once.

Name four functions and ask whether a copy's post would authorize them:

| Function | Canon | A copy |
|---|---|---|
| prepare the door on a change to `main` | yes | **yes** — every copy has a `main` and a gate |
| keep the benches green | yes | **yes** |
| write the handoff | yes | **yes**, and arguably no post gates it at all |
| judge a proposal from a stranger | yes | no — only the canon receives strangers |

Three of four are shared with the **first** copy that adopts a post, not someday. So a post file
holding function bodies duplicates them from the beginning, which is the drift §5 names about two
memories, arriving through a door this proposal would have built.

**So: `functions/<function>.md` and `posts/<post>.md`, two directories.**

### What each one is, and why nothing is written twice

```
functions/prepare-the-door.md          what the work is, once, for everybody
posts/custodian.md                     which functions it authorizes, and what holding it obliges
memory/state.md   posts: [custodian]   which posts THIS agent holds
the header        custodian/prepare-the-door    which one this session exercises
```

**A function is an activity, defined once.** What it is, what it requires, what it must never do.
`functions/` is the catalogue and it is written for everybody, because the same door needs
preparing in every repository that has a `main`.

**A post is authority, plus the obligations of holding it.** `posts/custodian.md` says which
functions the post authorizes — by reference, never by copying their text — and carries what is
true of the holder rather than of any one activity: independence, custody without authority, duty
to the contributor, duty to the absent party, measurement before opinion.

**A post does not name an agent.** It says what the post authorizes, and `memory/state.md` says
which posts this agent holds. That indirection is the point. A post file is template content
inherited by every copy, so a post naming an agent would ship somebody else's agent into every
repository that syncs — which is precisely the mistake diagnosed this morning about `.canon`,
rebuilt in a new place.

**And a function is not a skill.** A skill is *how* to do something. A function is *whether this
agent may*. The two are different axes and the mapping is not one to one: `handoff` is a skill
serving a function, merging into `main` is a function authorized to **no** post and so has no
skill, and `orchestrate` runs underneath every function rather than being one. `functions/` does
not mirror `.claude/skills/` and listing them against each other would be the redundancy this
split exists to avoid.

### The header keeps the branch, adds the agent, and the agent is not the check

**Keep the branch.** `CLAUDE.md` rule 1 makes it operational: a session on `main` must leave, and
the header is what shows where it stands. Replacing it with the agent removes a rail.

**Add the agent, on honest grounds.** The claim made earlier the same day — that an agent field
would have caught this session reading a superseded vault — **is wrong, and it is withdrawn.**
Both `state.md` files were internally consistent. The stale one on `Chief-of-Vibes-Agent` names
`branch: Chief-of-Vibes-Agent`, the live one on `Custodian` names `branch: Custodian`, and no
field contradicted another. A header printing agent beside branch would have shown
`Custodian · Chief-of-Vibes-Agent`, which reads as wrong only to somebody who already knows
*Custodian* is a post and not an agent. It would not have shown the second vault at all.

What the field is actually worth is smaller and still worth one short column: a reply that says
which agent wrote it is readable by somebody who does not know which branch belongs to whom.

**The post and function field carries the real weight.** It is the only proof a session declared
what it was authorized to do, exactly as `model·effort` is the only proof the triage ran. A reply
with no function on it was written by a session that never asked whether its post allowed the
work.

### And the thing that actually catches a duplicated vault is a sensor

Two branches carrying a `memory/state.md` for one agent is what happened, and no header field
sees it, because each branch reads correctly on its own. `tools/hygiene.sh` is where it belongs:
it already reports three ways memory goes out of sync, the anchor hook already runs it at session
start, and §5 already calls a second memory drifting out of sync a defect.

**Proposed fourth check: more than one remote branch carries `memory/state.md`.** One line of
`git ls-remote` and a `git cat-file -e` per head. It reports and never blocks, like the other
three. It belongs in the vault release rather than this one, because it is a sensor and not a
post.

Its comment also needs a correction while somebody is in the file: it says the sensor prints
nothing outside a copy *because the canon has no `memory/` to measure*. The canon has two.
