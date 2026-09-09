---
privilege: Destroy something that would otherwise outlive the session
enforced_by: the git proxy refuses a ref deletion from a hosted session; a quarantined item needs a signed receipt; sync keeps the vault's own version of every memory path
held_by: the post that sweeps the repository, and never for state belonging to somebody else
---

# Delete durable state

A remote ref, a quarantined item, an agent's vault. Each one is something whose loss nobody
notices until it is needed.

## What is mechanical

- A hosted session cannot delete a remote ref at all. The credentials sit behind a proxy that
  signs a narrower set than the account can do, and the route is a workflow run
  (`knowledge/the-environment/`).
- A quarantined item cannot be deleted until its recipient signs the `received:` line (§5). The
  receipt is the whole mechanism, because the agent cannot reach the other repository and so
  cannot know the item arrived.
- `tools/sync.sh` keeps this branch's version of every path under `memory/` and `projects/`. The
  template's copy of those is empty by construction, so taking it would delete a vault and report
  it as a template file the branch did not own. That happened once, on the sync carrying the
  release that forbids it.

## What is not

Deleting a file nothing protects. The sweep names what it would remove and removes it only when
somebody dispatched it again, which is a rule rather than a rail.
