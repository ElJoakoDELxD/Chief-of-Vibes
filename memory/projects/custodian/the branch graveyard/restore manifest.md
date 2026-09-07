---
thread: The branch graveyard
date: 07-09-2026
state: backup taken 07-09-2026. Deletion refused by the git proxy with 403, so nothing was removed.
verified: every SHA read from `git ls-remote --heads origin` and tested with
  `git merge-base --is-ancestor <sha> origin/main`. The deletion limit was tested from two
  different checked-out branches, and read against Anthropic's published documentation.
---

# Restore manifest for every branch on the canon

Taken before deleting anything, on the Principal's instruction. `origin/main` was at
`8014ab7` when this was written.

**A branch marked MERGED is contained in `origin/main`.** Deleting its ref removes a name and
no commit. The commit stays reachable from `main` forever. Restoring one is a single command:

```
git branch <name> <sha> && git push -u origin <name>
```

## Merged, and safe to delete

| Branch | Tip |
|---|---|
| `claude/corrections-register` | `1582539e56427f7230f9afe4425a0c54c963b59f` |
| `claude/invocation-from-the-runtime` | `f51023357b19d8b2535c394d77f37fefe6107da8` |
| `claude/no-silent-skills` | `147e32b8d7d382fb26dec2884519216d18ddba3b` |
| `claude/now-marks-its-default` | `f0cf7a670f95f27a5e3ff6838e3c5125e239d2ea` |
| `claude/principal-correction-is-a-trigger` | `b544a3466f5f85bf471f8416b47e816c268e921f` |
| `claude/rebased-25` | `c671e96051b6a3e2a6e98f6542d3382bc2c26772` |
| `claude/rebased-26` | `0c3587854090fd895e974b4a10bf8a0315a0eb5c` |
| `claude/rebased-28` | `7a0b0c730c1e91ab6c511b3e83ec2af9d3b6518e` |
| `claude/redundancy-not-length` | `81878970fbfa7082d39ec1c31e27b53119326964` |
| `claude/relay-before-the-block` | `6fa3da005f13e9e9fabd0e64e9c2361f3ca59637` |
| `custodian/the-bench-that-expired` | `f956cc4bbe8a8a1720cb54da1f8a91a048a3c73b` |
| `custodian/the-canon-quotes-no-one` | `d87a43a0fd6bbaad5cbcd38c0de30b21b6b1111f` |
| `custodio/la-salida-de-main` | `c7f0c8093eff545ca6dd94f583cebebaa53fdd98` |

Thirteen, not the three the backlog named. The three work branches were the ones anybody had
looked at. Ten chat branches from earlier template work sat under the same rule and nobody swept
them.

## Not merged, and not this agent's to delete

These carry commits `main` does not have. Calling them dead is a judgment about content, so the
record names what is on them and stops there.

| Branch | Ahead | Top commit |
|---|---|---|
| `claude/propagate-skill` | 11 | Make propagate fire from the situation, and refuse rewordings |
| `claude/five-s-skill` | 7 | Split 5s into a sequential worker and an independent monitor |
| `claude/merge-stack-27` | 4 | Repoint the stack layers at their rebased heads |
| `claude/harness-runs-anywhere` | 1 | Say that every surface reaches the same agent |

Both skills exist in the tree today, so the first two were most likely re-authored and landed
under other commits. That is a guess and it is marked as one. Read them before deciding.

`Chief-of-Vibes-Agent` and `Custodian` are the two memory branches and neither is a candidate.

## Why nothing was deleted

`git push origin --delete <branch>` returns, every time:

```
error: RPC failed; HTTP 403 curl 22 The requested URL returned error: 403
```

**The refusal comes from the git proxy, and the earlier diagnosis in this file was wrong.**
There are two proxies in a cloud session and they are not the same component.

| Proxy | What it is | Reports failures where |
|---|---|---|
| agent egress proxy | HTTPS policy proxy on `127.0.0.1:40607`, CA bundle in `/root/.ccr/` | `/__agentproxy/status`, key `recentRelayFailures` |
| **git proxy** | holds the git credentials **outside** the sandbox and authenticates on the session's behalf with scoped credentials | nowhere the session can read |

The first reading here checked `recentRelayFailures`, found it empty, and concluded GitHub had
refused. That checked the wrong proxy. The git proxy is the one in the path of a push and it
does not report into that endpoint.

Anthropic's own documentation states the credential arrangement and one half of the restriction:

- *"git credentials and signing keys stay outside the sandbox, and a proxy authenticates on the
  session's behalf with scoped credentials"* (Claude Code on the web, Security and isolation).
- *"**Push protection**: `git push` works only against the session's current working branch;
  cloning, fetching, and PR operations work normally"* (Configure cloud environments).

## What was measured here, and it is the other half

The branch-scoping rule above does not explain this refusal. Tested in this session:

| Operation | Result |
|---|---|
| push a new branch, standing on it | allowed — `custodian/the-bench-that-expired` was created this way |
| push an update to the working branch | allowed, repeatedly |
| `--delete`, standing on another branch | **403** |
| `--delete`, standing on the branch itself | **403** |
| `--force` (recorded 03-09-2026, three attempts) | refused |

Checking the branch out first was the test that separates the two explanations, and it failed
the same way. So the limit is not which branch the push names. **The git proxy permits ref
updates that create or advance a ref, and refuses ref updates that destroy one.** That half is
not written on the documentation page that carries the branch rule.

## What cannot fix it

`Allow unrestricted git push`, the environment setting that lets a session push to any branch
including the default one, is about **which branch** and not **which operation**. Nothing found
in the documentation or the tracker grants ref deletion to a cloud session. A Bash permission
rule in `settings.json` cannot reach it either, because the refusal is at the remote end of the
push and not at a local prompt.

## What does

**A runner.** It is a different origin: same repository, its own token, no proxy in between.
`.github/workflows/stacks.yml` and `create-release.yml` already use that shape for the same
class of problem, and `stacks.yml` states the principle in its own header — *the block is on the
origin, not the authorization*. Reading it was what turned this from a dead end into a route.

Prepared 07-09-2026 as pull request #78, version 1.66.0: `tools/sweep-branches.sh` with ten bench
cases against a real bare repository, and `.github/workflows/sweep-branches.yml` to dispatch it.
It reports by default and deletes only on a deliberate input. Containment is re-tested at run
time rather than read from this file, because a list is true when it is written and not when it
runs.

Two others, neither of which was available today:

1. GitHub's own interface. *Delete branch* on each merged pull request, or the branch list.
2. A local session using the Principal's own git credentials. The git proxy is not in that path.

**And the durable fix, which is a repository setting and not a template change:** GitHub's
*Automatically delete head branches*, under Settings, Pull Requests. It stops the graveyard
re-forming. It does not touch what is already there.

## The sweep, ready to paste in a local session

Run from a clone of this repository, on a machine whose git credentials are the Principal's own.
It refuses to touch anything `main` does not already contain, so the safety check runs again at
the moment of deletion rather than resting on this file being current.

```bash
git fetch origin --prune
for b in $(git ls-remote --heads origin | sed 's#.*refs/heads/##' \
           | grep -vE '^(main|Custodian|Chief-of-Vibes-Agent)$'); do
  sha=$(git rev-parse "origin/$b")
  if git merge-base --is-ancestor "$sha" origin/main; then
    echo "deleting $b  $sha"
    git push origin --delete "$b"
  else
    echo "keeping  $b  (not contained in main)"
  fi
done
```

Expected: thirteen deleted, four kept. The four kept are the unmerged `claude/*` branches listed
above, and they stay for a person to read.
