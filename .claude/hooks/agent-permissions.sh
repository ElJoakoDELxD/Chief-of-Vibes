#!/usr/bin/env bash
# Spike S4: enforce the adopted agent's disallowedTools. The agent is whatever
# this session declared with `header --declare agent=<name>`.
set -uo pipefail
input="$(cat)"
read -r sid tool < <(printf '%s' "$input" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("session_id","-"), d.get("tool_name","-"))')
decl="${TMPDIR:-/tmp}/cov-header-${sid}"
printf '%s sid=%s tool=%s decl=%s exists=%s\n' "$(date -u +%T)" "$sid" "$tool" "$decl" "$([ -f "$decl" ] && echo yes || echo no)" >> /tmp/cov-s4-hook.log
agent="$(sed -n 's/^agent=//p' "$decl" 2>/dev/null | tail -1)"
[[ -n "$agent" ]] || exit 0
file="${CLAUDE_PROJECT_DIR:-.}/.claude/agents/${agent}.md"
banned="$(awk '/^---/{f++;next} f==1 && /^disallowedTools:/{sub(/^[^:]*:[[:space:]]*/,""); gsub(/[\[\]]/,""); print; exit}' "$file" 2>/dev/null)"
IFS=',' read -ra list <<< "$banned"
for t in "${list[@]}"; do
  t="$(echo "$t" | xargs)"
  if [[ "$t" == "$tool" ]]; then
    echo "BLOCKED: agent '${agent}' may not use ${tool} (.claude/agents/${agent}.md, disallowedTools)." >&2
    exit 2
  fi
done
exit 0
