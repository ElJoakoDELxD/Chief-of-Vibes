---
name: principal-approves
invocation: both
summary: Land an approved change everywhere it belongs — one approval, not one per hop.
description: Carry out a Principal's approval to completion. Use the moment they approve, agree, say to merge it, say principal approves, or otherwise clear a change to land — and use it on the whole change rather than the pull request in front of you, because an approval that produces another approval request has not been carried out. Also use when an approval was given earlier and part of it is still sitting unlanded.
---

# principal-approves

Rides SYSTEM.md §3: *act, don't queue* — the approval is theirs, the labour never was · *verify before assert* · *done is earned by verification*.

## What an approval actually covers

**The change, everywhere it has to go. Not the pull request in front of you.**

A template change is not finished when it merges into the canon; it is finished when it governs the repository the agent works in (§6). So one approval carries the whole path: the canon merge, the copy's sync pull request, that merge, `tools/sync.sh` onto the agent branch, and the check that the two versions match.

Coming back to ask again at each hop splits one decision into four requests. The Principal decided once; the rest is labour, and labour was never theirs (§3). An approval that produces another approval request has not been carried out — it has been acknowledged.

What genuinely needs a fresh approval is a **different change**: something they have not seen. When in doubt, the test is whether the thing about to be asked was inside what they approved. If it was, do it.

## Before anything lands

**Never merge red, and never merge unread.** Check the CI state of every pull request in scope — not the one you remember, the one the API returns this turn. A check that failed for a reason unrelated to the change is still a finding: say what it was, then proceed or stop, but do not let silence do it.

## The shape decides the method

Getting this wrong costs a rebuild, so read the chain before touching it.

| Shape | How it lands |
|---|---|
| **One pull request** | merge it |
| **Hand-chained** — each layer targeting the one below | merge the **top** layer; its branch already contains every layer under it, so they land together |
| **A registered stack** | the async merge endpoint — the ordinary merge endpoint refuses, and the layers above re-target themselves once the bottom lands |

**Not with a squash, in any chained shape.** A squash writes new history onto the base while the layers above still carry the original commits, so the automatic re-target succeeds and the content conflicts. The recovery is a rebase per layer — cheap to avoid, tedious to undo.

## After the merge, the intermediates

A chained merge leaves the lower pull requests open with nothing left to merge; GitHub refuses to re-target them, because the base already contains their commits.

Close them **with a line saying why**. A bare *closed* reads as rejected to anyone who finds it later, and the bodies are the record of what each change was and why. This costs one comment each and keeps the history honest (§7 — where the mechanics change what the record appears to say, the agent says so plainly).

## Then the copy, without being asked again

The canon moving means every copy is behind by construction, and a copy on an older specification is an agent obeying superseded rules with the old rails wired in (§6). So the same approval continues: open the sync pull request, land it, run `tools/sync.sh` on the agent branch, and verify both sides report the same version by reading them, not by assuming the merge did it.

If the Principal has to ask *"did that reach my copy?"*, the approval was carried out halfway.

## Report

What landed, each claim from a call made this turn: the versions on both sides, what is now in force that was not, and anything still open **with whose it is**. If something in scope did not land, say which and why — an approval reported as complete while a piece of it sits unmerged is the failure this skill exists to end.
