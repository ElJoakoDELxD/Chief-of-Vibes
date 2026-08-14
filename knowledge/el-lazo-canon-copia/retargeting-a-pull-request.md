---
topic: Re-pointing a pull request's base leaves the old check standing
updated: 09-08-2026 17:4x -04
verified: 09-08-2026. Read `.github/workflows/guard.yml` in this repository. Its trigger is `on: pull_request:` with no `types:` list, so it uses GitHub's default activity types — opened, synchronize, reopened. A base change emits `edited`, which is not among them
---

# Re-pointing a pull request leaves the old check in place

## The trap

A hand-chained pull request targets the layer below it. Before the merge, the base is
re-pointed at `main`. The checks still show green. Those checks ran against the **old**
base.

The guard does not re-run, because it never hears about the change:

```yaml
on:
  pull_request:
    branches: [main, 'claude/**']
```

No `types:` list means the default set: `opened`, `synchronize`, `reopened`. Changing a
base emits `edited`, which is not in that set.

So the green tick answers a question nobody is asking now. The reviewer sees the diff
against `main`. No check has looked at it.

## What to do

Move the head, which the default set does hear:

```
git commit --allow-empty -m "Re-run checks against the new base"
git push
```

`synchronize` fires. The guard runs against the base that will merge.

## The other fix, and its cost

You can add `edited` to `types:`. Then the workflow also fires on every title and body
edit, because `edited` covers all of them. That is many runs for one real case. Use the
empty commit unless base changes become routine.

## The general shape

**A check is only as current as the event that started it.** When the base or the merge
target changes, ask which event that emitted. Then ask whether the workflow listens for
it. A green tick names one commit and one base. It does not promise that the pair is the
one about to merge.
