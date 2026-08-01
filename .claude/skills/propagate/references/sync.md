# propagate · sync

Direction: the canon → this copy's `main` → the agent branch. §6 specifies this; what follows is the execution and the traps that are not in the specification because they are environmental.

## Why it is urgent rather than tidy

A copy on an older specification is an agent obeying superseded rules **with the old rails wired in**, and nothing looks wrong from inside: the guard that fires is the old guard, and the limit written upstream last week is simply absent. The drift check reports the gap at session start, and closing it comes before substantive work, not after (§6).

Say the gap to the Principal before working. If the check itself failed, say that — silence reads as parity, and that is the one reading that must never be wrong by default.

## First hop: canon → this copy's `main`

**Use this template leaves an unrelated history.** There is no *Sync fork* button and there will not be one; looking for it is the first wasted step. The agent opens a pull request bringing the canon's template across wholesale. Unrelated histories need `--allow-unrelated-histories` on the merge that builds that branch.

This hop is the **agent's job** — §6 says so explicitly, and §3 makes it a misfiling to put it in the Principal's backlog: it is a pull request the agent can open. Only the merge is theirs.

Template paths only. `memory/` and `projects/` never go to `main`; `knowledge/` is this copy's and does not come from the canon.

## Second hop: `main` → the agent branch

    bash tools/sync.sh

From the agent branch, with a clean tree. It merges rather than cherry-picks on purpose — the branch *becomes* `main` plus `memory/` and `projects/`, and git carries each conflict resolution forward through the merge base, so a settled conflict stays settled. It is safe to re-run and says so when there is nothing to do.

Conflicts resolve without prompting: template files take `main`'s version, the agent branch's own `README.md` keeps the agent's. Both outcomes print, and an overwritten template file is named — that naming is the signal that the branch had edited something it does not own. Anything the rule does not cover stops the script, and a stopped script is a finding, not an error to retry past.

## After

Tell the Principal what changed in plain language — which rules are new, which rails now fire, what is now blocked that was not. A sync reported as "synced" is a §3 *involve and teach* failure: they are running under new rules and did not read the diff.

## Traps

- **Running the old tooling.** The sync is performed by the copy's current `tools/sync.sh`, which is the *old* one until the first hop lands. If the canon changed the sync itself, the first hop must merge before the second runs.
- **Syncing onto a chat's disposable branch.** It goes onto the agent branch. A template merged into scaffolding is discarded with the scaffolding.
- **Declaring parity from the version string alone.** The version says what release the file claims to be; a copy that edited a template file locally is at that version and still divergent. `git diff` against the canon's tree is the check.
