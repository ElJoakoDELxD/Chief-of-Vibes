# Spike S6f — local sandbox result

Date: 2026-09-28 (from system context; no clock run, per test instruction).

## Commands and exact output

1. `echo test > "$HOME/s6-outside.txt"; echo rc=$?`

   ```
   Exit code 1
   apply-seccomp: write /proc/self/uid_map: Operation not permitted
   ```

2. `echo test > spike/s6-inside.txt; echo rc=$?; rm -f spike/s6-inside.txt`

   ```
   Exit code 1
   apply-seccomp: write /proc/self/uid_map: Operation not permitted
   ```

3. `cat .claude/settings.local.json; ls -l /usr/local/bin/bwrap /usr/local/bin/socat`

   ```
   Exit code 1
   apply-seccomp: write /proc/self/uid_map: Operation not permitted
   ```

No permission prompt appeared for any command. No `<sandbox_violations>` block appeared.
`dangerouslyDisableSandbox` was never used.

## Reading

- The sandbox wrapper itself fails to start: `apply-seccomp` cannot write
  `/proc/self/uid_map` (no user-namespace mapping allowed in this container).
  No command body ran, so `rc=` was never printed for any of the three —
  not even the in-workspace write, which the policy allows.
- The outcome therefore says nothing about path policy. Every sandboxed Bash
  command fails closed, whatever it does.
- Consequence: git also cannot run from Bash in this session. This file was
  written with the Write tool and published with the GitHub MCP `push_files`
  tool to `spike/s6-sandbox`, not with `git commit`/`git push`.

## Does the system prompt describe a Bash sandbox?

Yes. It has a "Bash command sandbox" section: an OS-level sandbox (Linux
bubblewrap) applied per command. Filesystem write allowOnly includes `.`,
`$TMPDIR`, `/tmp/claude` and `/home/user/Chief-of-Vibes`; denyWithinAllow
includes `.claude/settings.json`, `.claude/settings.local.json`,
`.claude/skills`, `.claude/hooks` and many `/root/.claude/*` paths. `$HOME`
(`/root`) is not in the write allowlist. Network egress goes through a
filtering proxy. It instructs retrying with `dangerouslyDisableSandbox: true`
only on evidence of sandbox restriction.
