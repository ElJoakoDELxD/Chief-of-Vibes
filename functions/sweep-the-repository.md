---
function: Sweep the repository
verified: exercised, reducing a branch list to what was still live
---

# Sweep the repository

Remove what is finished, and keep what is not.

## What it does

1. `bash tools/sweep-branches.sh <remote>` reports what `main` already contains.
2. Read the report before acting. Re-run with `--delete` once it is read.
3. Run `bash tools/hygiene.sh` and act on what it names.

## The rule it obeys

A branch goes only when `main` contains its tip, so deleting the ref loses a name and no commit,
and never when it carries a `memory/state.md`. **Containment is re-tested at the moment of
deletion**, because a list is true when it is written and not when it runs.
