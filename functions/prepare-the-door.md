---
function: Prepare the door
verified: exercised through a run of releases
---

# Prepare the door

Measure a change bound for `main` against every mechanical bar, and report what was found.

## What it does

1. Run every bench, `tools/index.sh --check`, and `tools/sections.sh --check`.
2. Run `tools/pr-guard.sh` from the branch holding the post, against the two refs. The marker is
   on disk there, so the version question can be asked (§6).
3. Read `tools/prose-gate.sh` and quote the score.
4. Read the diff against the membership test: does a fresh copy need this to become itself?
5. Open the pull request, with every number from a call made in that session.

## What it never does

**It never merges.** A change that clears every bar is pre-approved in the only sense a machine
can mean, which is that nothing measurable is outstanding. The merge belongs to a person (§6).

## Why it is a function and not a habit

A door prepared differently each time teaches nobody what the bar is. The steps above are the
bar, and a proposal that skipped one says so.
