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
  (`memory/projects/universal-core/canon-identity/custodian-verdict.md`). Candidate for upstream.
- **The pointer is stale by one hop from the second copy onward, and the hard fork blinds
  itself.** `.canon` holds one slug for two facts — where syncs come from, and where proposals
  go. A copy of a copy inherits the root's slug and syncs against the wrong repository; a fork
  that edits the line matches its own origin, so `anchor.sh` skips the drift check and reports
  parity forever (§1 promises silence means parity, so that reading is fabricated). Planned,
  unimplemented: a second file `.upstream` holds the parent, written once by onboarding and never
  shipped by the canon, while `.canon` keeps the root unchanged. Full plan in
  `memory/projects/universal-core/canon-identity/plan-lineage.md`. Waiting on the Principal's go.
  Candidate for upstream.
- **The role is declared where nothing reads it, and a branch does not say what kind it is.**
  §5 closes `state.md`'s frontmatter — *all of it* — at agent, principal, language, timezone,
  goal, branch, created. There is no `role`, so every constraint in the Custodian's identity file
  (never merge, never touch another repository, never publish outward, only approved models) is
  held by the agent remembering to read its own prose. Rung 5.

  The Principal's question of 07-09-2026 — *where does the Custodian work* — sharpened it. There
  are **three kinds of branch**, not two: `main`, the template; a **memory** branch, permanent,
  carrying `memory/`; and a **work** branch, disposable, carrying one change to template files
  and deleted when its pull request lands (§6). The Custodian's memory is `Custodian`; its work
  was `custodio/la-salida-de-main` and `custodian/the-canon-quotes-no-one`.

  Two things follow. The `role:` field should say what the **branch** is for, not only which
  agent sits on it. And a cheap rail falls out: **editing a template file on a branch that
  carries `state.md` is almost always a mistake**, because the next `tools/sync.sh` reverses it
  and only says so afterwards. This session did exactly that with the `test-now.sh` fix. A
  PreToolUse warning catches it before the loss; it warns rather than blocks, since the agent's
  own `README.md` is a legitimate exception `sync.sh` already carves out.

  **Superseded in shape by the Principal's correction of 07-09-2026**: Custodian is a role, not
  an agent, and Chief of Vibes is the only agent with access to it. So the field is `roles:`, the
  set an agent may assume, and a session declares which one it acts in — not `role:` as a property
  of a branch. See `memory/projects/universal-core/canon-identity/role-is-not-agent.md`.

  Prerequisite for an instance generating its own custodian. A second plan, not part of
  `plan-lineage.md`. Candidate for upstream.
- **Nothing detects an unsynced agent branch.** The session-start drift check covers hop one,
  canon into a copy's `main`. On the canon it is skipped by construction — the canon cannot drift
  from itself — so this repository has no version sensor on the branch where all its work happens.
  §6 says drift on hop two *cannot happen* because the hop is a merge, which is only true once
  somebody runs `tools/sync.sh`. On 06-09-2026 this branch was at 1.62.0 against main's 1.64.0,
  four commits behind, and a whole plan was written against the stale tree before an unrelated
  question surfaced it. Synced. The sensor is still missing. Candidate for upstream.
- **`tools/test-now.sh` pinned a wall-clock offset and expired.** It asserted `-04` for
  `America/Santiago`, which is right in winter and wrong under daylight saving. Chile moved its
  clocks on 06-09-2026 and the bench went red with `now.sh` behaving correctly throughout. Fixed
  by resolving the offset at run time from `date`, the independent oracle. ~~Prepare the door.~~
  **Merged 07-09-2026 as `8014ab7`, version 1.65.0, on the Principal's approval.** Synced onto this
  branch; both sides read 1.65.0 and 15 benches are green.

- **A stranger on the canon is offered the canon's own agent.** In `.claude/hooks/anchor.sh` the
  continuation line is appended after all three menu branches without regard to which one fired,
  so the canon menu reads *no agent is created here and no work lands here* and then *existing
  agent branches to offer continuing first: `Chief-of-Vibes-Agent`, `Custodian`*, closing with
  *act on evident intent without re-asking* — which tells the session to check one out. The list
  is right for a copy, where the Principal is returning to their own agent.

  On the canon it is wrong for a reason the identity file already states: **the agent there is the
  demo**. It is what a newcomer meets, and it runs at the full capability of anything built on this
  template, which is the whole point of showing it. Meeting it is correct. Being offered it *for
  continuation* is not — that turns an exhibit into a stranger's workspace, and *act on evident
  intent without re-asking* is what carries the session across. Nothing is created on the canon;
  one agent already stands there, holding the custodian role and serving as the demonstration.

  Fix: on the canon, name the agent as the demo and leave it readable, offer the copy and the pull
  request, and never offer continuation. The principle is in
  `memory/projects/universal-core/canon-identity/the-custodian-role.md`: the canon is everyone's
  workspace and everyone reaches it through the same door, so a visitor is given the two ways in
  rather than the keys to the agent standing there. Found 07-09-2026. Candidate for upstream.

- **Complete the vault, and give the role a home.** §5 draws a tree that onboarding only partly
  builds. `memory/projects/` is required by §5 and §9 before anything creates it; `projects/`,
  the deliverables tree, is named twice in the specification and built by nothing;
  `memory/corrections.md` is absent by a sound argument whose hole is that nothing tells a session
  the file may exist. And the custodian charter sits in memory, where a copy cannot inherit it.
  Proposal, measured and unimplemented, in
  `memory/projects/universal-core/the vault that is not there/proposal.md`. Candidate for upstream.
- **Posts authorize functions, and the header carries both.** The Principal's correction of
  07-09-2026 splits the word *role*: an agent **holds a post**, a post **authorizes functions**,
  and a session exercises one. What it buys is a sentence a hook can enforce — a function no post
  authorizes cannot be exercised. `posts/<post>.md` beside `knowledge/`, `posts:` in `state.md`,
  and the header gains agent and post/function. **Two directories**: `functions/` holds the
  bodies, written once for everybody, and `posts/` references them and carries what is true of
  the holder. A post never names an agent — `state.md` does — because a post file is inherited by
  every copy. The Custodian post authorizes projects aimed at the template and the canon, and the
  agent may open one on finding a fault. Proposal in
  `memory/projects/universal-core/posts and functions/proposal.md`. One release, not small. Two
  decisions are the Principal's. Candidate for upstream.
- **Write the knowledge entry: a cloud session cannot delete a ref, and a runner is the route.**
  §5 says an entry gets written the first time a procedure is worked out, not later. This session
  spent hours rediscovering something `stacks.yml` and `create-release.yml` had already solved,
  and their header comments were the only record. An entry in `knowledge/` on the canon makes the
  pattern findable instead of archaeological: what the git proxy refuses, how it was measured, and
  the runner shape as the answer. Held out of pull request #78 deliberately, because widening a
  pull request under review costs the review. Candidate for upstream.

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
- **Delete thirteen merged branches.** §6 says the branch list is live work, not a graveyard, and
  thirteen branches are contained in `origin/main`, not the three the record named. Every SHA and
  the restore command are in `memory/projects/custodian/the branch graveyard/restore manifest.md`.
  **This agent cannot do it and no setting changes that.** The 403 comes from the git proxy, which
  holds the git credentials outside the sandbox, and it refuses a ref deletion whichever branch is
  checked out. Tested both ways on 07-09-2026. Push and branch creation work in the same session,
  so it is the destructive ref update that is refused, not the credential and not the branch name.
  ~~The remedy is GitHub's own interface or a local session.~~ **A runner is the route**, the same
  shape `stacks.yml` and `create-release.yml` already use. Door prepared 07-09-2026 as pull
  request #78. ~~Once it lands, dispatch it.~~ **Done 07-09-2026 on the Principal's approval.**
  #78 merged as `f11afa4`, version 1.66.0. Dispatched in `report` mode, log read, then `delete`.
  Fourteen deleted and six kept, verified against `git ls-remote`: twenty branches became seven.
  The prediction said thirteen and four; the difference is the sweep's own branch, merged in
  between, and the two memory branches which the count had described separately.
