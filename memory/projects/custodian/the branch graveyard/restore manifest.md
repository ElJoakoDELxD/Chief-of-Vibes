---
thread: The branch graveyard
date: 07-09-2026
state: backup taken 07-09-2026. Deletion refused by GitHub with 403, so nothing was removed.
verified: every SHA below read from `git ls-remote --heads origin` and tested with
  `git merge-base --is-ancestor <sha> origin/main` in the same session.
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

`git push origin --delete custodian/the-bench-that-expired` returned:

```
error: RPC failed; HTTP 403 curl 22 The requested URL returned error: 403
```

The 403 came from GitHub and not from the agent proxy. The proxy's own
`recentRelayFailures` stayed empty across the attempt, and its README says the proxy records
its refusals there. An ordinary push in the same session succeeded immediately afterwards, and
`git ls-remote` shows none of the three branches is protected. So the host, the network and the
write credential all work. **Deleting a ref is what is refused.**

This corrects the diagnosis carried on the `Custodian` branch since 03-09-2026, which named the
harness permission classifier. The block is at the remote, not local. It is the same class as
the force-push refusal recorded there: **push allowed, force-push refused, ref delete refused**,
which is a deliberate restriction on destructive ref updates rather than a misconfiguration.
