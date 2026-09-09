# Backlog

What gets done. What was already done lives in the journal, not here.

## Agent

- **Report what the weekly guard finds.** The first run of the guard has not happened yet, so
  this list is empty by fact and not by tidiness. An empty backlog here is the normal state of
  a template nobody has broken.
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
- **Complete the vault** — *hygiene landed in 1.67.0 and `memory/posts/` and `memory/functions/` in 1.69.0; what is left is `projects/` and the tree's own rule.* §5 draws
  a tree onboarding only partly builds: `memory/projects/` is
  required before anything creates it, `projects/` is named twice and built by nothing, and
  `memory/corrections.md` is absent by an argument whose hole is that nothing says the file may
  exist. Plus a fourth `tools/hygiene.sh` check for two branches carrying one agent's vault, which
  is what cost this session six hours. Measured in
  `memory/projects/universal-core/the vault that is not there/proposal.md`.
  Candidate for upstream. #propagate:07-09-2026
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

- **The catalogue is a form now, and the second post has never been filled.** `posts/steward.md`
  reads `verified: not yet held anywhere`, which is true and is the honest state: no copy exists.
  The first copy that adopts it fills its own `memory/posts/steward.md`, and what that agent
  learns about holding it is what would earn a change to the definition. Nothing to do until then.
  #propagate:07-09-2026

- **Run the weekly guard once, end to end, and publish the report.** Wired since 14-08-2026 and it
  has never produced one. A schedule with no output is indistinguishable from a schedule that
  never fired. The five steps are in `memory/projects/custodian/the weekly guard/`, with step 4
  marked as the fiction it is until `tools/challenge.sh` exists or the step goes.

- **`sweep-branches.yml` should say that it runs the pushed tool.** Its retire mode checks out the
  branch named in `against` and runs that branch's copy of `tools/sweep-branches.sh`. On 07-09-2026
  two dispatches ran the ordinary sweep and reported success, because the branch had been synced
  and not pushed and the older tool ignored an argument it did not know. A green check on a run
  that did the wrong work. One comment in the workflow, batched into the next release.
  Candidate for upstream. #propagate:07-09-2026

- **The post has no function for teaching, and the header found it on day one.** `posts/custodian.md`
  carries *duty to the contributor* and the charter's third role was teacher, but the catalogue has
  six functions and none of them covers explaining the system to somebody using it. The Principal
  asked where to open a chat on 08-09-2026 and the honest header was `custodian/no function
  declared`. Either a function joins the catalogue or the post stops claiming the duty. The gate
  working is what made the gap visible rather than tolerable. Candidate for upstream.
  #propagate:08-09-2026

## Principal

- **Hand the copy its one file** — *quarantined 08-09-2026, waiting on a receipt.*
  `memory/quarantine/the-funding-arrangement.md` says what it is, where it goes, and carries an
  unsigned `received:` line. The copy's agent records the commitment in its own `state.md` and
  signs. Until then `tools/hygiene.sh` names it at every session start, and nobody deletes it.
  The custodian post does not reach into another repository, so the signature is the only thing
  that can end the wait. Original item: The Principal named it privately on 03-09-2026 and this is a
  public repository, so it is not written here. The copy's agent takes
  `memory/projects/custodian/what belongs in the copy/handover to the copy.md` as a brief: the
  funding commitment moves there and nothing else does. This agent does not write into another
  repository, so the last step belongs to that agent in a session of its own.
- ~~**An unlisted model is acting as the Custodian.**~~ **Decided and built 07-09-2026.** Opus
  holds this post, by the Principal's approval, and `tools/models.sh` shipped in 1.72.0. Original
  finding: `memory/state.md` says `MODELS.md` on `main` names the approved models and
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
