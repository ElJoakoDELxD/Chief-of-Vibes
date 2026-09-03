# Backlog

What gets done. What was already done lives in the journal, not here.

## Agent

- ~~**Prepare the door on pull request #75.**~~ **Merged 03-09-2026 as `6a0b4fb`**, on the
  Principal's approval. The canon is at 1.63.0 and this branch is synced to it.

- ~~**Prepare the release that cleans `knowledge/`.**~~ **Opened 03-09-2026 as pull request
  #76**, version 1.64.0. It turned out smaller and sharper than sized: §7 already forbade the
  real name, the offsets and the private repository names, so most of the release is instances
  of a rule that existed rather than a rule that was missing. What is new is the quotation
  clause and the one about a sweep reading metadata.

- **Delete the merged branch `custodio/la-salida-de-main`.** §6 says the branch list is live
  work and not a graveyard. Tried: the permission classifier refused the deletion as
  destructive. It is a one-click delete on the pull request page, or one word here.

- **Write `MODELS.md` and `tools/models.sh`, and open the pull request.** The identity file has
  named both since 15-08-2026 and neither exists. A paragraph describing a control that is not
  built reads as a rail to the next session, which is worse than no paragraph. This is the
  agent's own work up to the pull request; only the merge is the Principal's.

- **Decide what `tools/challenge.sh` is, or delete the reference.** The weekly-guard note on
  `Chief-of-Vibes-Agent` gives it a step of its own — read the attempt log, move the difficulty
  on the record. The tool does not exist. Either it gets built or step 4 of that guard is
  fiction.

- **Run the weekly guard once, end to end, and publish the report.** It has been wired since
  14-08-2026 and has never produced one. A schedule with no output is indistinguishable from a
  schedule that never fired. The five steps are in
  `memory/projects/custodian/the weekly guard/`, with step 4 marked as the fiction it is.

- **Run the weekly guard once, end to end, and publish the report.** It has been wired since
  14-08-2026 and has never produced one. A schedule with no output is indistinguishable from a
  schedule that never fired. The five steps are in
  `memory/projects/custodian/the weekly guard/`, with step 4 marked as the fiction it is.

- **Prepare the release that cleans `knowledge/`: the location, and the language.** Two
  findings, one file set, one release.

  *The location.* Four entries carry a `-04` offset, which is a longitude, inherited by every
  copy that ever syncs. `CLOCKS.md` forbids exactly this about itself. Fix: `updated:` drops to
  the date alone, in the §5 template block and in the four entries.

  *The language.* The canon writes in English, everywhere, with the README translation the one
  exception (Principal, 03-09-2026 — see `memory/corrections.md`). Fix: rename
  `knowledge/el-entorno/` and `knowledge/el-lazo-canon-copia/`, rename the Spanish fixture path
  in `tools/test-hygiene.sh`, and **write the rule down**, because a rename with no rule gets
  undone by the next entry. Nothing links to either folder.

  *The quotation, and it is the urgent one.* `.claude/skills/propagate/SKILL.md` carries the
  **Principal's real first name** as its example of identity, inside the rule that says to drop
  identity, inherited by every copy that ever syncs. `.claude/skills/orchestrate/SKILL.md`
  carries a dated quotation of the Principal. Both are deleted, not rewritten, and the rule goes
  in with them: the Custodian allows no quotation from people, and a person's words in a canon
  file are a privacy leak.

  *The handle.* `CONTRIBUTING.md` uses the full `owner/repo` path in a shell example and in a
  pull-request link. Both become a placeholder and a relative link. `.canon` and `LICENSE` are
  not this agent's to change, and the README's onboarding URL cannot lose the owner while the
  repository lives where it does. All three are under **Principal** below.

  Together: two lines of specification, five of content, two renames, a version bump, three
  documents in step. Sized in `memory/projects/custodian/what belongs in the copy/`.
  **Held until #75 lands**, by the Principal's decision on 03-09-2026, and one word reopens
  that: the language half is a correction and not a finding, and corrections are not usually
  things to keep waiting.

## Principal

- **Retire `Chief-of-Vibes-Agent`.** It holds the 14-08-2026 identity and nothing else, and this
  branch now supersedes it. Two branches carrying a `state.md` for the same agent is the drift §5
  calls a second memory going out of sync. Deleting a branch is a decision about this repository's
  shape, so it is yours. Tried: nothing — no attempt is owed, because the block is authority and
  not capability.

- **Hand the copy its one file.** The Principal named it privately on 03-09-2026, and this is a
  public repository, so it is not written down here. Its
  agent takes `memory/projects/custodian/what belongs in the copy/handover to the copy.md` as
  a brief: the funding commitment moves there, and nothing else does. This agent does not write
  into another repository (`state.md`), so the last step belongs to the copy's agent in a
  session of its own.

- **Merge or reject #76.** Opened today, 1.64.0, CI running at the time of writing. Prepared by
  this agent; the merge is yours (§6).

- **Authorise the history rewrite that removes a personal address from four commits.** On
  03-09-2026 this agent authored four commits under the Principal's personal email, taken from the
  session context. Every commit after 16:44 uses the noreply identity the repository's history
  already used, so the leak stopped, and those four are pushed to a public repository. Removing
  them rewrites the branch and force-pushes it: content identical, author header changed. Tried:
  the permission classifier refused it, correctly, since a rewrite is destructive and not the
  agent's call. One word authorises it.

  A rewrite removes the address from the branch, and GitHub can still serve the old objects by
  direct SHA for a while, so asking GitHub support to purge them is what finishes the job.

- **Build the rail that pins the commit author email.** A commit whose author email differs from
  the configured global identity is refused; the name stays free, because authoring as `Custodian`
  is deliberate and current. It compares the result rather than the invocation, so no list of
  forbidden flags can be evaded by a different spelling. Bench: email override blocked, name
  override untouched, plain commit untouched. Sized by the 5S tree run of 03-09-2026 and held
  until #76 lands.

- **The history rewrite must not depend on `scratchpad/reauthor.sh`.** That script is the
  remediation for the four leaking commits and it sits on a filesystem that does not survive the
  session. Whichever session does the rewrite writes its own; this one is not a handoff.

- ~~**Decide the three handle sites.**~~ **Withdrawn 03-09-2026 — this was never yours to
  decide.** §7 already states the exception: a public handle and the licence copyright are
  already public and identify ownership. `.canon`, `LICENSE` and the onboarding URL are the rule
  working, not three gaps in it. This agent read §7 an hour after raising them and found the
  answer already written. Moving the repository under an organisation remains an option, and it
  is a preference rather than a defect.
