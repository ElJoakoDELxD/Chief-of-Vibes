---
function: Sync the template
verified: run on the canon's agent branch through releases 1.63.0 to 1.68.0
---

# Sync the template

Bring the template from `main` onto the branch that holds the post, and say what changed.

## What it does

1. `git fetch origin main`, then `bash tools/sync.sh`.
2. Read both versions afterwards rather than assuming the merge did it.
3. Tell the Principal what changed, in plain language.

## What it is for

A branch on an older specification obeys superseded rules with the old rails wired in, and
nothing looks wrong. Closing that gap comes before substantive work rather than after (§6).
