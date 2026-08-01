---
name: 5s
description: Run 5S — sort, set in order, shine, standardize, sustain — over something that has accumulated: the template documents, the repository tree, or the agent's memory. Use whenever the Principal asks to tidy, prune, trim, clean up, declutter or "run 5S" on any of those, and use it on your own initiative before shipping a release that adds prose, because §8 requires the net to be reported rather than felt. Also use after a session that installed or generated things, when residue may be sitting where nobody looks. Takes the target as an argument: documents, tree, or memory.
---

# 5s

Rides SYSTEM.md §3: *verify before assert* — every count in the report is measured, never estimated · *never fabricate a reading* · *a suggestion arrives with its address* · sober register.

5S is housekeeping borrowed from lean manufacturing: **sort** out what does not belong, **set in order** what stays, **shine** what remains, **standardize** so the state is reproducible, **sustain** so it does not decay. Applied here to the three things in this system that grow without anyone deciding to grow them — prose, trees, memory — and reported as a number rather than an impression.

## The mechanic that makes it work

A 5S run with no budget finds the obvious and stops. A run that has to **pay for something** keeps looking, and that is where the findings are.

Declare the budget before touching anything:

- **Paying for an addition.** This change adds N words of prose, so the run recovers at least N. This is the strong form and the one with the record: hunting 214 words to fund a new rule surfaced redundancies that had been sitting for weeks — §6 re-arguing what §1 already declares, the handoff explained twice — that a run without a budget would never have looked hard enough to find. The hard limit is what makes you look.
- **A declared reduction.** Nothing to fund, so name the number first: 10%, 300 words, every file untouched in 30 days. Naming it after the fact is not a budget, it is a score.
- **A defect hunt.** No number, one question: what is here that should not be. Legitimate for a tree or a memory vault. Not for prose, where *does not belong* is too easy to answer generously and the run turns into rewriting.

The first line of the report says which one ran. A run with no budget is tidying, and should be called tidying.

## Pick the target

| Target | What it covers | Read before starting |
|---|---|---|
| **documents** | `SYSTEM.md`, `CONTRIBUTING.md`, `README.md`, `CLAUDE.md` | `references/documents.md` |
| **tree** | the repository, plus what a session wrote outside it | `references/tree.md` |
| **memory** | `memory/journal/`, `backlog.md`, `state.md`, `handoff/` | `references/memory.md` |

The argument names it. With no argument, ask rather than guess: the three have different failure modes, and a run aimed at the wrong one spends the budget without touching the problem. Two targets is two runs — separate budgets, separate commits, separate reports.

## The five steps

The target's reference file says what each step means there. The shape is the same everywhere.

1. **Sort.** Remove what does not belong. The trap is looking only where you already are. The worst finding in this system's history was a file an installer wrote *outside* the working tree, into global runtime configuration, where nothing in the repository would ever have shown it. So the sort step asks two questions, not one: what does not belong here, and what wrote here that also wrote somewhere else.
2. **Set in order.** Put what stays where it belongs. In a document that is the ladder of §8 — a rule in the wrong section is misplaced, not misworded, and moving it is worth more than rewording it. In a tree it is the guard's allowlist. In memory it is the folder split of §5, where *what happened* and *how to do it again* are different files.
3. **Shine.** Clean — and know that cleaning **is** inspection, which is the half of shine that gets dropped. Every real finding in this system's 5S runs came out of shine, not sort: rewriting a paragraph is what reveals that it contradicts another one three sections down. A shine step that produced no findings was not a clean target, it was a skipped step, and the report says so.
4. **Standardize.** Whatever was found once will come back unless something catches it. Name the rung (§8): impossible by construction, blocked by a rail, reported by a sensor, or written as a §3 rule. A fix with no rung is a suggestion without an address, and the next run will find it again.
5. **Sustain.** Say when this runs next and on what trigger. *Periodically* is not a trigger. A release that adds prose is one. A session that installed something is one. A journal crossing a size nobody will read is one.

## Report

Six lines, no ceremony:

    5S · <target> · <budget: form and number>
    Before:  <measure>
    After:   <measure>
    Net:     <signed number>
    Found:   <what shine surfaced — or "nothing", which means shine was skipped>
    Rung:    <what standardize produced, and where it lives>

**Report the net unpainted.** A run that came out positive says so plainly. The precedent is load-bearing: release 1.14.1 reported **+81** against its own stated aim and named itself as meeting the letter of §8 and not the spirit — and that admission is exactly what forced the next release to come out negative. A 5S that only ever reports wins is one nobody can use to argue with, which makes it decoration.

## What this stops looking at

Every convenience removes friction from some check (§3). This one removes the friction of deciding what to cut, and the check it erodes is the reviewer's: sections described as "just tidied" stop being re-read. So the report names which sections were touched, and the diff — not the summary — is what gets reviewed.

## Provenance

Distilled from the runs that produced releases 1.14.1 and 1.15.0 of `SYSTEM.md`, and from the residue sweep of 31-07-2026 that recovered a global `CLAUDE.md` written by a third-party installer. Both are in the canon's `git log main`.
