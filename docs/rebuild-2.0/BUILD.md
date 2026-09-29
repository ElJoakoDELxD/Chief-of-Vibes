# Build brief: Stewie 2.0.0

The Principal approved `SPEC.md` on 29-09-2026. This brief says how to turn it into the first commit of the new repository. Where this brief and `SPEC.md` disagree, `SPEC.md` §2 governs; say so in the report.

## Where

- **Build in `/home/user/stewie`.** It is an empty clone of `github.com/ElJoakoDELxD/Stewie`, with no commits.
- **Read from `/home/user/Chief-of-Vibes`,** on branch `claude/repository-organization-dkragp`. Read `docs/rebuild-2.0/SPEC.md` in full, §2 twice. Never write there.
- **The product is named Stewie.** No file says Chief of Vibes, and no file explains the name.

## Sterile (D47)

Nothing is ported. No memory, no history, no agent and no content of today's `main` enters `Stewie`. The only files you may carry over are the verified components the spec names as already built. Carry each one as a file, rename what names the old product, and bring its bench with it:

- `tools/bin/clock`, `tools/bin/header` and `tools/test-clock.sh` (§5.5);
- `tools/sandbox/linux-x86_64/` and its `SOURCES.md` (D38, D46: in 2.0 these tools live on the agent's branch, so they go in the agent forms, not in `main`), with `tools/sandbox/activate.sh` and `tools/test-sandbox.sh`. Leave out the temporary `allowWrite` block of D51;
- `.claude/hooks/agent-permissions.sh` from branch `spike/s5-effects` (§5.3), ported and benched;
- `.claude/hooks/path.sh`, `guard-main.sh` and `guard-install.sh`, with their benches, only where §5.6 keeps them.

Everything else is written new, from the spec.

## Order

1. Make the tree of §5.1: the canon's `main`, plus the forms an agent's branch starts from.
2. Write `CLAUDE.md` as the index (D22): the north star quoted from §4, one line per rule that always holds, and a "when X, read Y" table. Keep it near 700 words.
3. Write the custodian role file (D17, D10, D19) and the agent file format with its default effects (D3, D11, §5.3).
4. Wire the hooks of §5.6 in `.claude/settings.json`, each with its bench.
5. Write the skills §5.7 keeps: `onboard`, `update`, `handoff` and `orchestrate`, each as short as it can be.
6. Write `README.md` for a person who does not program, and `CONTRIBUTING.md` in one page.
7. Write the CI workflow that runs every bench.
8. Run every bench. All must pass.
9. Grade yourself against §8, row by row, and fix what fails. A row that only the Principal can perform, or that needs GitHub settings, goes on the Principal's list.

## Git

- Make one commit in `/home/user/stewie`, on `main`, message `Stewie 2.0.0`, with the attribution trailers:
  `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>` and
  `Claude-Session: https://claude.ai/code/session_018kkyo2gMtZzMVs6GuY3ygw`.
- **Do not push.** The first push to the public repository waits for the Principal.
- Call git alone in every command, never chained and never with `-C` beside another command: under the sandbox, only a lone git call escapes it, and commits need that to be signed. Use `cd` in one call, then git in the next. The working directory persists between calls.

## Report (your final message)

1. The tree, as `find . -type f | sort`, excluding `.git/`.
2. Word counts: `CLAUDE.md` and the whole tree.
3. Bench results.
4. §8 row by row: passed, failed with the reason, or left for the Principal.
5. Every place where the spec was silent, contradicted itself, or could not be built as written, with what you did about it.
6. The Principal's list: GitHub settings (the protected branch, the tag ruleset and immutable releases of D50) and anything else only the Principal can do.
