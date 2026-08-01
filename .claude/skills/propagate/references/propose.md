# propagate · propose

Direction: this copy → the canon. Opens a pull request against a repository the Principal does not own, so this is the direction with the most ways to go wrong.

## Before anything

- **The gate in SKILL.md, answered in writing.** All three questions. Question 2 is the one that fails quietly: a rule that reads as universal because it is phrased universally, but whose only evidence is this Principal's toolchain.
- **The canon is `.canon`**, read from the file rather than assumed — a copy that hard-forked edited it, and proposing into the wrong repository is not recoverable by editing the pull request.
- **One change per pull request** (§8). A proposal carrying two ideas gets the weaker one merged with the stronger.

## The change itself

- **Bump `SYSTEM.md`** — patch for wording, minor for a new rule or mechanism, major for anything that breaks existing agents. CI rejects the pull request without it, and the version is what the drift check in every other copy compares against.
- **Three documents, fixed roles** (§8). A mechanism touches `SYSTEM.md`, `CLAUDE.md` and `README.md` in the same commit. The §1 table promises what runs automatically; a dispatch-only tool does not belong in it, and adding it there makes the table wrong in the other direction.
- **Where the rule lives is part of the proposal**, not a detail. §3 is the whole of rung 4; a mechanically decidable rule filed there is misplaced, and a judgment call filed as a rail teaches every future agent to route around a rail that lies.
- **If it grows the machinery and the prose both, it is not finished** (§8). Pay for the prose — the `5s` skill on the `documents` target exists for exactly this and is the cheapest way to satisfy the criterion honestly.

## The pull request body

Written for a reader who has never seen this copy and never will. It carries:

- **The failure**, concretely: what was attempted, what the tool returned, why the existing specification did not prevent it. This is the part that makes a proposal reviewable — a reviewer cannot judge a rule without the wall it was written against.
- **What changes**, and the rung it lands on.
- **What it does not change**, especially anything a reader would reasonably assume it does.
- **Verified, not assumed**: what was actually run. A proposal claiming a mechanism works, from a session that never ran it, is the failure mode this system has hit most often.

Nothing of the Principal, per SKILL.md. Check the body for it before opening, not after: a pull request body is public and editing it later does not unpublish it.

## Traps

- **Proposing the workaround instead of the rule.** The environment quirk that cost three attempts is `knowledge/` in this copy. What goes up is the *judgment* the quirk taught, if there is one — and often there is not, which is a fine answer.
- **A rule the agent cannot obey.** If the runtime, not the agent, controls the thing being ruled on, the rule is decoration and will be routed around. Rule what the agent writes, not what the platform stamps.
- **Assuming the copy is current.** A proposal drafted against an older `SYSTEM.md` may be re-adding something the canon already fixed. Check the canon's version first; if this copy is behind, `sync` comes before `propose`.
