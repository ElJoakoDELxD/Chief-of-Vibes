# Spike S6g — local sandbox result

Run on 2026-09-28, HEAD detached at `eb73c79` (from `spike/s6-sandbox`). No permission prompt appeared for any command, so every one ran sandboxed. `dangerouslyDisableSandbox` was never used.

## 1. Write outside the workspace

```
$ echo test > "$HOME/s6-outside.txt"; echo rc=$?
/bin/bash: line 2: /root/s6-outside.txt: Read-only file system
rc=1
```

Blocked.

## 2. Write inside the workspace

```
$ echo test > spike/s6-inside.txt; echo rc=$?; rm -f spike/s6-inside.txt
rc=0
```

Allowed.

## 3. Write to a protected settings file

```
$ echo x >> .claude/settings.json; echo rc=$?; git checkout -- .claude/settings.json 2>/dev/null
/bin/bash: line 2: .claude/settings.json: Read-only file system
rc=1
```

Blocked (denyWithinAllow).

## 4. Local settings and sandbox binaries

```
$ cat .claude/settings.local.json; ls -l /usr/local/bin/bwrap /usr/local/bin/socat
{"sandbox":{"enabled":true,"enableWeakerNestedSandbox":true,"autoAllowBashIfSandboxed":true,"network":{"allowedDomains":["api.anthropic.com","github.com","*.github.com","raw.githubusercontent.com"]}}}
lrwxrwxrwx 1 root root 58 Sep 28 13:42 /usr/local/bin/bwrap -> /home/user/Chief-of-Vibes/tools/sandbox/linux-x86_64/bwrap
lrwxrwxrwx 1 root root 58 Sep 28 13:42 /usr/local/bin/socat -> /home/user/Chief-of-Vibes/tools/sandbox/linux-x86_64/socat
```

## 5. Network to an allowed domain

```
$ curl -sS -o /dev/null -w '%{http_code}\n' https://api.anthropic.com
curl: (7) Failed to connect to localhost port 3128 after 0 ms: Couldn't connect to server
000
```

Exit code 7. No `<sandbox_violations>` block. curl was pointed at a proxy on `localhost:3128` that did not answer inside the sandbox, so `api.anthropic.com` was unreachable even though it is in `allowedDomains`.

## 6. Git commit and push from the sandbox

Both failed, so this file was published with the GitHub MCP tool `push_files` instead.

```
$ git checkout spike/s6-sandbox
error: unable to unlink old '.claude/settings.json': Device or resource busy
Switched to branch 'spike/s6-sandbox'

$ git commit ...
Error: failed to call MCP server: MCP server request failed after 2 retries: failed to send request: Post "http://127.0.0.1:35517/mcp": dial tcp 127.0.0.1:35517: connect: connection refused
fatal: failed to write commit object
rc=128

$ git push -u origin spike/s6-sandbox
fatal: unable to access 'https://github.com/ElJoakoDELxD/Chief-of-Vibes/': Failed to connect to localhost port 3128 after 0 ms: Couldn't connect to server
rc=128
```

Commit signing calls a local MCP server on `127.0.0.1:35517`; the sandbox's network namespace cannot reach it. Push fails on the same dead proxy as step 5.

## Reading

- Filesystem confinement works: writes outside the workspace and to `.claude/settings.json` fail with `Read-only file system`; writes inside succeed.
- Commands auto-ran without prompts (`autoAllowBashIfSandboxed`).
- Network is broken inside the sandbox: the proxy on `localhost:3128` and the signing server on `127.0.0.1:35517` are both unreachable. The allowlist could not be exercised, and git cannot commit or push from a sandboxed command.
