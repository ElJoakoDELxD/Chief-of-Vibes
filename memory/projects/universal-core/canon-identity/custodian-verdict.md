---
thread: Canon identity
date: 06-09-2026
state: verdict issued on 06-09-2026. The contract is rejected as stated. Two findings kept.
reads: proposal-from-lab.md
---

# Verdict on the laboratory proposal: `.canon` is not what the proposal thinks it is

## The contract, and why it fails

The proposal asks the custodian to accept:

> `.canon` is custodian-only. `Chief-of-Vibes/main` does not ship it. Onboarding generates an
> instance-scoped identity record from actual Git origin and current branch, under another name.

**Rejected.** The premise is a misreading of the file.

`.canon` holds one line — `ElJoakoDELxD/Chief-of-Vibes` — and it is a **pointer to upstream**,
not a claim of custody. Its semantics are *the canon is over there*, so a copy that inherits it
does not inherit a false claim. It inherits the only thing that lets the copy learn it is a
copy: one side of a comparison whose other side is its own `origin`. §6 states it and the README
states the exit — *if you ever want to leave, edit one line*. Editing it is how a hard fork
declares a new canon. That is a pointer's behaviour, not an identity card's.

So the proposal's "observed failure" — *a copied canonical marker becomes misleading* — inverts
the mechanism. Copying it is what makes the answer true.

## What removing it from `main` actually does

Traced through the consumers the proposal names.

1. **`.claude/hooks/anchor.sh`, canon-or-copy.** Empty `canon_slug` takes the *undetermined*
   branch. Every fresh copy would open every agentless session asking which repository it is
   in — the question the file exists to answer. Onboard step 0 loses its input.
2. **The same hook, drift check.** Empty `canon_slug` reports UNAVAILABLE, permanently, in every
   copy. That check is the only thing that tells a copy it is running superseded rules on old
   rails (§6). The proposal lists one-way propagation as a non-goal while deleting the sensor
   that watches it.
3. **`tools/pr-guard.sh`.** Empty `.canon` gives `is_canon=0`, and the guard then prints *a copy
   does not carry the master version; no bump required* — **on the canon**. The release-version
   rail disappears silently. That is a fail-**open**, and it contradicts the proposal's own
   acceptance tests 5 and 7.

The lab evidence does not reach this. Removing the file and confirming through GitHub that it is
gone tests the deletion, not the system without it. The acceptance test that would matter —
*a fresh copy with no `.canon` still knows it is a copy* — cannot pass, by construction.

## The proposed replacement duplicates what already exists

The record it wants written is `role`, `repository`, `branch`, `upstream`.

- `repository` and `branch` are ground truth in git. §6: *`git branch --show-current` is ground
  truth, and a document naming a different branch is stale.* The proposal writes to a file the
  two facts the specification names as the ones never to write down. It goes stale on a rename,
  a transfer, or a second branch.
- `upstream` is `.canon`, renamed.
- `role` is `memory/state.md`, which already carries agent, branch, goal and language.

Three fields already held, one of them held better.

## What survives

One thing, and it is smaller than the proposal but real.

**The name misleads a careful reader.** A file called `.canon` reads as *this is the canon* to
someone who has not read §6, and that is exactly the error the lab made. That is a naming
defect, not an architecture defect. A rename is not the remedy: the string is wired into the
hook, the guard, two benches, §6, the README, CONTRIBUTING and `repomix.config.json`, and it is
inherited by every existing copy, so renaming it is a migration for repositories this repository
does not own. The cheap fix is to make the file say what it points at.

Which surfaced the second finding, below.

## Finding: two consumers parse `.canon` differently

- `anchor.sh` reads `head -n1`.
- `pr-guard.sh` reads `tr -d '[:space:]' < .canon` — the **whole file**.

They agree today only because the file is one line. Add a comment line to make the pointer
self-describing, which is the fix the paragraph above asks for, and `pr-guard` concatenates both
lines, matches nothing, sets `is_canon=0`, and drops the version rail on the canon without a
word. The safe fix is not available until the parsers agree.

This is the finding worth keeping from the whole exchange, and the proposal did not contain it.
It was found by tracing the consumers the proposal asked to be traced.

## Answer to the question the proposal asked well

> Does each consumer need canonical identity, or only the current instance's repository/branch
> and role?

Neither. Every consumer needs the **comparison**. The local side already comes from git, so the
file must carry the remote side and nothing else. That is what it does, in one line.

## Standing

A verdict is a recommendation and never permission (§6). Nothing here merges anything.
