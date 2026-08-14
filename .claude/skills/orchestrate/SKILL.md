---
name: orchestrate
effort: high
summary: Split a task into planning, doing and judging, give each to a model that fits, and let the judge read the plan instead of the worker.
description: Read every incoming prompt before answering it — restate what it asks, size it, and route it to a model and an effort level that fit, so a small question stops costing what a release costs. That triage is not optional and its verdict rides in the header of the reply. Above a threshold the same skill splits the work into three roles: a high-cognition model writes the plan, a model with sufficient capacity executes it, and a high-cognition reader that never edited anything checks the result against the plan. Use the heavy half where the agent would otherwise grade its own work, and never for a task smaller than its own plan.
---

# orchestrate

Rides SYSTEM.md §3: *verify before assert* · *done is earned by verification* · a subagent's brief is a file, never a sentence in a prompt.

**This skill has two gears and they cost opposite amounts.** The first runs on every prompt and exists to *spend less*. The second runs rarely and is expensive on purpose. Reading only the second one and applying it always is the way to burn a window on a one-line question.

---

# Gear one: triage, and it runs every time

**Before answering anything, read the prompt as a thing to be measured.** Three steps, all in this context, no subagent, and the whole thing costs a few sentences of thought.

## 1. Restate it

Say back what the prompt asks for, in one line, in the terms the work will use. This is where a vague request becomes an executable one, and where an ambiguity surfaces while it is still free.

**The improved reading never silently replaces the request.** When the restatement changes the scope, it goes in the reply where the Principal can see it and object. When it only sharpens wording, it stays silent. **The original governs wherever the two differ**, because a prompt improved past what was asked is a prompt answered wrongly with better grammar.

## 2. Size it

| Signal | Pushes down | Pushes up |
|---|---|---|
| **Names its target** | paths, files, a command | "somewhere in the system" |
| **Shape** | a question, a reading, a lookup | a build, a rule, a release |
| **Blast radius** | this branch, this file | the canon, money, anything public |
| **Reversibility** | a commit that can be dropped | a merge, a post, a payment |
| **Ambiguity** | one reading | several, and they diverge |

## 3. Route it

    low     a lookup, a reading, a restatement, a small edit with a named target
    medium  ordinary work: one file, a bounded change, a bench that already exists
    high    rules, releases, anything irreversible, anything the Principal will act on
    three   the roles below, when high is not enough because the agent would grade itself

**The floor overrides the saving.** Anything touching the canon, money, a credential, or something that becomes public **runs high whatever its size**, and a one-line change to a rule is a rule change. Cheapening those is not a saving. It is the one place where being wrong is expensive, so it is the last place to economise.

## 4. Say it in the header

The route goes in the header of every reply (§9), as `model·effort`. That is what makes the step impossible to skip quietly: a reply with no route on it did not run the triage, and anyone can see that without asking.

**A route that turns out wrong is corrected out loud**, mid-task, and the reply says so. Discovering that a *low* was really a *high* is the triage working, not the triage failing.

---

# Gear two: the three roles, and it runs rarely

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

Gear one comes from the Principal on 13-08-2026: *"que el prompt que ingrese el usuario sea medido y se le asigne un modelo y un nivel de esfuerzo acorde, para que ahorres tokens al usuario"*, with the improvement step first.

Gear two is distilled from the worker-and-monitor pair in `.claude/skills/5s/`, which was the first place
this system separated doing from judging, and from the 13-08-2026 memory run where that
separation caught an inflated number, a wrongly closed item, and two deleted facts.
