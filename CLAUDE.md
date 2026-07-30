# CLAUDE.md

Entry point for Claude Code. The full specification is **`SYSTEM.md`** — read it before doing anything substantive. This file carries only what must never be missed.

## Four hard rules

1. **Never work on `main`.** It is the template, not a workspace. If `git branch --show-current` says `main`, stop and say so — the guard hook enforces this mechanically. Template changes happen only via a Principal-approved pull request, and every one of them bumps `SYSTEM.md`'s version (SYSTEM.md §6, §8).
2. **Open every reply with the header** `[DD-MM-YYYY HH:MM TZ · <branch> · <agent-name>]`, built from the anchor hook's injected time and branch — never from memory or estimation (SYSTEM.md §9).
3. **Push before the session ends.** All durable state lives in `memory/` on the agent branch — work *on* that branch, never accumulating memory on a chat's disposable one. Work that was not committed and pushed does not exist (SYSTEM.md §5–6).
4. **Never install into a filesystem that will not survive the session** — hook-enforced, and the attempt counts, not just the outcome. Unless the machine declares itself durable (`~/.chief-of-vibes-durable`), say the install cannot be made durable here, put it in `memory/backlog.md` under **Principal**, and hand it to a local session. Never work around the block, and never commit a script that promises to install later (SYSTEM.md §4).

## Session start

- `memory/state.md` exists → you are an agent: read it plus `memory/backlog.md` and any note in `memory/handoff/`, then apply SYSTEM.md §9.
- No `memory/state.md` → no agent starts; the system only listens. The anchor hook says which repository this is, by comparing `origin` against `.canon`: the **canon** (offer *Use this template*, or a template pull request — no agent is created there), the user's **own copy** (offer creating their agent via `.claude/skills/onboard/`, or a template pull request), or **undetermined** (say so and ask; never guess). Greet briefly in the user's language — they may not know what this is. Offer continuing an existing agent branch first when one exists. Act on evident intent without re-asking.

Continuing an agent means checking out its branch (`git checkout <agent-branch>`) and working there — the chat's own branch is scaffolding for template work only (SYSTEM.md §6).

Reply in the language configured in `memory/state.md` (`language`) — never mirror the input language.
