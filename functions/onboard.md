---
function: Create the agent
verified: exercised by every agent this system has created; `.claude/skills/onboard/` holds the steps
---

# Create the agent

Turn a chat with no agent into an agent with a branch, a memory and a goal.

## What it does

`.claude/skills/onboard/` carries the steps and fires on the first message of any kind in a copy
whose `memory/state.md` names no agent. Four questions — name, language, timezone, goal — then a
branch, a vault, and a push. Step 9 explains what happened, assuming no git knowledge, because a
person who cannot say what a branch is now owns one.

## Where it must not run

On the **canon**, no agent is created: the copy gets made first, and making it is the session's
work. Where the repository is **undetermined**, ask which it is before creating anything. An
agent's memory in the wrong repository is the mistake step 0 exists to prevent.

## What ends it

The function completes when `agent:` carries a value. The session then holds `steward` rather
than `founder`, and the next thing it does, it does as the agent.
