#!/usr/bin/env bash
#
# Bench for the resumption half of .claude/hooks/anchor.sh. It pins what must
# hand the thread back and what must be left alone. An injected turn that
# fires on the wrong start talks over work in flight, which is worse than
# never firing at all (SYSTEM.md section 8).
#
# The fixture carries no .canon, so the drift check does not run and the bench
# makes no network call.
#
# Usage:  bash tools/test-anchor.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

mkdir -p "${tmp}/tools" "${tmp}/memory/handoff"
cp "${here}/now.sh" "${tmp}/tools/now.sh"
printf -- '---\ntimezone: UTC\n---\n' > "${tmp}/memory/state.md"
printf '# a thread\n' > "${tmp}/memory/handoff/landing page rewrite-handoff.md"

fails=0
check() {  # check <want|want-not> <pattern> <label>
  local mode="$1" pat="$2" label="$3"
  if [[ "${mode}" == want && "${out}" == *"${pat}"* ]] \
  || [[ "${mode}" == want-not && "${out}" != *"${pat}"* ]]; then
    printf 'ok    %s\n' "${label}"
  else
    printf 'FAIL  %s\n' "${label}"; fails=$((fails + 1))
  fi
}

run() {  # run <event> <source-json>
  CLAUDE_PROJECT_DIR="${tmp}" bash "${here}/../.claude/hooks/anchor.sh" "$1" <<< "$2"
}

out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"clear"}')"
check want     "initialUserMessage"                 "a cleared start hands the thread back"
check want     "landing page rewrite-handoff.md"    "the hand-back names the note by path"
check want     "memory/backlog.md"                  "the hand-back names the memory to read"
check want     "was just cleared"                   "the hand-back says the window was cleared"

out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"startup"}')"
check want-not "initialUserMessage"                 "an ordinary start is left alone"
check want     "additionalContext"                  "an ordinary start still gets its anchors"

out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"compact"}')"
check want-not "initialUserMessage"                 "a compacted start is left alone"

out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"resume"}')"
check want-not "initialUserMessage"                 "a resumed start is left alone"

out="$(run UserPromptSubmit '{"hook_event_name":"UserPromptSubmit","source":"clear"}')"
check want-not "initialUserMessage"                 "a prompt never hands the thread back"

out="$(run SessionStart 'not json at all')"
check want-not "initialUserMessage"                 "an unreadable payload is not read as a clear"
check want     "additionalContext"                  "an unreadable payload still gets its anchors"

out="$(run SessionStart '{"hook_event_name":"SessionStart"}')"
check want-not "initialUserMessage"                 "a runtime that sends no source is not read as a clear"

rm -f "${tmp}/memory/handoff/"*.md
out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"clear"}')"
check want     "initialUserMessage"                 "a cleared start with no note still hands back"
check want     "no note"                            "the hand-back says no thread was in flight"

rm -f "${tmp}/memory/state.md"
out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"clear"}')"
check want-not "initialUserMessage"                 "a chat with no agent is left alone"

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
