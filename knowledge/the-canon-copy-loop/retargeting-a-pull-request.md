---
topic: Re-pointing a pull request's base leaves the old check standing
verified: GitHub's default activity types for `pull_request` are opened, synchronize and reopened. Changing a base emits `edited`, which is not among them. Measured twice: a note recording it, and a stack whose retargeted layers started no run until their heads moved
---

# Re-pointing a pull request leaves the old check in place

## The trap

A hand-chained pull request targets the layer below it. Before the merge, the base is
re-pointed at the default branch. The checks still show green. Those checks ran against
the **old** base.

The workflow does not re-run, because it never hears about the change. A `pull_request:`
trigger with no `types:` list uses GitHub's default set — `opened`, `synchronize`,
`reopened`. Changing a base emits `edited`, which is not in that set.

So the green tick answers a question nobody is asking now. The reviewer sees the diff
against the new base. No check has looked at it.

## What to do

**Update the branch from its base.** That produces a merge commit on the head, which emits
`synchronize`, and the workflow runs against the base that will merge. It is also a real
commit: bringing the base in is ordinary practice, and the checks then judge the tree that
will actually land.

An empty commit does the same thing mechanically and must not be used. A commit that
exists only to restart a check is the reflex this system refuses, and the same is true of
closing and reopening the pull request.

## The other fix, and what it costs

Adding `edited` to `types:` makes the workflow hear the base change directly. The cost is
that `edited` also covers title and body edits, so a description improved three times is
three more runs.

That cost is worth paying where a base change is not rare. A trigger that stays silent on
a retarget is a check that reports on a diff nobody is merging, and a wrong green is more
expensive than a redundant run.

## The general shape

**A check is only as current as the event that started it.** When the base or the merge
target changes, ask which event that emitted, then ask whether the workflow listens for
it. A green tick names one commit and one base. It does not promise that the pair is the
one about to merge.

## Why this note holds no template file

An earlier version quoted a trigger out of the workflow file beside it. That made the note a
second copy of a file, and it went stale the day the file changed. What belongs here is the
platform's behaviour, which no release can alter. Read the workflow for what the workflow
says.
