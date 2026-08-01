# 5s · tree

Target: the repository as it sits on disk — and, critically, what this session wrote *outside* it.

## Measure

File count and bytes inside the tree, plus an explicit list of paths touched outside it:

    git status --porcelain
    git clean -nd
    du -sh .

`git status` is the weakest of these on its own: it shows what git tracks, and the whole failure mode of this target is the part git never sees.

## What each step means here

**Sort — inside.** Build artifacts, stale clones, caches, scratch directories, half-finished branches, files outside the guard's allowlist that were never going to be committed. `git clean -nd` lists candidates; read the list before acting on it, because it is equally happy to name something you meant to keep.

**Sort — outside, and this is the step the target exists for.** A tool that installs is not limited to putting files where you looked. On 31-07-2026 an installer wrote `~/.claude/CLAUDE.md` — global instructions injected into every session of every project, from a package installed into a container that was about to be discarded. The install command exited zero. Nothing in the repository showed it. So: for every installer, generator or setup script this session ran, ask what it wrote outside the working tree, and go read those paths. `~/.claude/`, shell profiles, global config directories, tool caches with executable shims.

The general form: **check what an installer wrote outside the tree, not just whether the command succeeded.**

**Set in order.** What remains goes where the guard expects it. Anything that survives the sort but sits outside the allowlist belongs on an agent branch or in a scratch directory, not next to the template.

**Shine.** Read what stayed. This is where a leftover file turns out to still be referenced, or a script turns out to promise an install that §4 forbids — a residue sweep that only deletes never finds those.

**Standardize.** Prefer a rail. `guard-install.sh` exists because one residue sweep was one too many; a finding that a hook could have blocked should become a hook, with a bench pinning both what must be blocked and what must be left alone.

**Sustain.** Trigger: any session that installed, generated, or built. Not a calendar.

## Traps

- **Deleting before reading.** A directory that looks like a dead half-clone may be a live one. Verify — `git -C <path> rev-parse HEAD`, or watch `.git` grow — before removing anything you did not create in this session.
- **Reporting the outcome instead of the reach.** "Uninstalled cleanly" describes the exit code. The report names the paths inspected outside the tree, including the ones that turned out clean, because that list is the evidence and its absence is indistinguishable from not having looked.
- **Sweeping an ephemeral container and calling it durable.** Removing residue from a filesystem that will not survive the session accomplishes nothing except in the places that *are* persistent — which is precisely where the damage lives (§4).
