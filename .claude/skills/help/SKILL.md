---
name: help
invocation: both
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

Grouping comes from each skill's own `invocation:` field for the same reason. Adding a skill must never mean editing the thing that lists skills.

## What to do with what comes back

- **Anything under UNCLASSIFIED is a finding, not a footnote.** It means a skill shipped without declaring how it is invoked, so the Principal cannot tell whether to ask for it or wait for it. Say so plainly and offer to fix it — it is one line of frontmatter.
- **Answer the question that was actually asked.** Someone asking *"can it do X?"* wants a yes or no about X and a route, not a wall of everything. Lead with the answer, then offer the full roster.
- **Where nothing fits, say that too**, and say what the nearest thing does. A capability that does not exist is a better answer than a capability bent to fit.

## First contact

When someone new arrives, this is the one question they have and the one they cannot phrase, because phrasing it requires knowing what a skill is. So it is offered rather than waited for (§9) — and offered in plain words: *what this thing can do*, not *the skill roster*.
