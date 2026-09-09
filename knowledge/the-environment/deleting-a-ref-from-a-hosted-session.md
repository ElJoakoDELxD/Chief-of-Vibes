---
topic: A hosted session cannot delete a remote ref, and a workflow run is the route
verified: measured against the git proxy, which returns 403 on a delete and on a force-push while ordinary pushes from the same session succeed. The workflow route has run repeatedly, deleting landed branches a session had just been refused
---

# Deleting a ref from a hosted session

## When this applies

A session runs somewhere it did not build: a hosted container, a cloud runner, any place where git
credentials are held outside the process. Pushes work. A branch deletion returns 403, and so does a
force-push.

## What is happening

The credentials are not in the session. A proxy holds them and signs requests on the session's
behalf, and it signs a narrower set than the account can do. An ordinary push is inside that set. A
ref deletion and a force-push are not.

**Two proxies are easy to confuse, and reading the wrong one wastes the search.** An egress proxy
carries HTTP traffic and reports on relays it refused. The git proxy is a different thing, holds the
credentials, and refuses by verb. An empty failure list in the first says nothing about the second.

## Procedure

Move the operation to a workflow run, which is a different origin: its own token, no proxy in front
of it, and permissions the repository grants it directly.

1. A workflow with `workflow_dispatch` inputs, and `permissions: contents: write`.
2. It runs the tool from the repository rather than holding the logic itself. Logic that lives only
   in a workflow is logic whose failure mode is a green check.
3. The session dispatches it and reads the result.

The same shape answers anything the proxy refuses by verb rather than by target.

## Traps

- **A green run that did the wrong work.** The runner checks out the branch it was told to, and runs
  *that branch's* copy of the tool. A branch synced and not pushed runs the older tool, which ignores
  an argument it does not know and reports success for a different operation.
- **Reading the refusal as the account's limit.** The account can delete the ref. The session cannot.
  A *cannot* measured from one origin is not a *cannot*, and naming the frame is what finds the route.
- **Reaching for a local machine first.** That is a real answer and it is rarely the nearest one. The
  repository's own automation is already inside the permissions the owner granted.

## How to tell it worked

The ref is gone from `git ls-remote`, read after the run rather than assumed from its conclusion.
