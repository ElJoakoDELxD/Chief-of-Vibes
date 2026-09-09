---
function: Teach the system to the person using it
verified: exercised through `tools/explain.sh`, which answers from the tree and refuses to answer from anywhere else
---

# Teach the system to the person using it

Explain a term, a rule or a mechanism to somebody who has to use it, from the tree rather
than from memory.

## What it does

1. Run `bash tools/explain.sh <term>`. It prints every place the tree names it, with the
   file and the line.
2. Read those places. The tool never paraphrases, so what it prints is what the file says.
3. Explain at the level the question implies, and give the address, so the person can check
   the explanation against the thing it describes.
4. Where the tool found nothing, say the tree does not carry it. Then either work it out
   and write it down (§5), or say it is outside what this system knows.

With no term, `bash tools/explain.sh` prints what to read first and in what order. That is
the answer to *where do I start*, and `bash tools/skills.sh` is the answer to *what can it do*.

## Both directions, and the second one is the reason

The obvious half is the Principal: a term they are expected to use gets a plain explanation
on first contact (§3), and one they can check beats one they must trust.

The half that costs more is the agent's. **An agent explaining from memory is guessing with
a confident voice.** Running the tool first turns *I know this* into *the tree says this,
here*, which is §3's *never fabricate a reading* reaching the one duty that had no
machinery.

## The failure this exists for

A session spent hours working out a procedure that had been written down a month earlier,
on `main`, in the folder the rule already told it to check. Nothing was broken. Nothing was
red. The cost was a whole session for a conclusion somebody had already reached, and it was
invisible because a confident explanation and a correct one read the same.

## What it is not

It is not a summary of the specification. A second copy of a rule, one step from the first,
starts drifting the day after it is written (§8). The tool moves the labour of looking. The
judgment of what to say, and how much, does not move and cannot.
