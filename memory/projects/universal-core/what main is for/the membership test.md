---
thread: What main is for
date: 07-09-2026
state: the Principal's principle, stated 07-09-2026. Proposed for §6, where it is absent.
---

# Everything a copy needs to become itself, and nothing else

The Principal's rule: **everything you need to build your copy is on `main`. Not more, not less.
It is totally clean, ready to copy. Everything else is on the agent's working branch.**

## The test

One question decides any file, and anybody can ask it without re-deriving the rule:

> **Does a fresh copy need this to become itself?**

Yes puts it on `main`. No puts it on the agent branch. There is no third answer and no file that
is a little of both.

## Both halves have a failure, and most people guard one

**More than needed.** A file on `main` that describes one agent, one Principal, one project or
one repository ships to everybody and describes nobody who receives it. The copy inherits a claim
about somebody else and cannot tell it apart from a claim about itself. That is `.canon` read as
custody, diagnosed on 07-09-2026, and a filled-in post file would have rebuilt it.

**Less than needed.** A file a copy must have and does not get. Then a copy is told, or invents
it, and two copies diverge from their first day. A post a copy must hold from creation, whose
definition does not ship, is that failure: it can hold nothing, or it writes its own and the word
stops meaning one thing.

The rule is not *keep `main` small*. It is **keep `main` exact**.

## What that makes `main`

`main` is not the repository's tidy half. **It is the product.** It is the only thing that ever
gets copied, so its contents are the whole of what anybody receives, and every file on it is a
promise made to a stranger who cannot ask a question.

The agent branch is the opposite kind of thing: one agent's identity and one agent's record, true
in exactly one place, and worthless anywhere else.

So the shorter form:

> **`main` answers a question a stranger asks. The agent branch answers a question only this
> agent can ask.**

## The line that keeps getting crossed: definition against instance

Every pair that caused an argument on 07-09-2026 was the same pair.

| Needed by a copy | Not needed by a copy |
|---|---|
| what a post **is** | which post **this agent holds** |
| the frontmatter schema | a filled-in `state.md` |
| the handoff form | a handoff note |
| the entry shape for `knowledge/` | what one repository learned about its own machine |
| where proposals **go** | who **I** am |

A form is needed. A filled form is identity. Both are the same words on the page, and only the
test tells them apart.

## It is already mechanized, which is why the arguments were losable

Two tools implement the rule and neither of them was consulted before proposing against it.

- `tools/pr-guard.sh` holds an allowlist of the paths that may reach `main`. Anything else is
  rejected by path, before anybody reads the content.
- `tools/sync.sh` takes `main`'s version of every template file on the way down, which is what
  makes a copy's `main` a mirror rather than a fork.

**Every position lost on 07-09-2026 was a proposal that one of those two would have caught.**
Shipping posts as instances required widening the allowlist. Shipping nothing meant `sync.sh` had
nothing to carry. The tools were right first, twice.

## Why it kept being re-derived badly

The reasoning ran on analogies — *this is like `.canon`*, *this is like `.claude/skills/`* — and
an analogy gets the right answer only when the resemblance is the load-bearing part. It produced
the right answer twice and the wrong answer twice on the same day. The test produces it four
times, because it asks about the file rather than about what the file resembles.

## What is missing from the specification

**The test is written nowhere.** §6 describes the two tiers, the flow between them and the guard
on `main`. `pr-guard.sh` encodes the allowlist. Neither says *why those paths and not others*, so
the rule survives as a list to be matched rather than a question to be asked, and a list cannot
answer for a path nobody has proposed yet.

Proposed: the test goes into §6, in the paragraph that introduces the two tiers, before the
allowlist is ever mentioned.

---

# The same machine, at every level

Extended by the Principal on 07-09-2026. The test is not a rule about the canon. **It is a rule
about every `main`**, because any `main` can be copied, and a copy of a copy inherits whatever
sits on the one it came from.

## Everything is tested outside its own `main`

```
work branch  ──judged by the post──▶  this repository's main  ──if it generalizes──▶  upward
```

The same shape twice, and the canon is only the level with nothing above it.

| | In a copy | On the canon |
|---|---|---|
| where the work happens | a disposable branch | a disposable branch |
| where it is proven | outside `main`, on that branch | outside `main`, on that branch |
| who prepares the door | the **steward** | the **custodian** |
| who decides | that copy's Principal | the canon's Principal |
| what happens next | proposed upward when it generalizes | nothing above it |

§6 already says why the copy is the right place to run the test: it is the only place a rule can
be run against real work before anybody else inherits it. So a copy is not a lesser canon. **It
is where a change earns the right to travel.**

## A copy does not end the journey

A change landing in a copy's `main` is not finished. It gets a verdict, out loud: it travels, or
it stays and says why. **Neither answer may be the default**, because a default is what lets a
finding die where it was found.

The machinery for that half exists. §9 says a finding that generalizes goes upstream as a pull
request and never into the backlog, and one that stays carries `#propagate:DD-MM-YYYY` so
`tools/candidates.sh` measures the wait instead of the agent remembering it. What is missing is
only the framing: the sensor watches *findings*, and the unit that needs a verdict is any change
that **landed**.

## The gate upward has three parts, and all three bind

1. **Agnostic.** It describes nobody in particular: not one Principal, one agent, one project,
   one machine. This is `knowledge/`'s rule and it transfers unchanged.
2. **An improvement to the template.** Somebody else is better off holding it. Generic and
   useless is clutter in a place every copy inherits.
3. **Verified.** It was run here, against real work, and the entry says what was run. A guess
   that every copy inherits is worse than an absence, because it will be trusted.

A change failing any one of the three stays in the copy, and saying which one it failed is the
whole content of the verdict.

## Why the door has a keeper and not only a lock

A filled form is identity, and **no path pattern can see identity**. `tools/pr-guard.sh` can
prove a file is allowed to be on `main`. It cannot prove the file names nobody. That reading is a
judgment, and a judgment is what a post exists to authorize.

So the lock and the keeper answer different questions and neither replaces the other:

- The lock asks **may this path be here**, and it is mechanical, cheap, and never tired.
- The keeper asks **does this content belong to everybody**, and only a reader can.

That is why a proposal goes to a custodian rather than to a check, and why the custodian's verdict
is a recommendation rather than permission: the reading is the work, and the decision stays with a
person.
