---
thread: The release plan
date: 07-09-2026
state: approved by the Principal on 07-09-2026 as one decision. Executing in three releases.
role: planner (orchestrate gear two). The executor reads this file, not the conversation.
reads: ../canon-identity/, ../posts and functions/, ../the vault that is not there/, ../what main is for/
---

# The plan, in three releases

One approval, three pull requests. Splitting is labour, not a second decision: each release has
to be reviewable on its own, and a change that reaches every copy is not reviewable as a wall.

Order is by value per line, not by size. **The first release carries the check that would have
saved this session six hours.**

## Release A — the sensors and the vault

The smallest, stands alone, and repairs a failure that already happened.

| Path | Change |
|---|---|
| `tools/hygiene.sh` | **Check 4:** more than one remote branch carries `memory/state.md`. **Check 5:** `memory/corrections.md` absent — name the path, since §9 says read it before routing a correction and nothing else says where it is. Fix the comment claiming the canon has no `memory/`; it has two branches with one. |
| `tools/test-hygiene.sh` | cases for both, and silence when neither fires |
| `tools/candidates.sh` | match only `#propagate:DD-MM-YYYY`, never the bare name. **New check:** an item reading *candidate for upstream* with no dated tag is itself a finding. |
| `tools/test-candidates.sh` | a bare mention is not an item; an untagged candidate is |
| `system/5-memory-an-obsidian-vault.md` | `memory/projects/` is created at onboarding, not assumed; `corrections.md` appears with the first correction and the sensor names it |
| `.claude/skills/onboard/SKILL.md` | step 6 creates the onboarding session's own thread folder under `memory/projects/` |
| `SYSTEM.md`, `INDEX.md` | version, regenerated index |

**Measured cause:** on 07-09-2026 `candidates.sh` reported one item, undated, while eleven waited
untagged and the one it found was a sentence describing the sensor. On the same day a session read
a superseded vault for six hours because two branches carried one agent's `state.md` and nothing
looked across branches.

## Release B — identity moves to the post

The structural one. Nothing on `main` says who anybody is.

| Path | Change |
|---|---|
| `.canon` | leaves `main`. Lives on the branch where custody is held. |
| `tools/pr-guard.sh` | **split by whether the question needs identity.** Paths stay in CI. The version-bump question moves to the agent's side, because a check that cannot be answered where it runs must not run there. |
| `.claude/hooks/anchor.sh` | read the marker where it now lives; the agentless menu asks *does an agent already live here* instead of *is this the canon*; never offer continuation of the demo |
| `tools/sync.sh` | `README.md` keeps ours on the **first** hop as it already does on the second |
| `system/6-repositories-and-branches.md` | the membership test; the upward flow and the three-part gate; the README rule at the first hop |
| benches | `test-pr-guard.sh`, `test-anchor.sh`, `test-sync.sh` |

A copy writes `.blueprint` at onboarding: the blueprint's `owner/repo`, on its own role branch.
**`.blueprint` present means derived**; absence of provenance is what makes a repository the root.

## Release C — posts and functions

The largest, and it touches every reply in every copy.

| Path | Change |
|---|---|
| `posts/`, `functions/` | the catalogue: `custodian`, `steward`, and the functions they reference |
| `system/5` | `posts:` in the frontmatter; `memory/posts/` and `memory/functions/` in the tree; the two forms |
| `system/9` (in `SYSTEM.md`) | the header gains the agent and `post/function`; a session declares its function |
| `system/7-projects.md` | the post scopes which projects an agent may open |
| `CLAUDE.md` | rule 2 quotes the header format |
| `.claude/hooks/anchor.sh` | header inputs |
| `.claude/skills/onboard/SKILL.md` | assign `steward`; rebuild both READMEs |
| benches | header, onboarding, the catalogue's shape |

## What must stay true, every release

- Every bench green. `bash tools/ready.sh` reports them and none may be red.
- `tools/index.sh --check` and `tools/sections.sh --check` pass.
- The version is read from `main` **at the moment of release**, never written into this file.
- Three documents in step: `SYSTEM.md`, the section file, `INDEX.md`.
- A copy that has not onboarded again behaves exactly as before. Every change is inert until an
  agent writes the new files.

## What the executor must not do

- Not work on `main`, and not merge. The merge is the Principal's (§6).
- Not widen `tools/pr-guard.sh`'s allowlist. Nothing in these releases belongs on `main` that is
  not already allowed there.
- Not create empty directories. Git cannot track one and a placeholder is a fake presence.
- Not ship a filled-in post, a filled `state.md`, or any file naming an agent, a Principal or a
  project. **The membership test decides: does a fresh copy need this to become itself.**
- Not carry a quotation of any person into a canon file, a commit message or a pull request body.

## How each release is checked

```
bash tools/ready.sh
bash tools/index.sh --check
bash tools/sections.sh --check
bash tools/prose-gate.sh
```

Then the reading no bench covers: **a repository with none of the new files behaves exactly as it
did before.** If it does not, the release is not inert for existing copies and ships a regression
to every one of them.
