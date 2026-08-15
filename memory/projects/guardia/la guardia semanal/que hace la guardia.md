---
thread: The weekly guard
date: 14-08-2026
state: wired on 14-08-2026. The first run has not happened yet.
---

# What the guard does, and what it must never turn into

One session a week, fresh each time. Five steps, then it stops.

1. **Mechanical health.** Every bench, `index.sh --check`, `sections.sh --check`, the sensors.
   Red is either fixed or reported with what could not be done.
2. **The door.** Open pull requests against `main`: prepare them, never decide them.
3. **What copies proved.** Releases living in somebody's copy that would help everyone get
   proposed here — never the reverse. Nothing flows down from this repository into a copy that
   did not ask.
4. **The doorman.** `tools/challenge.sh` rotates its class with the ISO week on its own. What
   the guard does is read the attempt log and move the difficulty **only on that evidence**.
   No attempts means nothing to tune, and it says so in one line.
5. **One report**, committed and pushed. Silence when there is nothing, rather than a paragraph
   saying so at length.

## The bound that matters most

An agent that adjusts its own door every week, with nobody watching, can drift toward
*impossible* — and nobody contributes — or toward *trivial*, and the door stops meaning
anything. **The dial moves on the record and never on an impression**, and every move goes in
the report with the number that justified it.

## Why the report is the deliverable and not the maintenance

Maintenance that nobody hears about is indistinguishable from maintenance that did not happen.
The report is how a Principal paying for this in inference can see what their week bought.
