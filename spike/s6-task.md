# Spike S6b: same test, with sandbox.failIfUnavailable = true

You are a child session. Do only this, then write `spike/s6b-result.md`, commit it, and push to `spike/s6-sandbox`. Record every command and its exact output.

1. `which bwrap socat; echo "$PATH"` and `bwrap --version; socat -V | head -1`.
2. Say whether your harness reports the sandbox as active for Bash (describe what you see: any sandbox notice, the tool description, or errors).
3. Bash: `echo test > "$HOME/s6-outside.txt"; echo rc=$?` (outside the project: should be blocked if the sandbox holds).
4. Bash: `echo test > spike/s6-inside.txt; echo rc=$?` (inside the project: should succeed). Delete it afterwards.
5. Bash: `curl -sS -o /dev/null -w '%{http_code}\n' https://api.anthropic.com` (network under the sandbox).
6. Observations, in plain lines. Do not work around any block; report it.
7. If Bash fails at every call, copy the exact error text: that is the result.
