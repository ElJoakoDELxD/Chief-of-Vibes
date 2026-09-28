# S6i — sandbox probe result (cloud session, Bash sandbox on)

Date: 2026-09-28. Environment: Claude Code remote container, bubblewrap sandbox per command, egress via agent proxy.

## 1. Write outside the workspace

Command: `echo test > "$HOME/s6-outside.txt"; echo rc=$?`

```
/bin/bash: line 2: /root/s6-outside.txt: Read-only file system
rc=1
```

## 2. Write inside the workspace

Command: `echo test > spike/s6-inside.txt; echo rc=$?; rm -f spike/s6-inside.txt`

```
rc=0
```

## 3. Allowlisted host

Command: `curl -sS -o /dev/null -w '%{http_code}\n' https://api.anthropic.com`

```
404
```

(Connection succeeded; 404 is the API root's answer.)

## 4. Non-allowlisted host

Command: `curl -sS -o /dev/null -w '%{http_code}\n' https://example.com`

```
Exit code 56
curl: (56) CONNECT tunnel failed, response 403
000

[agent-proxy] While this command ran, 1 connection through the agent proxy failed:
- example.com:443 — connect_rejected (the egress proxy denied the CONNECT (organization policy) or could not reach the destination)
```

## 6. `git checkout -B spike/s6-sandbox`

```
Switched to and reset branch 'spike/s6-sandbox'
Your branch is up to date with 'origin/spike/s6-sandbox'.
```

## 7. `git add spike/s6i-local-result.md`

```
(no output)
```

## 8. `git commit -m "S6i result"`

```
[spike/s6-sandbox 2fb031e] S6i result
 1 file changed, 43 insertions(+)
 create mode 100644 spike/s6i-local-result.md
```

## 9. `git push origin spike/s6-sandbox`

```
To https://github.com/ElJoakoDELxD/Chief-of-Vibes
   a963498..2fb031e  spike/s6-sandbox -> spike/s6-sandbox
```
