---
name: orchestrate
effort: high
summary: Split a task into planning, doing and judging, give each to a model that fits, and let the judge read the plan instead of the worker.
description: Run a task through three roles instead of one — a high-cognition model writes the plan, a model with sufficient capacity executes it, and a high-cognition reader that never edited anything checks the result against the plan. Use when a task is large enough that the handoff pays for itself, mechanical enough to specify in writing, and verifiable against something other than the worker's own account of it. Use it especially where the agent would otherwise grade its own work. Do not use it for small tasks, for work whose plan costs more than the work, or where nothing outside the worker can confirm the result — say so instead.
---

# orchestrate

Rides SYSTEM.md §3: *verify before assert* · *done is earned by verification* · a subagent's brief is a file, never a sentence in a prompt.

## The one thing this exists to fix

**A worker cannot audit itself, because the measurement and the motive share a context.**

That is not a theory here. On 13-08-2026 a 5S run reported a net of −8.045 words. A second
agent that never edited anything read the same tree and found the number was **−6.966**: the
run had measured the *before* with one command and the *after* with another, and the only
difference was that the second one excluded the report the run had just written. Nothing was
fabricated. A moment was chosen, and the choice favoured the chooser.

The same reader also found an item declared closed that was open, and two facts deleted that
lived nowhere else.

**No amount of care inside the worker finds those.** A separate reader with the plan in hand
finds them in one pass.

## The three roles

| Role | Model | Touches files | Reads |
|---|---|---|---|
| **Planner** | high cognition | no | the task and the tree |
| **Executor** | enough capacity for the work | yes | the plan |
| **Verifier** | high cognition | **never** | the plan, the diff, the executor's report |

**The plan is a file, committed before the executor starts.** Not a paragraph in a prompt.
Three reasons, and the third is the one people skip:

1. The executor reads it without inheriting the planner's reasoning, so a gap in the plan
   shows up as a question rather than as a guess.
2. The verifier reads the same bytes the executor read. A plan that lived in a prompt cannot
   be checked against anything.
3. **It dates the intent.** A plan written after the work is a description, and a description
   always matches.

**The verifier never edits.** The moment it can fix what it finds, it starts reporting what
it fixed instead of what was wrong, and the second reading is gone.

## What the plan has to contain

A plan the verifier cannot use is a plan that produced no verification.

- **What changes**, by path. A file the plan does not name is a finding, not a bonus.
- **What must stay true** afterwards: the benches, the version, whatever the guard reads.
- **What the executor must not do.** Scope is easier to check than intent.
- **How the result is checked**, as a command wherever one exists. *"Looks right"* is not a
  check, and a plan whose only check is a reading has bought a second opinion, not a proof.

## What the verifier answers, and nothing else

Two questions, in this order:

1. **Does the diff do what the plan said?** Named files, named outcome, nothing extra.
2. **Did anything of value get lost to get there?**

Then a third that only it can answer, because it holds both sides: **is every number in the
report real?** Re-run the measurement rather than reading the claim. That is the one that
caught the 5S.

Its verdict goes in the report **as it was written**, including what it says the run got
wrong. A verifier whose findings are summarised by the worker is the worker grading itself
with extra steps.

## When not to use this

The cost is not small and pretending otherwise would sell it dishonestly. **The verification
pass on 13-08 cost 108.841 tokens and 31 tool calls.** That bought four real findings, so it
paid — but it is the price every time.

Do not orchestrate:

- **A task smaller than its plan.** Writing the plan, reading it, and checking it against a
  four-line diff costs more than doing the four lines twice.
- **Work with no external check.** If nothing outside the worker can confirm the result, the
  verifier can only offer a second opinion. Say that plainly and skip the role, rather than
  dressing an opinion as a verification.
- **Anything the Principal is waiting on right now**, unless the work is risky enough that
  being right matters more than being quick.
- **Exploration.** A plan written before the tree is understood pins the wrong thing, and the
  executor then satisfies it.

## Why this splits by role when 5S argues against splitting

`.claude/skills/5s/` refuses to run its five steps in five agents, and it is right: those are
**sequential steps of one job**, the findings live in the seams between them, and an agent
that only does *shine* never sees what *sort* left behind.

**These are not steps. They are three jobs on the same whole**, and two of them are
deliberately kept apart:

- Planning and doing are split so the plan is written before the work argues for itself.
- Doing and judging are split **because sharing context is exactly the defect**. Here the
  seam is not where findings get lost. It is where they get found.

A split that hides the seams is the error 5S names. A split that puts a reader on the far
side of one is this.

## The report

    orchestrate · <task> · planner <model> · executor <model> · verifier <model>
    Plan:     <path, committed before execution>
    Result:   <what changed, by path>
    Checks:   <the commands, and what they returned>
    Verifier: <its verdict, verbatim, including what it found wrong>
    Cost:     <tokens and tool calls, if the runtime reports them>

**A run whose verifier found nothing says so, and says what it looked at.** A verifier that
never finds anything is not a clean record. It is a role that stopped working, and the next
run should spend its tokens elsewhere.

## Provenance

Distilled from the worker-and-monitor pair in `.claude/skills/5s/`, which was the first place
this system separated doing from judging, and from the 13-08-2026 memory run where that
separation caught an inflated number, a wrongly closed item, and two deleted facts.
