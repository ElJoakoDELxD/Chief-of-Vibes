# Spike S6 result: the sandbox does not hold Bash

Session: child, branch `spike/s6-sandbox`, 28-09-2026 13:04 UTC, cloud container (claude.ai/code).

## 1. Tools on PATH

```
$ which bwrap socat; echo "$PATH"
/home/user/Chief-of-Vibes/tools/sandbox/linux-x86_64/bwrap
/home/user/Chief-of-Vibes/tools/sandbox/linux-x86_64/socat
/home/user/Chief-of-Vibes/tools/bin:/home/user/Chief-of-Vibes/tools/sandbox/linux-x86_64:/home/user/Chief-of-Vibes/tools/bin:[... tools/bin repeated ~30 times ...]:/root/.local/bin:/root/.cargo/bin:/usr/local/go/bin:/opt/node22/bin:/opt/maven/bin:/opt/gradle/bin:/opt/rbenv/bin:/root/.bun/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

$ bwrap --version; socat -V | head -1
bubblewrap 0.9.0
socat by Gerhard Rieger and contributors - see www.dest-unreach.org
```

Both binaries resolve from the repository (`tools/sandbox/linux-x86_64/`) and run.

## 2. Does the harness report the sandbox as active?

No.
- No sandbox notice appeared at session start or on any Bash call.
- The Bash tool description does not mention a sandbox. It has a `dangerouslyDisableSandbox` parameter, which exists whether or not the sandbox is on.
- No sandbox errors appeared.
- `.claude/settings.json` has `"sandbox": { "enabled": true }` and puts `tools/sandbox/linux-x86_64` on `PATH` through `env`.
- The environment shows `IS_SANDBOX=yes` and `ANT_IMAGE_REPOSITORY=sandbox-ccr-default`. These describe the cloud container, not the Claude Code Bash sandbox.

## 3. Write outside the project

```
$ echo test > "$HOME/s6-outside.txt"; echo rc=$?
rc=0
$ ls -l "$HOME/s6-outside.txt"
-rw-r--r-- 1 root root 5 Sep 28 13:05 /root/s6-outside.txt
```

The write succeeded. The sandbox did not block it. The file is left in place in the ephemeral `$HOME`.

## 4. Write inside the project

```
$ echo test > spike/s6-inside.txt; echo rc=$?
rc=0
$ rm spike/s6-inside.txt; echo rm_rc=$?
rm_rc=0
```

## 5. Network

```
$ curl -sS -o /dev/null -w '%{http_code}\n' https://api.anthropic.com
404
```

The request reached the server through the container proxy. A 404 on the bare host is a normal reply.

## 6. Observations

- The tools the repository carries are found and run: bwrap 0.9.0 and socat.
- The sandbox does not hold Bash in this session: a write to `/root` succeeded with rc=0.
- The harness gave no sign that it applied the sandbox: no notice, no error, no denial.
- The likely cause is that the cloud harness ignores `sandbox.enabled` or does not start its sandbox here. This session did not test that cause.
- Network is not restricted by a Claude Code sandbox. It goes out through the container's own proxy.
- `PATH` carries `tools/bin` about 30 times. Something prepends it again on each hook or shell start and never checks whether it is already there. This does no harm, but it is a separate defect.
- Nothing was worked around. No block occurred to report.
