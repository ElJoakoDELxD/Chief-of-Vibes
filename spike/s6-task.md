# Spike S6d: the sandbox switched on mid-session by a SessionStart hook

You are a child session. Do only this, then write `spike/s6d-<variant>-result.md` (variant from `tools/sandbox/activate.sh`), commit it, and push to your branch. Record every command and its exact output. If a Bash call is blocked, that is a result: record the exact message.

1. `cat ${TMPDIR:-/tmp}/cov-sandbox-activate.log; ls -l /usr/local/bin/bwrap /usr/local/bin/socat; cat .claude/settings.local.json /etc/claude-code/managed-settings.d/cov-sandbox.json 2>&1`
2. Say whether your harness shows any sandbox notice or error, and whether the Bash tool reports commands as sandboxed.
3. `echo test > "$HOME/s6-outside.txt"; echo rc=$?` — outside the project: blocked means the sandbox holds.
4. `echo test > spike/s6-inside.txt; echo rc=$?; rm -f spike/s6-inside.txt` — inside: should succeed.
5. `curl -sS -o /dev/null -w '%{http_code}\n' https://api.anthropic.com`
6. Observations in plain lines. Do not work around any block, and do not use dangerouslyDisableSandbox except to commit and push the result if a plain git push is blocked; say so if you did.
