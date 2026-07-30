# Contributing

This repository is the **canon**: the specification and its machinery, generic and identical for everyone. It carries no agent and no memory, and nobody works on it directly. It changes one way only, through a reviewed pull request.

If you are here to *use* the system, you do not need this file. Press **Use this template** on GitHub, open your copy, and the session will offer to create your agent. Everything below is for the other reason to be here: you want to change the template itself.

## What a template change is

The canon holds exactly two things: the spec, and the rails that enforce it. A pull request may touch only these paths, and CI rejects anything else:

```
SYSTEM.md  CLAUDE.md  README.md  CONTRIBUTING.md  LICENSE
repomix.config.json  .gitignore  .canon
.claude/   .github/   tools/
```

Agent memory (`memory/`) and project output (`projects/`) never belong here. They live on agent branches inside somebody's own copy. A pull request that carries them is not a template change, and the `template-only` check will say so by name.

## The rules that will judge your pull request

**Every merge is a release, so bump the version.** `SYSTEM.md` opens with a `**Version X.Y.Z.**` line. Patch for wording and fixes, minor for a new rule or mechanism, major for anything that breaks existing agents. CI refuses a pull request that leaves the number unchanged, because `git log` on the default branch is the changelog and a release with no version is a gap in it.

**One pull request, one change.** The changelog is only readable if each entry means one thing. Two unrelated fixes are two pull requests.

**Three documents, fixed roles, one commit.** `SYSTEM.md` is the specification. `CLAUDE.md` is the runtime entry point and carries only what must never be missed. `README.md` is the public description. If you change a mechanism, all three move together. The transparency table in SYSTEM.md §1 promises that nothing runs unless it is listed there, and a table that lags the machinery breaks that promise.

**New capability arrives as a skill.** One folder under `.claude/skills/<name>/`, one `SKILL.md` whose description states exactly when it triggers, opening by naming the §3 rules it rides. A skill must have produced at least one real result before it is proposed. Provenance goes in the file: what it is based on, and where that came from.

**Rails are testable.** Anything under `.claude/hooks/` decides whether real work is allowed to happen. If you change one, bring its test. `tools/test-guard-main.sh` is the pattern: assert what must be blocked *and* what must be left alone.

## Opening a pull request

1. Branch from the default branch. Name it for the change, not for yourself.
2. Make the change, bump the version, keep the three documents in sync.
3. Run whatever tests exist under `tools/` and say in the description what you ran.
4. Open the pull request. Describe what changed, why, and what you deliberately did not change. If you considered a bigger version bump and chose a smaller one, say why.
5. Wait for the `guard` workflow. Both of its checks are cheap and both are absolute.

A good description is not a diff in prose. It names the failure the change closes, and it is honest about the limits of the fix.

## What the guards actually do

| Guard | Where | What it catches |
|---|---|---|
| `guard-main.sh` | local, before every edit and shell command | work landing on the default branch by accident |
| `guard` / `template-only` | CI, on every pull request | files outside the template allowlist |
| `guard` / version bump | CI, on every pull request | a merge that would leave the changelog silent |

None of them is a lock. The local hook only runs in sessions that wire it, and it matches strings, which is not the same as understanding intent. The server-side lock is branch protection on the default branch plus a human reading the diff. Treat all three as defence in depth and none of them as permission to stop reading.

## A worked example

Release 1.4.0 is a small, complete instance of this flow, and it is worth reading as a whole: [pull request #5](https://github.com/ElJoakoDELxD/Chief-of-Vibes/pull/5).

An agent running in a hosted session installed two third-party skill packs into `~/.claude/skills/`, warned its Principal in the same reply that the directory does not survive the container, and then committed an installer script to compensate. Three true statements, one incoherent outcome: the repository ended up advertising a capability that no future session would have. The Principal noticed the contradiction and asked for the rule that prevents it.

What happened next is the whole procedure in miniature. The agent deleted the installer from its own branch. It wrote the limit into `SYSTEM.md` §4 with the delegation path attached, added the matching line to `README.md` so the public description did not drift, bumped 1.3.0 to 1.4.0 because a new rule is a minor release, and wrote in an explicit exception so the limit would not also forbid ordinary repository-owned dependencies. It pushed a branch to the canon and stopped there. Opening the pull request waited for the Principal, and so did the merge.

The lesson worth copying is not the rule. It is the shape: a real failure found by hitting it, the smallest spec change that closes it, an exception written in on purpose so the fix does not overreach, and every gate left in the hands of a person.

Release 1.4.1 is the counterpart, a rail correcting itself. The guard hook denied a legitimate branch deletion because a quoted string elsewhere in the same command mentioned the protected branch. It went on to deny the commit that fixed it, for the same reason, which is about as clear a signal as a defect ever gives. The fix scopes matching per command segment and ships with the test bench that proves it: red before, green after.

## Reporting instead of fixing

An issue is welcome and costs you less than a pull request. The useful ones name the session where the system did the wrong thing, quote what it actually said or did, and state which section of `SYSTEM.md` you expected to prevent it. "The spec should also cover X" is a fine issue. So is "§5 says one thing and the hook does another."

The system is built on the claim that its rules are visible and enforceable. Every place that turns out not to be true is worth knowing about.
