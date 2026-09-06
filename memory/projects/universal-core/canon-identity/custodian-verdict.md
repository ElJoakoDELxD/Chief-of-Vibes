---
thread: Canon identity
date: 06-09-2026
state: revised twice on 06-09-2026. The lab's contract stays rejected, its instinct is upheld,
  two defects that exist today were found, and the remedy now lives in plan-lineage.md.
reads: proposal-from-lab.md
produces: plan-lineage.md
---

# Verdict on the laboratory proposal, second reading

The first reading measured the proposal against §6 and rejected it. §6 describes **one canon and
N copies**. The Principal's push-back is that the system is not that shape: the template
reproduces, a copy can be copied, and each generation needs to name its parent without claiming
to be the root. Measured against a tree instead of a star, the answer changes.

## What the first reading got right, and it still holds

`.canon` is a **pointer upstream**, not a claim of custody. One line, `owner/repo`, meaning *the
canon is over there*. A copy that inherits it does not inherit a false claim; it inherits one
side of a comparison whose other side is its own `origin`. The proposal's stated failure — *a
copied canonical marker becomes misleading* — is still an inversion of the mechanism.

Two costs of withholding it from `main` are also unchanged, and both are measurable.

- **A blind window before onboarding.** The pointer arrives today with the files. Generated at
  onboarding, it does not exist for any session that opens before onboarding runs, and the
  canon-or-copy menu answers *undetermined* in the one place it is read.
- **`pr-guard.sh` fails open on the canon.** `guard.yml` checks out the pull request, so the
  guard reads `.canon` from that tree. Absent file gives `is_canon=0`, and the guard then prints
  *a copy does not carry the master version; no bump required* — on the canon. The release rail
  disappears with a green check. The proposal permits adjusting consumers, so this is a cost on
  its bill rather than a blocker, but it is the cost its own acceptance tests 5 and 7 forbid.

## What the first reading missed

**Inheriting the pointer unchanged is correct for one generation and stale by one hop for every
generation after it.** §6 says *copies inherit `.canon` unchanged, which keeps the answer stable
through every sync*. Stable, and wrong from the second copy onward.

Ana copies the canon. Bruno copies **Ana**. Bruno's `main` carries the root's slug, inherited,
so Bruno's template came from Ana and every mechanism believes it came from the root:

- The drift check compares Bruno against the root. Ana is ahead of the root, which §6 calls the
  system working, so Bruno is told he is AHEAD with nothing to sync while Ana ships releases he
  never receives.
- `propagate` opens Bruno's proposal against the root, skipping Ana, built on a superset the
  root has never seen.

## And the exit costs more than the README says

The README offers the hard fork: *edit one line and your copy becomes its own home*. Trace it.

Ana edits `.canon` to her own slug. Her `origin` now matches it, so `anchor.sh` takes the branch
at line 112 that skips the drift check entirely — *the canon cannot drift from itself*. Ana is
silently reported current against the root, forever, and §1 promises that silence means parity.
By §3's own standard that is a fabricated reading. On a fresh chat with no `state.md` she is
also told *no agent is created here and no work lands here*, in her own repository.

The file conflates two facts and one line cannot hold both:

| Fact | Changes at every copy | Consumers |
|---|---|---|
| **Where do I sync from** — my parent | yes | drift check, first sync hop |
| **Where do proposals go** — the root | no, until a deliberate fork | `propagate`, canon-or-copy, `pr-guard` |

`propagate/references/propose.md` already anticipates *a copy that hard-forked edited it*. The
design saw the fork and did not see that editing the one line is what blinds the fork.

## The synthesis

The lab is right that something must be generated at onboarding from real state. It named the
wrong fact. **Repository and branch are already in git**, and §6 says a document naming a branch
is stale, so writing them down is the one thing the specification forbids. **The parent is not
in git** — a *Use this template* copy has no shared history and no fork record anywhere — so the
parent is the single identity fact that genuinely has to be written at onboarding.

Right moment, wrong fact.

**The remedy first written here was wrong and `plan-lineage.md` replaces it.** It put two keys,
`root` and `upstream`, inside `.canon`. The first hop takes the canon's version of every template
file, so a copy-local key inside a template file is overwritten by the first sync after it is
written. **The fact that must not be inherited cannot live in a file the template ships.**

The plan adds a second file instead. `.canon` keeps the root and is inherited unchanged, so no
copy migrates and no parser changes. `.upstream` holds the parent, is written once by onboarding
from real state, and the canon never ships one. One rule carries it: **`.upstream` present means
derived, whatever `.canon` says.**

That also settles the Principal's naming point in the form they put it — the derived marker is
not called `.canon`, and `.canon` stays reserved for the root.

## The parser split, no longer a blocker

`anchor.sh` reads `head -n1`. `pr-guard.sh` reads the whole file through `tr -d '[:space:]'`.
They agree only while `.canon` is one line, and a second line would make `pr-guard` match nothing,
set `is_canon=0`, and drop the version rail silently. Under the two-key design this blocked the
change. Under the plan `.canon` stays one line, so the defect is real, still worth fixing, and
**off the critical path**.

## Kept separate on purpose

*Each instance generates its own custodian.* Plausible, and larger than identity. It does not
need to ship with this and bundling it makes the change unreviewable. Backlog, not this release.

## Standing

A verdict is a recommendation and never permission (§6). Nothing here merges anything, and
nothing above has been implemented.
