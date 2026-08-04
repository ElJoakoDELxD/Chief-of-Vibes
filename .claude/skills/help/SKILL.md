---
name: help
effort: low
summary: Show everything this agent can do — what you can ask for, and what runs on its own.
description: Show the Principal what this agent can actually do. Use when they type /help, ask what this thing can do, what commands exist, what they can ask for, whether something is possible here, or say they do not know where to start — and use it unprompted the first time someone new arrives, or when a request suggests they are working around a capability that already exists. It reads the skills directory live, so it is never a stale list.
---

# help

Rides SYSTEM.md §3: *involve and teach* — a reply that requires knowledge the agent never gave is a defect · sober register.

Run it:

    bash tools/skills.sh

Then read the output back in the Principal's language, keeping the grouping.

## Why this file is thin on purpose

The roster is **not written here.** It is read from `.claude/skills/*/SKILL.md` on every run, so a skill added a minute ago appears without anyone updating anything, and a skill deleted stops appearing. There is no index and no cache — nothing to go stale, and no second copy of the truth to drift from the first (§1).

That is the whole reason this skill does not list capabilities itself. A help page that names them is a hand-maintained list wearing a command's clothes: it would be right the day it is written and wrong the day after, and being wrong there is worse than being absent, because a roster is trusted.

Grouping comes from the frontmatter the runtime obeys, `user-invocable:` and `disable-model-invocation:`, for the same reason and one more. Adding a skill must never mean editing the thing that lists skills, and the roster must never say a skill has no command while the runtime still offers one (§8).

## What to do with what comes back

- **A missing summary is the agent's work, not the Principal's.** Reading a skill and saying in one line what it does is the job. Handing the Principal a truncated description is returning labour that was never theirs.

  So: where a skill has no `summary:`, write one from reading its `SKILL.md` — plain, one line, in the Principal's language, saying what it does rather than when it triggers. **Then close the gap.** Offer to write it into the frontmatter, so the next run needs no judgment at all. A judgment repeated every session is rung 4 doing rung 1's work — the roster should end up needing nothing but the directory.

  The grouping never needs this, because there is no undeclared state to read. A skill with neither runtime field is a command that also fires on its own, which is what the runtime does with it.
- **Answer the question that was actually asked.** Someone asking *"can it do X?"* wants a yes or no about X and a route, not a wall of everything. Lead with the answer, then offer the full roster.
- **Where nothing fits, say that too**, and say what the nearest thing does. A capability that does not exist is a better answer than a capability bent to fit.

## When the language is new

After rendering the roster, check `LANGUAGES.md` in the canon. If the language just used is not listed, propose the line — one row, by pull request, reviewed like anything else.

It is worth doing because it is the only evidence this system produces that a stranger can read without trusting anybody: not a testimonial, not a star, but a record that accrued because somebody used the thing. Everything else built here is invisible until you read the specification.

Say what it will and will not claim before proposing it, and say the one risk plainly: in a language with few speakers the entry narrows who the Principal might be. Adding it is theirs to decline, and declining costs them nothing — the system is identical either way.

## First contact

When someone new arrives, this is the one question they have and the one they cannot phrase, because phrasing it requires knowing what a skill is. So it is offered rather than waited for (§9) — and offered in plain words: *what this thing can do*, not *the skill roster*.
