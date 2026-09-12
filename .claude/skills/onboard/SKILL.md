---
name: onboard
effort: medium
summary: Create your agent: name it, pick its language and timezone, set its goal and its budget, and give it a branch and a memory.
description: Create a new agent on a clean chat — name it, configure language and timezone, set the goal and the budget it plans against, and create its branch and memory vault. Fires on the FIRST message of any kind, whatever it says, in a copy whose memory/state.md names no agent: a greeting, a question, a request for work. Nobody has to ask for an agent. Not on the canon, where no agent is created, and not where the repository is undetermined.
---

# onboard

Rides SYSTEM.md §3: act don't queue · never fabricate a reading (the test timestamp comes from `tools/now.sh`) · sober register.

Creates the agent: one short conversation, then a branch and a memory vault. Total time: minutes.

## Steps

0. **The right repository.** The anchor hook already answered this. If the answer was undetermined (no marker on this branch, no `origin`), ask before creating anything — an agent's memory in the wrong repository is the one mistake this step exists to prevent. Agents live only in the user's copy (SYSTEM.md §6).

   On the canon — or in a fresh clone of it, which is how a newcomer who pasted one line into Claude arrives — no agent is generated where the session stands. The copy gets made first, and **making it is the session's work, not the user's**:

   1. Name the copy. Ask, defaulting to the agent name lower-kebab-cased.
   2. Create a repository the user owns, with whatever the session holds: `gh repo create <name> --private` where the `gh` CLI is authenticated, or the surface's own GitHub tooling where it grants repository creation. **Private by default** — the agent's memory will live there, and publishing it should be a decision, never an accident.
   3. Point `origin` at the new repository and push `main`. **Nothing on `main` says where the copy came from**, so record it on the agent branch instead: write `.blueprint` with the `owner/repo` this session was standing in **before** the remote was repointed, and a line in the copy's own `README.md` saying the same thing for a person. Never derive either from the agent's name, and ask rather than guess (§6).
   4. Only when nothing in the session can create a repository: say so plainly, name what was tried (§3, a negative answer names its frame), and give the fallback — the *Use this template* button on the canon's page — then continue in the copy the user made.

   Either way onboarding continues in the copy, never on the canon.
**Nobody asks for this.** In a copy with no agent, the first message starts it, whatever the message says. A person arriving at a repository they do not understand cannot choose between *create your agent* and *maintain the template*, and a menu that asks them to is a reply requiring knowledge the agent never gave (§3). Onboarding is what almost every arrival wants, it is four questions long, and step 1 is a greeting. Where somebody wanted the template path instead, they say so and it stops.

The two exceptions stay exceptions. On the **canon** no agent is created, so the offer there is a copy of their own or a pull request. Where the repository is **undetermined**, ask which it is before creating anything — that is the one mistake step 0 exists to prevent.

1. **Names.** Greet in the user's apparent language, one line. Ask: agent name (default *Chief of Vibes*) and how to address the Principal (default *Director*).
2. **Language.** The language of every future reply (default English). The Principal may write in any language; the agent always answers in this one.
3. **Timezone.** Ask for the IANA zone — `UTC` is the universal default; personalized examples: `America/New_York`, `Europe/London`, `Asia/Tokyo`, `Australia/Sydney`. Show one test timestamp and confirm it before persisting.
4. **Goal.** The standing objective the agent prioritizes by — income, research, a body of work, a craft. One sentence.
5. **Budget.** Ask what inference the Principal funds, and how often. Say where the answer lands *before* asking for it: `memory/state.md` on the agent branch, which is public if this repository is. **A scale answers it completely.** *One plan*, *small and steady*, *what a side project bears*. A figure is the wrong answer in a public copy, and blank is a complete answer too. The triage plans against this field and never reports against it, because the agent cannot see what a session cost (SYSTEM.md §8).
6. **Branch.** Agent branch name, defaulting to the agent name upper-kebab-cased (*Chief of Vibes* → `CHIEF-OF-VIBES`). Create it from `origin/main` and check it out — the rest of this session, and every later one, runs there and not on the chat's disposable branch (SYSTEM.md §6).
7. **Vault.** On the new branch, create:
   - `memory/state.md` — the SYSTEM.md §5 frontmatter, filled from the answers; `created` from `tools/now.sh`, reordered to `YYYY-MM-DD` (date only). **`posts: [steward]`**, which every agent holds from the moment it exists: it guards this repository's `main` and sends what generalizes to the blueprint's agent (`posts/steward.md`). The post is assigned, never generated — the definition ships in the catalogue.
   - `memory/backlog.md` — `## Agent` and `## Principal` sections, both empty.
   - `memory/journal/<today>.md` — first note: agent created, goal recorded.
   - `memory/projects/<topic>/<thread>/` for this session, with a note in it. §5 requires a session to stand in a thread folder before its first edit, so the one that creates the agent opens its own instead of leaving the next session to invent the convention.
   - `README.md` on the agent branch — rewritten to describe THIS agent (name, goal, branch), replacing the template sales page.

   `memory/handoff/` is not created here: it appears with the first handoff note (SYSTEM.md §5).
8. **The copy's own `README.md`, on `main`.** The one it inherited is the blueprint's page and it tells its reader to go and make a copy, which is wrong for somebody already standing in one. Rewrite it for this repository: whose it is, what it is for, which agent lives here, and **where it came from** — the same `owner/repo` written into `.blueprint` at step 0.3, said once for a person rather than for the drift check. §6 keeps it through both hops, so it is written once and stays.
9. **Land.** Commit, push the branch, and confirm to the Principal: agent name, branch, goal, and one suggested first action toward the goal.
10. **Explain what just happened.** Five plain lines, assuming no git knowledge: what a repository, a branch, a commit, and a push are, where the agent's memory lives, and how a handoff note carries an unfinished thread into a fresh chat. The Principal leaves the onboarding understanding the machinery they now own (§3 involve-and-teach).

## Notes

- If the session cannot create branches directly, create the files on the current surface, push, and tell the Principal how to promote the branch.
- Any single step re-runs on request ("change my timezone" → step 3 only).
