---
name: onboard
effort: medium
summary: Create your agent: name it, pick its language and timezone, set its goal, and give it a branch and a memory.
description: Create a new agent on a clean chat — name it, configure language and timezone, set the goal, and create its branch and memory vault. Use when a chat has no memory/state.md and the user chooses to create an agent.
---

# onboard

Rides SYSTEM.md §3: act don't queue · never fabricate a reading (the test timestamp comes from `tools/now.sh`) · sober register.

Creates the agent: one short conversation, then a branch and a memory vault. Total time: minutes.

## Steps

0. **The right repository.** The anchor hook already answered this by comparing `origin` against `.canon`. If the answer was undetermined (no `.canon`, no `origin`), ask before creating anything — an agent's memory in the wrong repository is the one mistake this step exists to prevent. Agents live only in the user's copy (SYSTEM.md §6).

   On the canon — or in a fresh clone of it, which is how a newcomer who pasted one line into Claude arrives — no agent is generated where the session stands. The copy gets made first, and **making it is the session's work, not the user's**:

   1. Name the copy. Ask, defaulting to the agent name lower-kebab-cased.
   2. Create a repository the user owns, with whatever the session holds: `gh repo create <name> --private` where the `gh` CLI is authenticated, or the surface's own GitHub tooling where it grants repository creation. **Private by default** — the agent's memory will live there, and publishing it should be a decision, never an accident.
   3. Point `origin` at the new repository and push `main`. `.canon` travels unchanged, so every later session knows it stands in a copy (§6).
   4. Only when nothing in the session can create a repository: say so plainly, name what was tried (§3, a negative answer names its frame), and give the fallback — the *Use this template* button on the canon's page — then continue in the copy the user made.

   Either way onboarding continues in the copy, never on the canon.
1. **Names.** Greet in the user's apparent language, one line. Ask: agent name (default *Chief of Vibes*) and how to address the Principal (default *Director*).
2. **Language.** The language of every future reply (default English). The Principal may write in any language; the agent always answers in this one.
3. **Timezone.** Ask for the IANA zone — `UTC` is the universal default; personalized examples: `America/New_York`, `Europe/London`, `Asia/Tokyo`, `Australia/Sydney`. Show one test timestamp and confirm it before persisting.
4. **Goal.** The standing objective the agent prioritizes by — income, research, a body of work, a craft. One sentence.
5. **Branch.** Agent branch name, defaulting to the agent name upper-kebab-cased (*Chief of Vibes* → `CHIEF-OF-VIBES`). Create it from `origin/main` and check it out — the rest of this session, and every later one, runs there and not on the chat's disposable branch (SYSTEM.md §6).
6. **Vault.** On the new branch, create:
   - `memory/state.md` — the SYSTEM.md §5 frontmatter, filled from the answers; `created` from `tools/now.sh`, reordered to `YYYY-MM-DD` (date only).
   - `memory/backlog.md` — `## Agent` and `## Principal` sections, both empty.
   - `memory/journal/<today>.md` — first note: agent created, goal recorded.
   - `README.md` — rewritten to describe THIS agent (name, goal, branch), replacing the template sales page.

   `memory/handoff/` is not created here: it appears with the first handoff note (SYSTEM.md §5).
7. **Land.** Commit, push the branch, and confirm to the Principal: agent name, branch, goal, and one suggested first action toward the goal.
8. **Explain what just happened.** Five plain lines, assuming no git knowledge: what a repository, a branch, a commit, and a push are, where the agent's memory lives, and how a handoff note carries an unfinished thread into a fresh chat. The Principal leaves the onboarding understanding the machinery they now own (§3 involve-and-teach).

## Notes

- If the session cannot create branches directly, create the files on the current surface, push, and tell the Principal how to promote the branch.
- Any single step re-runs on request ("change my timezone" → step 3 only).
