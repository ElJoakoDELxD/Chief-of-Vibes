---
name: ste-writing
summary: The controlled language this system writes in by default, and the linter that scores it.
description: The controlled writing system this system uses by default for all prose (SYSTEM.md section 3). Read it when you need a rule itself. It holds the word discipline, the sentence discipline, the two lengths, and the linter. Read it before every publish. Read it when the Principal asks for clear or simple text. Read it when tools/prose-lint.sh reports a score above the gate. It does not govern code and identifiers, quoted material, or work the Principal asks for in an authorial voice.
---

# ste-writing

Rides SYSTEM.md section 3: *write in the controlled language, by default*, and *done is earned by verification*. That rule names this file. This file holds the rules, and the score is the check.

**The default is on.** Section 3 makes this system the one every piece of prose starts in. This file is not a mode to switch on. It is the rules themselves, for the moment you need to check one.

This file follows its own rules. That is the test of the system. The authors of ASD-STE100 wrote the manual in the language it defines. A writing rule that its own text breaks is decoration.

## The system

The source is ASD-STE100, the controlled language for aircraft manuals. One principle carries all of it: **one word, one meaning. One sentence, one act.**

**Words.** Use one name for one thing. Choose the short common word: use, get, show, start, help. Do not decorate: no *seamless*, *robust*, *powerful*, *cutting-edge*. Give numbers, not scale words.

**Verbs.** Active voice. A sentence names who acts. Write "the guard rejects the file", never "the file is rejected".

**Sentences.** One instruction per sentence. Keep instructions under 20 words and descriptions under 25. Do not stack clauses to smuggle a second sentence into the first.

**Punctuation.** No em-dashes. No semicolons. A period is enough. No contractions. Keep the articles: a, an, the.

**Structure.** One topic per paragraph, six sentences at most. Steps go in numbered lists, one action per step, in the imperative.

## Two modes

**Strict** is for procedures, error messages, and anything a person follows under pressure. Every rule applies. Both length caps apply.

**Flavored** is for general published prose. Sentence discipline, active voice, and plain verbs apply. The vocabulary rules relax where a common word would misname the thing.

## The measure

    bash tools/prose-lint.sh <file.md>

The linter counts violations per 100 words. The publication gate is **under 1.5**. Run it before the sweep in section 7. Fix what it names. Put the score in the pull request body. The score is not the quality. It is the floor under the quality. A text can pass the linter and still say nothing.

## Provenance

The standard: ASD-STE100, Simplified Technical English, first issued 1986. The evidence that it moves models comes from woosal1337's cross-model experiment (blog, ep01). The experiment gave the system to Claude as a skill and measured a 74 percent drop in violations. Style advice scored 43 percent. A banned-word list scored 3 percent. The linter here is this repository's own implementation of that experiment's idea. This file scores under the gate it sets.
