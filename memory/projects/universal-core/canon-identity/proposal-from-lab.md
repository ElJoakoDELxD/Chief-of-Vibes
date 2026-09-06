# Proposal from laboratory: `.canon` is custodian-only; instances generate their own identity

## Destination

`Chief-of-Vibes`, branch `Chief-of-Vibes-Agent`.

This proposal comes from the private laboratory `fantastic-palm-tree`. It is written so the custodian can evaluate the idea without accessing the laboratory.

## Core idea

`.canon` should remain the identity marker of the **custodian only**.

The distributed template on `Chief-of-Vibes/main` should not contain `.canon`, because the template is copied into products and a copied canonical marker becomes misleading.

When a person uses the product to create its own repository and working branch, the product should deterministically generate a **different, explicitly instance-scoped identity file** for that new repository+branch. It should not be called `.canon`.

Conceptually:

```text
Chief-of-Vibes/main
    = template
    = no `.canon`

Chief-of-Vibes#Chief-of-Vibes-Agent
    = custodian
    = `.canon` allowed/owned here

<derived-repository>#<derived-branch>
    = instance
    = generated instance identity, not `.canon`
```

## Invariant

There are two separate facts:

1. **Custodian identity:** the canonical repository+branch that has custody.
2. **Instance identity:** the repository+branch created for a particular product.

`.canon` represents the first. The generated instance identity represents the second.

Upstream lineage, if recorded, is a third fact: it says where the instance came from or which upstream branch it follows. It does not make the instance canonical.

## Observed failure

The current `.canon` file is distributed with the template and records only `owner/repo`. Because it is copied, an instance inherits a file whose semantics belong to the upstream custodian rather than to the instance itself.

The real architecture already distinguishes the roles by branch: the template repository is `Chief-of-Vibes`, while the custodian is the `Chief-of-Vibes-Agent` branch inside that repository. The custodian branch also declares its own role in `memory/state.md`.

Therefore the primary problem is not that `.canon` exists. The problem is that a custodian-only marker is currently treated as if it were template-owned distributable metadata.

## Proposed contract

### A. `.canon`

`.canon` remains valid only as a custodian-local marker.

For the current canon, the expected identity is:

`ElJoakoDELxD/Chief-of-Vibes#Chief-of-Vibes-Agent`

The runtime can continue to use `.canon` where it needs to protect canonical operations, provided it validates the actual repository and current branch rather than trusting the file in isolation.

`.canon` is therefore **not template data** and must not be used as the instance identity format.

### B. `main` / template

`Chief-of-Vibes/main` contains no `.canon`.

The absence of `.canon` on the template is intentional and normal.

The template does not need a copied canonical identity marker.

### C. Instance identity

During onboarding, after the product's repository and branch have been created, derive:

```text
actual origin repository
actual current branch
```

and generate an instance-scoped record such as:

```text
role=instance
repository=<actual-origin-repository>
branch=<actual-current-branch>
upstream=ElJoakoDELxD/Chief-of-Vibes#Chief-of-Vibes-Agent
```

The implementation should obtain `repository` and `branch` from Git itself. It should not construct them from the agent's chosen display name.

The generated file is an identity record for the instance, not a claim of canonical custody.

## Minimal-change hypothesis

Before redesigning the identity architecture broadly, the custodian should test whether the above contract can be implemented with a small change set:

1. Remove `.canon` from `main` so new instances do not inherit it.
2. Keep `.canon` on `Chief-of-Vibes-Agent`.
3. Make onboarding generate the new instance identity once the repository+branch exist.
4. Adjust only the existing consumers that currently assume every checkout must contain `.canon`.
5. Keep existing synchronization, PR, approval, memory, and safety contracts otherwise unchanged.

The previous laboratory proposal listed many files as likely needing coordinated edits. This revised proposal deliberately changes that to a **test the minimum necessary surface first** approach.

## What to verify

The custodian should trace current `.canon` consumers, especially:

- `.claude/hooks/anchor.sh`
- `.claude/skills/onboard/SKILL.md`
- `tools/pr-guard.sh`
- `SYSTEM.md`
- `system/6-repositories-and-branches.md`
- `README.md`
- `CONTRIBUTING.md`
- `repomix.config.json`
- `tools/test-anchor.sh`
- `tools/test-pr-guard.sh`

But these are inspection targets, not a demand to rewrite all of them.

The key test is whether each consumer actually needs canonical identity, or only needs to know the current instance's repository/branch and role.

## Acceptance tests

The canonical benches should prove:

1. `Chief-of-Vibes#Chief-of-Vibes-Agent` with valid custodian identity is recognized as the custodian.
2. `Chief-of-Vibes#main` without `.canon` is recognized as the template, not as the custodian.
3. A newly initialized derived repository+branch receives an instance identity generated from actual Git state.
4. An instance that records `upstream=ElJoakoDELxD/Chief-of-Vibes#Chief-of-Vibes-Agent` remains an instance.
5. Missing or contradictory identity information fails closed rather than guessing.
6. A fresh copy of `Chief-of-Vibes/main` does not contain `.canon`.
7. Existing PR/sync safety behavior remains intact.

## Laboratory evidence

In the private laboratory:

- `.canon` was removed from the working instance branch and its absence was verified through GitHub.
- A prototype was built to distinguish repository+branch identities and to fail closed for missing identity data.
- The real `Chief-of-Vibes-Agent` branch was independently checked and its state declares the `Custodian` role and `Chief-of-Vibes-Agent` branch.

These are evidence for the proposal, not a request to copy the laboratory implementation into canon.

## Non-goals

This proposal does not ask to change:

- custodian authority;
- merge rights;
- runtime approval requirements;
- memory architecture;
- the one-way template propagation model;
- unrelated runtime adapters.

It also does not require the custodian to access, clone, or inspect the private laboratory.

## Requested action from the custodian

Evaluate this contract first:

> **`.canon` is custodian-only. `Chief-of-Vibes/main` does not ship it. When onboarding creates a product's own repository+branch, the agent deterministically generates an instance-scoped identity record from the actual Git origin and current branch, under a name that is not `.canon`.**

The desired outcome is not a broad identity rewrite. It is to establish whether this separation can be implemented safely and deterministically with the smallest possible change to the existing system.
