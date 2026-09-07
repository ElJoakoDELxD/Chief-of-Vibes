---
thread: What main is for
date: 07-09-2026
state: the Principal's rule, stated 07-09-2026. Unimplemented.
reads: the membership test.md, the proposal does not stop.md
---

# A copy of a copy goes back to the blueprint, and says so in prose

Set by the Principal on 07-09-2026, and it corrects an earlier finding in this thread.

## Provenance is a fact, not a route

**A copy of a copy proposes to the blueprint. It does not proxy through the copy it came from.**
It only knows that it was copied from a copy.

That collapses the two-pointer design proposed this morning. One pointer to the blueprint is all
any generation needs, because every generation talks to the same place.

**And it dissolves the defect that design was built to fix.** The finding said a copy of a copy
syncs against the root while its template came from an intermediate, so it misses whatever that
intermediate shipped. Read again with the rule above, that is not a defect. If the intermediate
is ahead of the canon, it is holding changes it has not proposed — its own debt, not something
its copies inherit. **Sideways propagation is what would split the canon into dialects, and
refusing it is the system working.**

So a second pointer as a *route* is unnecessary. The provenance itself is still worth recording,
and it is recorded twice for two different readers: **`.blueprint` on the copy's role branch**,
which the drift check reads, and **a line in the copy's `main` README**, which a person reads.
See `../canon-identity/custody-is-the-roles.md` for the naming.

## The two READMEs, and only one of them exists today

**The agent branch's README describes the agent.** Onboard step 6 already writes it, and
`tools/sync.sh` already protects it: on the second hop, template files take `main`'s version and
`README.md` keeps the branch's.

**A copy's `main` README describes nothing.** It is the canon's sales page, inherited unchanged,
and it is addressed to a reader standing on the canon: *your first act is making your own copy*.
That sentence is wrong the moment somebody reads it inside one. Every copy that exists is
shipping instructions to a place its reader already left.

**So the agent rebuilds it, with its Principal's specifications:** whose repository this is, what
it is for, which agent lives here, and where it came from. **That last line is where provenance
belongs** — a sentence a person reads, not a file a machine follows.

## Which is exactly the membership test, on the one file that changes sides

A fresh copy needs *a* README to become itself, so the canon ships one. The filled version is
identity, so the copy owns it from then on.

**`README.md` is the one template file that becomes identity the moment a copy exists.** Every
other file on `main` stays what the canon made it; this one is a starting text that gets
replaced, and being a form rather than a fact is what it has in common with `state.md`'s
frontmatter and the handoff shape.

## The mechanical gap

The second hop already carves `README.md` out. **The first hop does not.** A copy's `main` takes
the canon's template wholesale, by *Sync fork* or by the pull request §6 describes, and a rebuilt
README is overwritten by the next one. The same carve-out has to exist at both hops, and §6 has
to say so where it describes the first, because that hop is a pull request an agent opens and a
person approves rather than a script anybody can fix.
