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
  second line. Found 06-09-2026 while tracing the laboratory proposal
  (`memory/projects/universal-core/canon-identity/custodian-verdict.md`). Candidate for upstream.

## Principal

- **Nothing waiting.** Items land here only when the guard hits a limit that needs a person:
  a merge into `main`, a decision about scope, anything in the physical world (§2, §4).
