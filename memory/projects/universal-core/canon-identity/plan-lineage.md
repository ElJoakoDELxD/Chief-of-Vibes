---
thread: Canon identity
date: 06-09-2026
state: plan written 06-09-2026, unimplemented. Awaiting the Principal's go.
reads: proposal-from-lab.md, custodian-verdict.md
role: planner (orchestrate gear two). The executor reads this file, not the conversation.
---

# Plan: the root is inherited, the parent is generated

## The correction that produced this shape

Last reading proposed one file with two keys, `root` and `upstream`. **That design is wrong and
this plan abandons it.** The first hop — canon into a copy's `main`, by *Sync fork* or by the
wholesale template pull request — takes the canon's version of every template file. A copy-local
key inside a template file is overwritten on the first sync after it is written. The fact that
must not be inherited cannot live in a file the template ships.

So the conflation is fixed by **adding a second file**, not by widening the first.

| File | Holds | Travels | Written by |
|---|---|---|---|
| `.canon` | the **root**: where proposals go, and which repository is nobody's workspace | inherited unchanged, as today | the template; onboarding only on a deliberate fork |
| `.upstream` | the **parent**: where this copy's template came from | **never shipped by the canon** | onboarding, once, from real state |

**The rule that carries the whole design: `.upstream` present means this repository is derived,
whatever `.canon` says.** Absent means a true root. That single condition fixes both defects and
needs no new parsing of `.canon`.

`.canon` does not change, is not renamed, and no existing copy needs migrating. The parser split
(`head -n1` against whole-file) stays a real bug and a backlog item, and it is **off this plan's
critical path** because `.canon` stays one line.

## What this fixes, stated as the failures it removes

1. **Generation two syncs against the wrong repository.** Bruno copies Ana; his inherited
   `.canon` names the root, so his drift check measures him against the root while his template
   comes from Ana. With `.upstream=ana/her-repo` the check measures the hop that exists.
2. **A fork blinds itself.** Ana edits `.canon` to her own slug, her `origin` matches it, and
   `anchor.sh:112` skips the drift check — *the canon cannot drift from itself* — reporting
   parity forever while §1 promises silence means parity. With `.upstream` still naming the real
   canon, the check runs and Ana keeps seeing root releases.
3. **A fork is evicted from its own repository.** The same match makes the agentless menu say
   *no agent is created here and no work lands here*. Gated on `.upstream` being absent, Ana gets
   the copy menu, because she is derived and a root at the same time.

## The Principal's correction, and where it lands

> The README does not change one line. It describes itself. That is what onboarding is for.

Taken. **Identity is written by onboarding and by nothing else.** The README stops teaching a
manual edit and describes the mechanism instead. Becoming your own home is a step of the skill,
re-runnable like every other step, not a file a person opens.

## Changes, by path

Nothing here is implemented. Every path is a file the executor edits.

### Mechanism

1. **`.claude/hooks/anchor.sh`**
   - Resolve the **effective source**: first line of `.upstream` when the file exists and is
     non-empty, else first line of `.canon`. Fail closed — neither file resolving keeps the
     existing UNAVAILABLE and undetermined wording.
   - Canon-or-copy menu: the canon menu fires only when `origin` matches `.canon` **and no
     `.upstream` exists**. Any repository with `.upstream` gets the copy menu.
   - Drift check: compare against the **effective source**, and skip the check only when `origin`
     matches that source. Today it skips on a `.canon` match.
   - The drift and lead messages name **which repository they compared against**. They say *the
     canon* today, which becomes false for a derived copy, and a message that names the wrong
     repository is the fabricated reading §3 forbids.
2. **`tools/pr-guard.sh`**
   - Add `\.upstream` to the allowed template paths.
   - `is_canon=1` requires the `.canon` match **and** no `.upstream`. Without the second half the
     version rail fires on a fork's own copies.
3. **`tools/sync.sh`**
   - Conflict rule gains a second keep-ours file beside `README.md`: `.upstream` always keeps
     this branch's version. Defensive — the canon ships none — but a fork's copies will carry one
     and the rule must not depend on the canon behaving.
4. **`.claude/skills/onboard/SKILL.md`**
   - New step, after `origin` points at the final repository and before the vault: **write
     `.upstream` on `main`**, one line, `owner/repo`, from real state in this order:
     1. the `origin` the session held **before** it was repointed — the parent is the repository
        the session was standing in;
     2. GitHub's `template_repository` or `parent` for the new repository, where the session can
        read it;
     3. ask the Principal.
     **Never derive it from the agent's name, and never guess.** Unresolvable means ask (§3).
   - Step 0.3's line *`.canon` travels unchanged* gains *and `.upstream` is written here, naming
     the repository this copy came from*.
   - The *Use this template* fallback path writes `.upstream` on `main` in the copy the user
     made. Onboarding commits it there, before any branch protection exists.
   - New re-runnable step, **this copy is its own home**: rewrites `.canon` to this repository
     and **leaves `.upstream` untouched**. That is the fork, and it is a step rather than an edit.

### Specification and prose

5. **`system/6-repositories-and-branches.md`** — the *Which repository am I in?* paragraph splits
   into the two facts and the `.upstream`-present rule. Add the generation paragraph: a copy of a
   copy syncs from its parent and proposes to the root. State the first-hop constraint below.
6. **`SYSTEM.md`** — version to **1.63.0**, plus the §6 summary line and any §1 wording that
   describes the drift check as a comparison against the canon.
7. **`README.md`** — the *edit one line* paragraph is replaced by the mechanism: onboarding
   records where your copy came from, and a step makes your copy its own home. Description, not
   instruction.
8. **`CONTRIBUTING.md`** — the template-file list gains `.upstream`.
9. **`repomix.config.json`** — add `.upstream`.
10. **`INDEX.md`** — regenerated by `tools/index.sh`, never hand-edited.
11. **`.github/release-notes/v1.63.0.md`** — new, title as its first `# ` heading.

### Benches

12. **`tools/test-anchor.sh`** — the fixture carries no `.canon` today and makes no network call.
    Add cases, keeping that property by pointing `CHIEF_CANON_REMOTE` at a local repository:
    - `.upstream` present and `.canon` absent: the source is `.upstream`.
    - both present and different: the drift check uses `.upstream`, and its message names it.
    - `.canon` matching `origin` **with** `.upstream` present: the copy menu, not the canon menu,
      and the drift check runs rather than being skipped.
    - neither file: UNAVAILABLE and undetermined, unchanged.
13. **`tools/test-pr-guard.sh`** — `.upstream` is an allowed path; a tree with `.upstream` is not
    the canon even when `.canon` matches `owner/repo`, so no bump is demanded.
14. **`tools/test-sync.sh`** — `.upstream` survives a sync that changes it on `main`.

## What must stay true afterwards

- Every bench green: `bash tools/ready.sh` reports all of them, and none may be red.
- `bash tools/index.sh --check` and `bash tools/sections.sh --check` pass.
- `bash tools/prose-gate.sh` reports; §7 gates at 1.5 per 100 words and the run is a report.
- `SYSTEM.md`, `system/6`, `INDEX.md` move in the same pull request. Three documents in step (§8).
- A copy carrying no `.upstream` behaves **exactly** as today. That is every copy in existence,
  so the change is inert until an onboarding writes one.
- **The first hop must not delete `.upstream`.** The wholesale template pull request brings the
  canon's files across; a copy's `.upstream` is not among them and must survive. Say it in §6, in
  the same paragraph, so the agent opening that pull request reads the rule where it acts.

## What the executor must not do

- Not delete, rename, or widen `.canon`. It stays one line, and the parser split is a separate
  backlog item.
- Not touch `propagate`'s proposal target. It reads `.canon`, which is the root, which is right.
- Not build per-instance custodians. Separate, larger, and bundling it makes this unreviewable.
- Not write repository or branch into any file. Git holds both and §6 calls a document naming a
  branch stale. **The parent is the only identity fact git does not hold** — a *Use this template*
  copy has no shared history and no fork record — and it is the only one written down.
- Not hand-edit `INDEX.md`.
- Not work on `main`, and not merge anything. The merge is the Principal's (§6).

## How the result is checked

```
bash tools/test-anchor.sh
bash tools/test-pr-guard.sh
bash tools/test-sync.sh
bash tools/ready.sh
bash tools/index.sh --check
bash tools/sections.sh --check
bash tools/prose-gate.sh
```

Then, by reading rather than by command, the one thing no bench covers: a fresh copy with no
`.upstream` produces byte-identical hook output to the current version. If it does not, the
change is not inert for existing copies and it ships a regression to every one of them.

## Roles

Planner: this file. **Executor:** edits the paths above, reads this file and not the
conversation. **Verifier:** never edits, reads this plan against the diff, and answers whether a
copy with no `.upstream` still behaves as today — the claim that carries the migration.
