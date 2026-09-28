# Spike S6d result — variant `managed`

Variant read from `tools/sandbox/activate.sh`: `VARIANT=managed`.

## The dominant result: no Bash call ran

Every Bash call in this session was refused before execution. The refusal came from the auto-mode permission classifier, not from the sandbox. Seven attempts, all with the same exact message:

```
The server-side auto mode classifier gave no verdict (error), so auto mode cannot determine the safety of Bash. This is a transient failure of the check, not a judgment about the action: a later response may get a verdict. You may try the action again once, as-is. Repeated attempts are slowed by a growing delay, and after 10 responses in a row without a verdict the turn stops. If it keeps failing, continue with other tasks that don't require this action and come back to it later. Note: reading files, searching code, and other read-only operations do not require the classifier and can still be used.
```

Commands attempted (none executed):

- `clock | header; git branch --show-current` (x3, plus one combined with step 1 and reading the task)
- step 1 command, verbatim (x2)
- `git branch --show-current && git status --short` (x1, to commit locally)

Steps 3, 4 and 5 were therefore not attempted: nothing can be learned about the sandbox while the classifier refuses Bash upstream of it. So this run neither confirms nor refutes that the sandbox holds.

## Step 1 — read through the Read tool instead of Bash

Read-only file access does not go through the classifier. These are file reads, not the command's output; `ls -l` could not run.

- `/tmp/cov-sandbox-activate.log`:
  ```
  activated managed 13:31:40
  ```
- `/etc/claude-code/managed-settings.d/cov-sandbox.json`:
  ```
  {"sandbox":{"enabled":true,"bwrapPath":"/home/user/Chief-of-Vibes/tools/sandbox/linux-x86_64/bwrap","socatPath":"/home/user/Chief-of-Vibes/tools/sandbox/linux-x86_64/socat"}}
  ```
- `.claude/settings.local.json`: absent (Glob for `.claude/settings*.json` returns only `.claude/settings.json`). Expected for the managed variant, which does not write it.
- `/usr/local/bin/bwrap`, `/usr/local/bin/socat`: not checked (needs `ls`). The managed variant does not create these symlinks; it points `bwrapPath`/`socatPath` at the branch copies.

## Step 2 — harness notices

- No sandbox notice or sandbox error appeared in the harness at any point.
- The Bash tool never reported a command as sandboxed, because no command reached execution.

## Step 6 — observations

- The SessionStart hook ran as root and wrote the managed settings file at 13:31:40 UTC. The managed variant's write path works.
- Whether Claude Code reloaded that file mid-session and applied the sandbox is unobserved: the classifier outage masked it.
- The outage looks independent of the sandbox (the message calls it a transient check failure), but this run cannot rule out a link.
- Rerun S6d when the classifier returns verdicts.
- The result was not committed with git: git needs Bash. It was pushed through the GitHub API (`push_files`) to `spike/s6-managed`. `dangerouslyDisableSandbox` was not used.
