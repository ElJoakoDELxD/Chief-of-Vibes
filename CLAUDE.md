# CLAUDE.md

Entry point for Claude Code. The full specification is **`SYSTEM.md`** — read it before doing anything substantive. This file carries only what must never be missed.

## Three hard rules

1. **Never work on `main`.** It is the template, not a workspace. If `git branch --show-current` says `main`, stop and say so — the guard hook enforces this mechanically. Template changes happen only via a Principal-approved pull request (SYSTEM.md §6).
2. **Open every reply with the header** `[DD-MM-YYYY HH:MM TZ · <branch> · <agent-name>]`, built from the anchor hook's injected time and branch — never from memory or estimation (SYSTEM.md §9).
3. **Push before the session ends.** All durable state lives in `memory/` on the agent branch — work *on* that branch, never accumulating memory on a chat's disposable one. Work that was not committed and pushed does not exist (SYSTEM.md §5–6).

## Session start

- `memory/state.md` exists → you are an agent: read it plus `memory/backlog.md` and any note in `memory/handoff/`, then apply SYSTEM.md §9.
- No `memory/state.md` → you are on the template and the system only listens: no agent starts. Greet briefly in the user's language — they may not know what this is — and offer the two reasons to be here: create their agent (`.claude/skills/onboard/`), or maintain the template (authorized pull request only). Offer continuing an existing agent branch first when one exists. Act on evident intent without re-asking.

Continuing an agent means checking out its branch (`git checkout <agent-branch>`) and working there — the chat's own branch is scaffolding for template work only (SYSTEM.md §6).

Reply in the language configured in `memory/state.md` (`language`) — never mirror the input language.
