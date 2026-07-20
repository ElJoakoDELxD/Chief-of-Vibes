---
name: onboard
description: Create a new agent on a clean chat — name it, configure language and timezone, set the goal, and create its branch and memory vault. Use when a chat has no memory/state.md and the user chooses to create an agent.
---

# onboard

Rides SYSTEM.md §3: act don't queue · never fabricate a reading (the test timestamp comes from `tools/now.sh`) · sober register.

Creates the agent: one short conversation, then a branch and a memory vault. Total time: minutes.

## Steps

0. **The right repository.** If this session runs on the public canon (the template's own repository), no agent is generated here: walk the user through *Use this template* on GitHub to create a repository they own, then continue there. Agents live only in the user's copy (SYSTEM.md §6).
1. **Names.** Greet in the user's apparent language, one line. Ask: agent name (default *Chief of Vibes*) and how to address the Principal (default *Director*).
2. **Language.** The language of every future reply (default English). The Principal may write in any language; the agent always answers in this one.
3. **Timezone.** Ask for the IANA zone — `UTC` is the universal default; personalized examples: `America/New_York`, `Europe/London`, `Asia/Tokyo`, `Australia/Sydney`. Show one test timestamp and confirm it before persisting.
4. **Goal.** The standing objective the agent prioritizes by — income, research, a body of work, a craft. One sentence.
5. **Branch.** Agent branch name, defaulting to the agent name upper-kebab-cased (*Chief of Vibes* → `CHIEF-OF-VIBES`). Create it from `origin/main`.
6. **Vault.** On the new branch, create:
   - `memory/state.md` — the SYSTEM.md §5 frontmatter, filled from the answers; `created` from `tools/now.sh`, reordered to `YYYY-MM-DD` (date only).
   - `memory/backlog.md` — `## Agent` and `## Principal` sections, both empty.
   - `memory/journal/<today>.md` — first note: agent created, goal recorded.
   - `README.md` — rewritten to describe THIS agent (name, goal, branch), replacing the template sales page.
7. **Land.** Commit, push the branch, and confirm to the Principal: agent name, branch, goal, and one suggested first action toward the goal.
8. **Explain what just happened.** Five plain lines, assuming no git knowledge: what a repository, a branch, a commit, and a push are, and where the agent's memory lives. The Principal leaves the onboarding understanding the machinery they now own (§3 involve-and-teach).

## Notes

- If the session cannot create branches directly, create the files on the current surface, push, and tell the Principal how to promote the branch.
- Any single step re-runs on request ("change my timezone" → step 3 only).
