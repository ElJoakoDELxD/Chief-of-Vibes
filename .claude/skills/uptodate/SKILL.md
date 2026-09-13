---
name: uptodate
effort: low
summary: Bring this copy to what the canon carries, and say the relation, what changed, and what is still not there.
description: Align this copy with the canon named in .canon — not with local main, which is this repository's own template branch — and report the result in the Principal's terms. Use when they ask to update the agent, to bring it up to date, to sync, to pull the latest version, whether it is running the newest rules, or type /uptodate — and use it unprompted when the session-start drift check reports this copy is behind, because a copy running superseded rules looks exactly like one that is current. It also answers the two cases a version number hides: a copy ahead of the canon is the system working and syncing would move it backwards, and a copy whose history shares no ancestor with the canon is forked, where ahead and behind are both false.
---

# uptodate

Rides SYSTEM.md §6: *the canon comes down on its own; the copy goes up with approval* · §3: *verify before assert* — the version after a sync is read, never assumed · *the Principal never looks for what they must read*.

## The one thing this exists to fix

**A copy running old rules looks exactly like a copy running current ones.** Nothing in a session feels different. The hooks that fire are the old hooks, the rules that are read are the old rules, and every reply looks normal — which is why §6 has a drift check at all.

So the question *am I up to date* has no answer from inside the session. It has to be measured, and the measurement has a direction.

## Run the tool

```
bash tools/sync.sh
```

It merges `main` into this branch, resolves the conflicts the rule already covers — template files take main's version, the agent branch's `README.md` keeps the agent's — and prints both outcomes. It stops on anything the rule does not cover.

It is safe to re-run: with nothing new on `main` it does nothing and says so.

## Six things the tool cannot decide, and this is why the skill exists

**1. Whether this repository has an upstream at all.** The canon is the root. It has no `.canon`, nothing collects its findings, and there is no version above it to reach — so here the answer is that the question does not apply, said plainly rather than measured. Check with `ls .canon`. Everything below assumes a copy.

**2. Whether this branch is one where a sync means anything.** A template branch carries no `memory/`, so there is no agent to bring up to date; the branch *is* the template work. Check with `git branch --show-current` and say so rather than merging.

**3. Which repository this is being measured against.** `main` is not the canon. `main` is this repository's own template branch, and `.canon` names the repository the copy answers to — a different repository, on GitHub, that `sync.sh` never fetches. Measuring against `main` compares this copy to itself and calls the result parity. Measured 10-09-2026 on a live copy: the answer came back *nothing to sync* while twelve template files the canon carried were missing, among them the rail that stops an agent authoring commits under the Principal's address. Fetch the canon and read it:

```
cat .canon
git remote add canon "https://github.com/$(cat .canon)" 2>/dev/null; git fetch canon
sed -n '3p' SYSTEM.md
git show canon/main:SYSTEM.md | sed -n '3p'
```

**4. Whether the two histories share an ancestor — ask this before reading the numbers.** A version orders releases inside one lineage. Across two it is a coincidence of digits, and `sort -V` will answer anyway:

```
git merge-base canon/main HEAD || echo "NO COMMON ANCESTOR — this copy is forked"
```

Exit 1 means **forked**: neither ahead nor behind, no direction to report, and the same number can sit on both sides carrying different releases. Measured 10-09-2026: one copy's 1.89.0 and the canon's were two different releases, and a string comparison called them equal. A copy that was pushed from a tree rather than cloned has no shared root and will land here.

What answers a fork is a file comparison in both directions, because each side holds work the other never received:

```
git diff --name-status canon/main HEAD -- SYSTEM.md CLAUDE.md INDEX.md system/ tools/ knowledge/ .claude/
```

`D` is the canon's and missing here. `A` is this copy's and missing upstream. Bring the first down file by file, run every bench after each one, and report the second as waiting. A merge is not available: it needs `--allow-unrelated-histories` and conflicts on nearly every template file, and taking the canon's side wholesale deletes this copy's releases.

**5. The direction of the gap, once an ancestor exists.** §6 is asymmetric on purpose. A copy **behind** is a defect: it is obeying rules that were already superseded. A copy **ahead** is the system working — improvement is born in the copy — and syncing it would move it backwards. Ahead means the missing step is a pull request, not a sync. Say which releases are waiting.

**6. Whether the latest version is in `main` at all.** This is the case that looks like success and is not. `main` can be behind the work: a release that is written, green and unmerged lives in a pull request, and a sync will cheerfully report *nothing to do* while the newest rules sit one merge away. If the newest version is in one of them, the honest answer is that the sync is not the blocked step — the merge is, and it is the Principal's.

**Enumerate them, do not eyeball them.** With a GitHub tool, list the open pull requests. Without one — a delegated session usually has none — read the branches, and read them with a command rather than by recognising names:

```
for b in $(git branch -r --no-merged origin/main | grep 'origin/claude/' | sed 's|origin/||'); do
  v=$(git show "origin/$b:SYSTEM.md" 2>/dev/null | sed -n '3p' | grep -o '1\.[0-9]*\.[0-9]*')
  [ -n "$v" ] && echo "$v  $b"
done | sort -V
```

Measured on 30-08-2026: a delegated session asked this question found **two of the three** waiting releases by reading branch names, and reported a missing number that was in fact the branch it had skipped. The list is also noisy — abandoned branches sit there for weeks at ancient versions — so **only a version above `main`'s is a waiting release**, and everything below it is residue for a 5S over the tree, not something to report as pending.

## What actually changed, for a person

The tool prints a file list. A file list is not a report. Read the release messages between the two versions and say what governs now that did not:

```
git log --oneline --first-parent <old>..<new> -- SYSTEM.md system/ CLAUDE.md
```

## Then verify, because a merge is not a reading

After the sync, read both versions again and say the two numbers. The tool exiting zero is not evidence that the versions match — it is evidence that a merge finished. §3 draws that line everywhere else and it holds here.

Then run the benches. A sync brings new rails, and a rail that arrives red is worse than one that never arrived, because the session will trust it:

```
for t in tools/test-*.sh; do bash "$t" >/dev/null 2>&1 || echo "RED $t"; done
```

A bench can arrive red without the rail being wrong. One that **expects** a condition of the tree rather than building it — a word that lives in the canon's §5 and not in this copy's, an offset that was correct in the season it was written — fails on a tree where the tool works. Read the failure before trusting it, and fix the fixture where that is what broke.

And push. A sync that lands only in the container is a sync the next session repeats (§9).

## The report

Six lines, and the last one is the one people actually need:

```
Against:   <the repository in .canon, not main>
Relation:  <forked | ahead | behind — read from git merge-base, never from the numbers>
Before:    <this branch's version>
Now:       <the version, read after the merge>
Governs:   <what changed, one line per release>
Missing:   <what is not in the canon yet, and whose step it is>
```

**`Relation:` comes before the numbers because it orders them.** Over a fork, *ahead* and *behind* are both false, and saying *1.117.0 against 1.89.0* without saying the histories never touch is a number that lies in the shape of a fact.

**`Missing:` is never empty by default.** When a release is sitting in an unmerged pull request it belongs there with its number, because the Principal asking to be brought up to date is asking about the newest rules, not about the newest merge.

## What this must not become

**A merge nobody read.** The point is the report, not the fast-forward. A sync that lands and says *done* has moved bytes and told the Principal nothing.

**A direction read from the numbers.** Numbers order releases inside one history. `git merge-base` says whether there is one history, and that question comes first — on 10-09-2026 the session-start sensor skipped it and reported a lead over a fork. It landed as a bench case in `tools/test-anchor.sh`.

**A reason to sync a copy that is ahead.** If the numbers say ahead, stop. Naming the releases that are waiting to go upstream is the whole answer, and running the merge anyway is the one action §6 says is backwards.

## Provenance

Asked for by a Principal on 30-08-2026, after asking *what is the command to bring the agent to the latest version* — and the honest answer that day was that `sync.sh` would do nothing, because the three newest releases were sitting in unmerged pull requests. The command existed; what was missing was the reading around it.

It reached the canon on 11-09-2026, for the reason the same Principal gave: the canon has no agent and needs none of this, but everyone who copies the template gets an agent, and every one of them will ask this question.
