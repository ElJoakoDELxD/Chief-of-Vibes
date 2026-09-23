#!/usr/bin/env bash
#
# Claude Code hook (PreToolUse): the adopted agent's declared effects are its
# permissions. Once a session declares an agent (`header --declare agent=<name>`),
# Write, Edit and NotebookEdit may only touch paths the agent file lists under
# `effects:` as `writes:`. Everything else is closed. The agent file itself is
# never writable by the agent it governs, whatever its effects say.
#
# Scope, stated plainly: this reads tool calls. A file written through Bash does
# not pass through here; that needs the Claude Code sandbox (spec §5.0, S4).

set -uo pipefail
input="$(cat)"
eval "$(printf '%s' "$input" | python3 -c '
import json, shlex, sys
d = json.load(sys.stdin)
ti = d.get("tool_input") or {}
path = ti.get("file_path") or ti.get("notebook_path") or ""
print("sid=%s tool=%s path=%s" % (shlex.quote(d.get("session_id", "-")), shlex.quote(d.get("tool_name", "-")), shlex.quote(path)))
')"
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
decl="${TMPDIR:-/tmp}/cov-header-${sid}"
printf '%s sid=%s tool=%s path=%s\n' "$(date -u +%T)" "$sid" "$tool" "$path" >> /tmp/cov-s5-hook.log

agent="$(sed -n 's/^agent=//p' "$decl" 2>/dev/null | head -1)"
[[ -n "$agent" ]] || exit 0
case "$tool" in Write|Edit|MultiEdit|NotebookEdit) ;; *) exit 0 ;; esac

file="${root}/.claude/agents/${agent}.md"
abs="$(python3 -c 'import os,sys; print(os.path.realpath(os.path.join(sys.argv[1], sys.argv[2])))' "$root" "$path")"

if [[ "$abs" == "$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$file")" ]]; then
  echo "BLOCKED: agent '${agent}' may not change its own definition (${file#${root}/}). Its effects are set by the Principal." >&2
  exit 2
fi

while IFS= read -r allowed; do
  [[ -n "$allowed" ]] || continue
  base="$(python3 -c 'import os,sys; print(os.path.realpath(os.path.join(sys.argv[1], sys.argv[2])))' "$root" "$allowed")"
  [[ "$abs" == "$base" || "$abs" == "$base"/* ]] && exit 0
done < <(awk '/^---/{f++;next} f==1 && /^[[:space:]]*-[[:space:]]*writes:/{sub(/^[^:]*:[[:space:]]*/,""); print}' "$file")

echo "BLOCKED: agent '${agent}' declares no effect that writes ${abs#${root}/} (.claude/agents/${agent}.md, effects)." >&2
exit 2
