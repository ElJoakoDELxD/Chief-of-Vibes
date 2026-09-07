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
