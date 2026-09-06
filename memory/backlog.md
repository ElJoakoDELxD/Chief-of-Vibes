# Backlog

What gets done. What was already done lives in the journal, not here.

## Agent

- **Report what the weekly guard finds.** The first run of the guard has not happened yet, so
  this list is empty by fact and not by tidiness. An empty backlog here is the normal state of
  a template nobody has broken.
- **`.canon` has two parsers and they disagree.** `anchor.sh` reads `head -n1`; `pr-guard.sh`
  reads the whole file through `tr -d '[:space:]'`. They agree only while the file is one line,
  so any comment added to it makes `pr-guard` match nothing, set `is_canon=0`, and drop the
  version rail on the canon silently — a fail-open. Fix the parsers before the file gains a
  second line: this now blocks the lineage change below. Found 06-09-2026 while tracing the
  laboratory proposal (`memory/projects/universal-core/canon-identity/custodian-verdict.md`).
  Candidate for upstream.
- **The pointer is stale by one hop from the second copy onward, and the hard fork blinds
  itself.** `.canon` holds one slug for two facts — where syncs come from, and where proposals
  go. A copy of a copy inherits the root's slug and syncs against the wrong repository; a fork
  that edits the line matches its own origin, so `anchor.sh` skips the drift check and reports
  parity forever (§1 promises silence means parity, so that reading is fabricated). Proposed
  remedy, unimplemented: two keys, `root` inherited and `upstream` rewritten at onboarding, with
  the file renamed in the same release. Blocked on the parser item above. Candidate for upstream.

## Principal

- **Nothing waiting.** Items land here only when the guard hits a limit that needs a person:
  a merge into `main`, a decision about scope, anything in the physical world (§2, §4).
