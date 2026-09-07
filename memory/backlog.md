# Backlog

What gets done. What was already done lives in the journal, not here.

## Agent

- **Report what the weekly guard finds.** The first run of the guard has not happened yet, so
  this list is empty by fact and not by tidiness. An empty backlog here is the normal state of
  a template nobody has broken.
- **`.canon` has two parsers and they disagree.** `anchor.sh` reads `head -n1`; `pr-guard.sh`
  reads the whole file through `tr -d '[:space:]'`. They agree only while the file is one line,
  so any comment added to it makes `pr-guard` match nothing, set `is_canon=0`, and drop the
  version rail on the canon silently — a fail-open. No longer blocking: the lineage plan keeps
  `.canon` at one line. Found 06-09-2026 while tracing the laboratory proposal
  (`memory/projects/universal-core/canon-identity/custodian-verdict.md`). Candidate for upstream. #propagate:06-09-2026
- **A fork blinds itself, and the one-hop finding beside it was wrong.** `.canon` was read as
  holding two facts, so a copy of a copy was said to sync against the wrong repository. The
  Principal settled it on 07-09-2026: **every generation proposes to the blueprint and none proxies
  through its parent**, so syncing from the root is correct and an intermediate that is ahead is
  holding its own unproposed debt. What survives is the fork: editing `.canon` to your own slug
  makes `origin` match it, `anchor.sh` skips the drift check entirely, and §1's promise that
  silence means parity turns into a fabricated reading. Candidate for upstream. #propagate:06-09-2026
- **The role is declared where nothing reads it.** §5 closes `state.md`'s frontmatter at seven
  fields and none names what the branch is for, so every constraint the custodian states about
  itself is prose no hook reads. Settled by the Principal on 07-09-2026 into posts and functions;
  the design is in `memory/projects/universal-core/posts and functions/proposal.md`.
  Candidate for upstream. #propagate:07-09-2026
- **Nothing detects an unsynced agent branch.** The session-start drift check covers hop one,
  canon into a copy's `main`. On the canon it is skipped by construction — the canon cannot drift
  from itself — so this repository has no version sensor on the branch where all its work happens.
  §6 says drift on hop two *cannot happen* because the hop is a merge, which is only true once
  somebody runs `tools/sync.sh`. On 06-09-2026 this branch was at 1.62.0 against main's 1.64.0,
  four commits behind, and a whole plan was written against the stale tree before an unrelated
  question surfaced it. Synced. The sensor is still missing. Candidate for upstream. #propagate:07-09-2026
- **A stranger on the canon is offered the canon's own agent.** `.claude/hooks/anchor.sh` appends
  the continuation line after all three menu branches without regard to which fired, so the canon
  menu says no agent is created here and then offers its own agent branches, closing with *act on
  evident intent without re-asking*. The agent standing there is the demo: meeting it is the
  point, being handed it is not. Fix: name it as the demo, offer the copy and the pull request,
  never continuation. Candidate for upstream. #propagate:07-09-2026
- **Complete the vault.** §5 draws a tree onboarding only partly builds: `memory/projects/` is
  required before anything creates it, `projects/` is named twice and built by nothing, and
  `memory/corrections.md` is absent by an argument whose hole is that nothing says the file may
  exist. Plus a fourth `tools/hygiene.sh` check for two branches carrying one agent's vault, which
  is what cost this session six hours. Measured in
  `memory/projects/universal-core/the vault that is not there/proposal.md`.
  Candidate for upstream. #propagate:07-09-2026
- **Posts authorize functions, and the header carries both.** An agent holds a post, a post
  authorizes functions, a session exercises one — so *a function no post authorizes cannot be
  exercised* becomes a sentence a hook can enforce. `custodian` on the canon, `steward` in a copy,
  and they are not one post: agnosticism is the custodian's claim to judge a proposal and a copy's
  agent properly has an interest. Definitions ship, grants do not. Full design in
  `memory/projects/universal-core/posts and functions/proposal.md`.
  Candidate for upstream. #propagate:07-09-2026
- **A copy's `main` README is the canon's sales page, addressed to a reader who already left.**
  It says *your first act is making your own copy* to somebody standing inside one. The agent
  rebuilds it with its Principal's specifications — whose repository, what for, which agent, and
  where it came from. Provenance is recorded twice for two readers: that README line for a person,
  and `.blueprint` on the role's branch for the drift check. `README.md` is the one template file that
  becomes identity the moment a copy exists. The second hop already carves it out of the sync and
  **the first hop does not**, so a rebuilt README is overwritten by the next template pull request.
  Written up in `memory/projects/universal-core/what main is for/the readme is the filled form.md`.
  Candidate for upstream. #propagate:07-09-2026
- **Put the membership test and the upward flow into §6.** The test — *does a fresh copy need
  this to become itself* — is written nowhere, so the rule survives as a path list that cannot
  answer for a path nobody has proposed yet. And it is a rule about **every** `main`, not the
  canon's, because any `main` can be copied. With it: everything is proven outside its own `main`
  and then proposed upward; a change that lands in a copy gets a verdict out loud rather than a
  default; the gate upward binds on all three of agnostic, an improvement, and verified. Written
  up in `memory/projects/universal-core/what main is for/the membership test.md`. Candidate for
  upstream. #propagate:07-09-2026
- **Write the knowledge entry: a cloud session cannot delete a ref, and a runner is the route.**
  §5 says an entry gets written the first time a procedure is worked out, not later. This session
  spent hours rediscovering something `stacks.yml` and `create-release.yml` had already solved,
  and their header comments were the only record. An entry in `knowledge/` on the canon makes the
  pattern findable instead of archaeological: what the git proxy refuses, how it was measured, and
  the runner shape as the answer. Held out of pull request #78 deliberately, because widening a
  pull request under review costs the review. Candidate for upstream. #propagate:07-09-2026

- **A proposal does not stop where it is accepted, and nothing watches for it.** Set by the
  Principal on 07-09-2026: work is tested outside its own `main`, proposed upward, and a copy does
  not stop the proposal at its own main — it goes on to the canon's custodian. The merge into a
  copy's `main` **creates** the obligation rather than discharging it, and local success is what
  hides it: the backlog item closes and the journal says landed. `tools/candidates.sh` reads the
  backlog's upstream tags, so a change already merged is invisible to it. Proposed
  sensor: `git log <canon>/main..origin/main` on a copy, the exact outstanding set, reported and
  never blocking, silent on the canon. Written up in
  `memory/projects/universal-core/what main is for/the proposal does not stop.md`.
  Candidate for upstream. #propagate:07-09-2026

- **An untagged candidate is invisible, and prose about the tag is not.** On 07-09-2026
  `tools/candidates.sh` reported exactly one item waiting, undated. The truth was **eleven**
  waiting and **none** tagged: the one it found was a sentence describing the sensor, because it
  greps the bare tag name rather than the dated form. Both directions are wrong — a real candidate
  with no tag never appears, and a mention of the tag becomes an item. Fixed here by tagging all
  eleven. The tool still needs the narrower match, and a second check: **a backlog item saying
  *candidate for upstream* with no dated tag is itself a finding**, because that is the state
  every one of these was in for a day. Candidate for upstream. #propagate:07-09-2026

## Principal

- **An unlisted model is acting as the Custodian, and the gate that should have caught it was
  never built.** `memory/state.md` says `MODELS.md` on `main` names the approved models and
  `tools/models.sh` compares them against what the runtime served, and that *served something
  unlisted, this agent says so and stops*. Neither file exists — not on this branch, not on
  `main`. The only model approved in that prose is `claude-sonnet-5`, for the scheduled guard.
  The session of 06-09-2026 ran `claude-opus-5` and reviewed a proposal, wrote a plan, and fixed
  a bench. Nothing detected it; it surfaced because the Principal asked an unrelated
  question. Decide: build the gate, or amend `state.md` to stop promising one. A rule that reads
  as a mechanism and is prose is worse than an absent rule, because it is trusted.
- **`tools/challenge.sh` does not exist either.** `memory/projects/guardia/la guardia semanal/`
  describes it as the doorman whose difficulty rotates with the ISO week and which the weekly
  guard tunes on the attempt log. Same class as the item above: memory describing machinery that
  was never built.
