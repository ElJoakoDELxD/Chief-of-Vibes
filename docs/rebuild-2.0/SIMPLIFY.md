# Simplify loop

The Principal's order, 28-09-2026: reduce everything to its simplest version, with the fewest turns. The goal is functionality, not security on top of security. Do not start over: simplify what exists, summarise it, and break nothing.

## One pass

1. **List** every mechanism the target holds: each decision, hook, file, rule, skill and rubric row.
2. **Ask of each one, in order:**
   - Does it serve the north star (functionality for a person who does not program)? If not, cut it.
   - Does another mechanism already do its job? Then merge the two into one.
   - Is there a simpler version that gives the same result? Then use that version.
   - Is it a guard behind another guard? Keep the one that does the job and cut the rest.
3. **Apply** every cut that removes, merges or shortens without changing what a Principal decision means. A cut that changes a decision's meaning is not applied. It goes on the list for the Principal, one line each, with the simpler version proposed.
4. **Prove nothing broke.** Every bench passes. No text points at something that no longer exists. `SPEC.md` does not contradict itself.
5. **Report** the net result: words, files, decisions, hooks and rules before and after, plus the list for the Principal.

## Targets, in order

1. `docs/rebuild-2.0/SPEC.md`
2. The tree the spec builds (hooks, tools, skills)
3. This file

Each pass is delegated. The main session writes the brief, a subagent executes it, and the main session checks the result against this file. The Principal decides when another pass runs.
