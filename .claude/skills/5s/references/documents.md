# 5s · documents

Target: `SYSTEM.md`, `CONTRIBUTING.md`, `README.md`, `CLAUDE.md`. These are template files, so the run lands as a pull request into `main` with a version bump (§8), and the `guard` check enforces both.

## Measure

Words, counted, never estimated:

    wc -w SYSTEM.md CONTRIBUTING.md README.md CLAUDE.md

Take the count before the first edit and after the last one. Lines are a weaker measure — reflowing changes them without changing content — but report them alongside when a section was restructured, because a large line delta at a flat word count is what restructuring looks like and a reviewer should see it.

## What each step means here

**Sort.** Sentences that carry no load. The reliable kinds: a section re-arguing a conclusion another section already reaches; the same rule stated twice in different words because it was added twice; examples that repeat an idea the sentence before already made; hedges around a claim the document elsewhere states flatly. Deleting a fact is not sorting — if the content is gone, the count is a lie.

**Set in order.** Two questions. Is this on the right rung (§8), and is it in the section that holds that rung? §3 is the whole of rung 4; a mechanical rule sitting there belongs in §1, and moving it shrinks §3 without losing anything. The other direction is the expensive one: a rule that is really judgment, filed as if it were a rail, teaches the agent to route around a rail that lies.

**Shine.** Rewrite for density and read for contradiction at the same time — they are the same pass. The findings that matter come out here: two sections that disagree, a rule that cannot be complied with, a claim the machinery no longer supports. When shine finds a contradiction, fixing it is the release; the word count is secondary and the report says so.

Start the pass with the instrument, so the reading is aimed rather than hopeful:

    python3 tools/redundancy.py SYSTEM.md system/*.md CONTRIBUTING.md README.md CLAUDE.md

It ranks sentence pairs from different sections by shared vocabulary. Read down from the top and decide each one, then **write the verdicts down, including the pairs you left alone and why**. A pair judged once and not recorded is re-litigated by every future run, and the run after this one will look at the same 0.25 band and reach the same conclusion at full price. The worked example is `veredictos.md` in the copy that built the tool: four facts cut, one formulaic construction that was not redundancy at all, and a band of shared vocabulary deliberately kept. The score is a ranking, not a verdict, and a controlled language inflates it by construction because it forces one word per meaning.

**Standardize.** Ask whether the cut could have been prevented. A paragraph that drifted out of sync with a table is a candidate for a sensor, not for a rule about writing carefully.

**Sustain.** The standing trigger is §8's own: a release that adds prose without adding machinery must come out negative, or the criterion is decoration and should be deleted rather than cited.

## Traps

- **Paying with content.** The budget is met by removing redundancy, never by removing a fact, a step, or a caveat. §3 is explicit that compression is not omission. If the only way to hit the number is to drop something real, report the shortfall instead — a missed budget honestly reported is worth more than a met one that cost a warning.
- **Trimming the part that is load-bearing because it is the part that is easiest to trim.** Warnings, irreversible-action confirmations and worked examples read as padding and are not.
- **Three documents, fixed roles (§8).** A mechanism described in one is described in all three. Trimming `README.md` alone can silently break that promise; check the other two before declaring the run finished.
