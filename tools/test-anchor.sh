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

# §1 promises that silence from the drift check means parity. A fixture with
# no .canon cannot be compared against anything, so silence there would be the
# table lying. It says the check did not run instead.
out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"startup"}')"
check want "drift check: UNAVAILABLE"               "no .canon says the check did not run, never nothing"
check want "no .canon file, or no origin remote"    "the unavailable line names why it could not run"

rm -f "${tmp}/memory/handoff/"*.md
out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"clear"}')"
check want     "initialUserMessage"                 "a cleared start with no note still hands back"
check want     "no note"                            "the hand-back says no thread was in flight"

rm -f "${tmp}/memory/state.md"
out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"clear"}')"
check want-not "initialUserMessage"                 "a chat with no agent is left alone"

# --- the direction of a version gap -------------------------------------------
# Behind and ahead are opposite situations, and the hook reported both as "the
# rules here are the older ones". That told a copy carrying newer rules to sync
# older ones over them: a fabricated reading with a version number on it.
#
# CHIEF_CANON_REMOTE points the fetch at a local repository, so both directions
# are pinned without a network call (CONTRIBUTING: rails are testable).
canon_dir="${tmp}/canon"
mkdir -p "${canon_dir}"
( cd "${canon_dir}" && git init -q .   && git config user.email bench@example.com && git config user.name bench   && printf '**Version 1.47.0.** spec
' > SYSTEM.md   && git add -A && git commit -q -m spec ) >/dev/null 2>&1

copy_dir="${tmp}/copy"
copy_at() {
  rm -rf "${copy_dir}"; mkdir -p "${copy_dir}/tools" "${copy_dir}/memory"
  cp "${here}/now.sh" "${copy_dir}/tools/now.sh"
  cp "${here}/clocks.sh" "${copy_dir}/tools/clocks.sh"
  ( cd "${copy_dir}" && git init -q .     && git remote add origin https://github.com/someone/their-copy ) >/dev/null 2>&1
  printf 'Owner/Canon
' > "${copy_dir}/.canon"
  printf '**Version %s.** spec
' "$1" > "${copy_dir}/SYSTEM.md"
  printf -- '---
timezone: UTC
---
' > "${copy_dir}/memory/state.md"
}
drift_run() {
  CLAUDE_PROJECT_DIR="${copy_dir}" CHIEF_CANON_REMOTE="${canon_dir}"     bash "${here}/../.claude/hooks/anchor.sh" SessionStart     <<< '{"hook_event_name":"SessionStart","source":"startup"}'
}

copy_at 1.49.0
out="$(drift_run 2>/dev/null)"
check want     "this copy is AHEAD"   "a copy ahead of the canon is told it is ahead"
check want     "Nothing to sync"      "and is not told to sync backwards"
check want-not "offer to sync"        "the sync is not offered to a copy that leads"

copy_at 1.40.0
out="$(drift_run 2>/dev/null)"
check want     "this copy is BEHIND"  "a copy behind the canon is told it is behind"
check want     "offer to sync"        "and the sync is offered"

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
