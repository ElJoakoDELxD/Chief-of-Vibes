---
topic: Bring a canon release into this copy, and then into the agent branch
updated: 04-08-2026 23:10 -04
verified: run seven times, on 02-08-2026 and 03-08-2026, for releases 1.30.0, 1.31.0, 1.32.1, 1.33.0, 1.34.0, 1.35.0 and 1.35.1. All three sides read back and compared each time
---

## When this applies

The anchor hook reports template drift at session start, or the canon merged a release
this copy does not have. Closing the gap comes before substantive work (SYSTEM.md §6),
because a copy on an older specification obeys superseded rules with the old rails wired
in, and nothing looks wrong from inside it.

## Procedure

1. Read the canon's version. `git show origin/main:SYSTEM.md` on a clone of the canon, or
   the GitHub API. Do not check out `main`: the guard hook blocks that, and reading needs
   no checkout.
2. Compare the canon's file against this copy's `main` before you plan anything. A release
   that only adds a skill leaves `SYSTEM.md` identical except for the version line, and
   knowing that decides how much work follows.
3. Branch from `origin/main`, not from the agent branch: `git checkout -B claude/sync-<version> origin/main`.
4. Copy across only the files the canon release changed. Read them from a clone of the
   canon, so what lands here is what the canon holds and not what somebody retyped.
   **`INDEX.md` is the exception: regenerate it, never copy it** (see the trap below).
5. Commit the message as a file with `git commit -F <path>`, then push and open a pull
   request into this copy's `main`.
6. Read the CI check with the API, in this turn. The `template-only` check finishes in
   about six seconds.
7. Merge with a normal merge. Never squash.
8. Check out the agent branch and run `bash tools/sync.sh`. That is the second hop, and it
   is a merge, so a conflict settled once stays settled.
9. Push the agent branch.
10. Read the version on all three sides and compare: the canon, this copy's `main`, and
    the agent branch. Read them. Do not infer them from the merge succeeding.

## Traps

- **`INDEX.md` is generated from the tree, so the canon's copy is wrong here.** The copy
  holds `knowledge/`, which the canon does not, and the index lists it. Copying the
  canon's `INDEX.md` across drops those rows and the CI index check fails, naming the
  exact lines. Run `bash tools/index.sh > INDEX.md` on the sync branch instead. The rule
  generalizes: a generated file is regenerated on the side that will hold it, never
  carried across. Found on 04-08-2026 syncing 1.40.0, and the check caught it.

- **Run the regeneration from the copy, and check the working directory first.** Reading
  the release files needs a `cd` into the clone of the canon, and a `cd` persists. Running
  `tools/index.sh` in the next breath regenerates the *canon's* index, reports it current,
  and leaves the copy's stale — a green reading of the wrong tree, which is worse than a
  red one. Same failure twice on 04-08-2026, the second time in this exact procedure.
  `git branch --show-current` before regenerating answers it in one line.

- **The drift report names the working branch, not `main`.** The hook compares the branch
  you are standing on against the canon. This copy's `main` can already hold the release
  the hook says is missing. Read `main` before you plan a sync it does not need.
- **A pull request built on a stale base overwrites the release above it.** Check what the
  canon changed since your base. On 02-08 a distillation prepared against 1.31.0 would
  have reverted the 1.32.0 skill if the bases had not been compared first.
- **`tools/sync.sh` on the agent branch can conflict on the journal.** Two sessions writing
  the same day is normal. Resolve by interleaving the entries by the hour each one carries.
  The journal is append-only, so both halves are real and neither side is chosen.
- **Template files take `main`'s version on that merge.** That is the rule in §6, and it
  applies without asking. The agent branch's own `README.md` is the one exception.
- **Prose that quotes a command belongs in a file, never in a heredoc.** The guard hook
  reads a quoted command as the command and blocks the whole call. Write the text with an
  editor tool and append the file.
- **`tools/sync.sh` refuses a working tree with uncommitted changes.** Commit the memory
  work first, then sync. The order matters on a day that edits both.
- **A branch cannot be deleted from the session.** `git push --delete` returns 403 through
  the proxy, and the auto-mode classifier refuses it as well. No MCP tool deletes a ref.
  Merged branches go to the Principal.

## How to tell it worked

The three sides print the same version, read in the same turn. The three benches pass:
`tools/test-guard-main.sh`, `tools/test-guard-install.sh` and `tools/test-sync.sh`. The
agent branch holds the new template files and its own `memory/` and `projects/`, with
nothing of the template edited on the branch itself.
