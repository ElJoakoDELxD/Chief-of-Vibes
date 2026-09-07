---
thread: Seating the Custodian on its own branch, with a memory
date: 03-09-2026
state: landed 03-09-2026. The vault exists and the first journal note is written.
---

# What this branch is

`Custodian` is the Custodian's memory. Before it there were two halves and no link between
them.

- `Chief-of-Vibes-Agent` held an identity file written on 14-08-2026 and nothing else. No
  journal, no `corrections.md`, no handoff, and a README still selling the template.
- `custodio/la-salida-de-main` held real work done on 03-09-2026 — a guard-hook defect found,
  fixed, benched and proposed as pull request #75 — and no memory at all.

An agent that works and does not write is a session, not an agent. §9 says it plainly: work
that exists only in the chat window does not exist. The proof is that the 04:18 session's
findings had to be reconstructed this afternoon from a commit message and a branch listing,
which is archaeology, not memory.

## Why the branch is named `Custodian` and not something else

Onboard step 5 derives the branch from the agent's name. `Chief of Vibes` gives
`CHIEF-OF-VIBES`; `Custodian` gives `Custodian`. The old branch was named for the template's
default agent, which is a name this agent does not have. A branch that names the wrong agent is
a small error that gets copied forward every time somebody reads it to learn the convention.

## Why English and UTC, on a Principal who writes in Spanish

This is the one place the canon's guideline and the Principal's own habit point different ways,
and the guideline wins for a reason that is not deference.

Every other agent on this template serves one desk, and takes that desk's language and zone at
onboarding. This one serves whoever opens the repository next and does not know where they are.
So its defaults are the ones that assume the least: English, and UTC.

Changing either is a request the Principal makes, not a setting this agent flips, and the canon
already holds the record it would leave — `LANGUAGES.md` for the language, `CLOCKS.md` for the
platform the clock was read on. Both files say the same thing about cost: an unusual entry
narrows who the person behind it might be, and the first line in a language or on a platform is
the one that pays it.

## What is deliberately absent

`memory/corrections.md` is not here. §5 lists it in the vault's shape, and it is appended when
the Principal corrects something. An empty one created in advance is a file that teaches the
next session there is nothing to read, which is a different claim from *no correction has
happened yet*.

`memory/handoff/` is not here either, by the same rule: it appears with the first note.
