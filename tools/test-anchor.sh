#!/usr/bin/env bash
#
# Bench for the resumption half of .claude/hooks/anchor.sh. It pins what must
# hand the thread back and what must be left alone. An injected turn that
# fires on the wrong start talks over work in flight, which is worse than
# never firing at all (SYSTEM.md section 8).
#
# The fixture carries neither marker, so the drift check does not run and the bench
# makes no network call.
#
# Usage:  bash tools/test-anchor.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

mkdir -p "${tmp}/tools" "${tmp}/memory/handoff"
cp "${here}/now.sh" "${tmp}/tools/now.sh"
printf -- '---\nagent: Bench Agent\ntimezone: UTC\nposts: [steward]\n---\n' > "${tmp}/memory/state.md"
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
# no marker cannot be compared against anything, so silence there would be the
# table lying. It says the check did not run instead.
out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"startup"}')"
check want "drift check: UNAVAILABLE"               "no marker says the check did not run, never nothing"
check want "no .blueprint or .canon on this branch" "the unavailable line names why it could not run"

rm -f "${tmp}/memory/handoff/"*.md
out="$(run SessionStart '{"hook_event_name":"SessionStart","source":"clear"}')"
check want     "initialUserMessage"                 "a cleared start with no note still hands back"
check want     "no note"                            "the hand-back says no thread was in flight"

# --- the agent and its posts reach the header --------------------------------
# The header names the agent beside the branch. Section 9 dropped that field once
# on the reasoning that the branch carried it, and 07-09-2026 falsified it: a
# session worked a day from a superseded vault while every file read correctly.
out="$(run UserPromptSubmit '{}')"
check want "Agent: Bench Agent"      "the agent is read from the vault, never remembered"
check want "Posts held: [steward]"   "and the posts it holds ride with it"
check want "post/function"           "with the instruction to declare which one is exercised"

# --- a defaulted clock is still a clock ---------------------------------------
# tools/now.sh exits 2 when it had to fall back to UTC, and prints the time anyway.
# The hook has to keep that reading rather than throw it away with the exit code:
# a header saying the clock is unavailable, on a machine whose clock answered, is
# the fabricated reading section 3 forbids, pointed the other way.
printf -- '---\nagent: Bench Agent\nposts: [steward]\n---\n' > "${tmp}/memory/state.md"
out="$(run UserPromptSubmit '{}')"
check want-not "CLOCK UNAVAILABLE"  "a defaulted reading is not reported as no reading"
if printf '%s' "${out}" | grep -qE 'time=[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2}'; then
  printf 'ok    %s\n' "the anchor carries the defaulted time"
else
  printf 'FAIL  %s\n' "the anchor carries the defaulted time"; fails=$((fails + 1))
fi
printf -- '---\nagent: Bench Agent\ntimezone: UTC\nposts: [steward]\n---\n' > "${tmp}/memory/state.md"

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
' > "${copy_dir}/.blueprint"
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

# --- the menu, where no agent lives on this branch ----------------------------
# The canon has an agent and it is the demonstration. A visitor meeting it is the
# point; being offered it for continuation is not, and "act on evident intent"
# used to carry a stranger straight into somebody else's vault.
menu_dir="${tmp}/menu"
menu_at() {  # menu_at <marker-file> <slug> <origin-url>
  rm -rf "${menu_dir}"; mkdir -p "${menu_dir}/tools"
  cp "${here}/now.sh" "${menu_dir}/tools/now.sh"
  cp "${here}/clocks.sh" "${menu_dir}/tools/clocks.sh"
  ( cd "${menu_dir}" && git init -q . && git remote add origin "$3" ) >/dev/null 2>&1
  [[ -n "$1" ]] && printf '%s\n' "$2" > "${menu_dir}/$1"
  printf -- '---\ntimezone: UTC\n---\n' > "${menu_dir}/state-not-here.md"
}

menu_at .canon "Owner/Canon" "https://github.com/Owner/Canon"
out="$( CLAUDE_PROJECT_DIR="${menu_dir}" bash "${here}/../.claude/hooks/anchor.sh" UserPromptSubmit </dev/null )"
check want     "runs on the canon"          "the canon is recognised from its own marker"
check want-not "offer continuing first"     "and a visitor is never offered the agent standing there"

menu_at .blueprint "Owner/Canon" "https://github.com/Someone/Their-Copy"
out="$( CLAUDE_PROJECT_DIR="${menu_dir}" bash "${here}/../.claude/hooks/anchor.sh" UserPromptSubmit </dev/null )"
check want "this repository is derived"     "a .blueprint says the repository is derived"
check want "owner/canon"                    "and names the blueprint it came from"

menu_at "" "" "https://github.com/Someone/Their-Copy"
out="$( CLAUDE_PROJECT_DIR="${menu_dir}" bash "${here}/../.claude/hooks/anchor.sh" UserPromptSubmit </dev/null )"
check want "could not be determined"        "neither marker leaves the question open, never guessed"

# --- a directory it could not enter -------------------------------------------
# The hook stayed where it was and measured that tree instead, so a session could
# open with another repository's agent, posts, drift and hygiene — every field
# well-formed and every one about somebody else. Measured 09-09-2026.
elsewhere="${tmp}/elsewhere"; mkdir -p "${elsewhere}/memory"
printf -- '---\nagent: Somebody Else\nposts: [steward]\n---\n' > "${elsewhere}/memory/state.md"
out="$( cd "${elsewhere}" && CLAUDE_PROJECT_DIR="${tmp}/no-such-directory" \
        bash "${here}/../.claude/hooks/anchor.sh" UserPromptSubmit </dev/null 2>&1 )"
check want-not "Somebody Else"       "a directory it cannot enter is never read from where it stands"
check want     "Anchors: UNAVAILABLE" "it says the anchors could not be taken"
check want     "not build the time"   "and forbids building them from memory instead"

# --- the post an unposted session already held -------------------------------
# Something builds the agent, and until 1.88.0 it did so holding nothing while
# creating a repository, a branch and a vault. A session with no agent is not a
# session with no post: it holds `founder`, granted by the absence.
menu_at .blueprint "Owner/Canon" "https://github.com/Someone/Their-Copy"
out="$( CLAUDE_PROJECT_DIR="${menu_dir}" bash "${here}/../.claude/hooks/anchor.sh" UserPromptSubmit </dev/null )"
check want     "Posts held: [founder]"      "a session with no agent is told which post it holds"
check want     "becomes steward"            "and that the post changes rather than hands over"
check want-not "Posts held: []"             "the empty list that claimed no authority is gone"

# And the filled form still reports the agent's own posts, unchanged. The fixture
# lost its vault to an earlier case, so it is restored rather than assumed.
printf -- '---\nagent: Bench Agent\ntimezone: UTC\nposts: [steward]\n---\n' > "${tmp}/memory/state.md"
out="$(run UserPromptSubmit '{}')"
check want     "Posts held: [steward]"      "an agent's own posts are still what it is told"
check want-not "founder"                    "and an agent is never told it holds the founding post"

# --- what a newcomer meets, on their first message ----------------------------
# The menu is the first thing a person who does not know what this is reads, and
# nothing pinned its content until 1.86.0. A copy begins onboarding rather than
# offering it: somebody who cannot yet tell the two paths apart cannot pick one,
# and a reply asking them to is one requiring knowledge never given (§3).
menu_at .blueprint "Owner/Canon" "https://github.com/Someone/Their-Copy"
out="$( CLAUDE_PROJECT_DIR="${menu_dir}" bash "${here}/../.claude/hooks/anchor.sh" UserPromptSubmit </dev/null )"
check want     "Begin onboarding now"       "a copy is told to begin, not to offer"
check want     "whatever this first message says" "and that the message's content does not gate it"
check want-not "offer: create their agent"  "the menu that waited to be chosen is gone"

# The two exceptions stay exceptions, and this is the half that keeps the change
# honest: a canon that began onboarding would create an agent where none may live.
menu_at .canon "Owner/Canon" "https://github.com/Owner/Canon"
out="$( CLAUDE_PROJECT_DIR="${menu_dir}" bash "${here}/../.claude/hooks/anchor.sh" UserPromptSubmit </dev/null )"
check want-not "Begin onboarding now"       "the canon never begins onboarding"
check want     "no agent is created here"   "and says so"

menu_at "" "" "https://github.com/Someone/Their-Copy"
out="$( CLAUDE_PROJECT_DIR="${menu_dir}" bash "${here}/../.claude/hooks/anchor.sh" UserPromptSubmit </dev/null )"
check want-not "Begin onboarding now"       "an undetermined repository never begins onboarding"
check want     "ask which it is"            "and asks which repository this is first"

# A fork: two lineages with no shared root. The numbers still order, and that is
# exactly the trap — 1.49.0 sorts above 1.47.0 and means nothing across histories.
# Measured 10-09-2026 on a live copy: AHEAD with nothing to sync, while twelve
# template files this canon carried were absent there. Both sides need real
# commits, because merge-base cannot answer about a tree that has none.
fork_dir="${tmp}/fork"
rm -rf "${fork_dir}"; mkdir -p "${fork_dir}/tools" "${fork_dir}/memory"
cp "${here}/now.sh" "${fork_dir}/tools/now.sh"
cp "${here}/clocks.sh" "${fork_dir}/tools/clocks.sh"
printf 'Owner/Canon\n' > "${fork_dir}/.canon"
printf '**Version 1.49.0.** spec\n' > "${fork_dir}/SYSTEM.md"
printf -- '---\ntimezone: UTC\n---\n' > "${fork_dir}/memory/state.md"
( cd "${fork_dir}" && git init -q . \
  && git config user.email bench@example.com && git config user.name bench \
  && git remote add origin https://github.com/someone/their-copy \
  && git add -A && git commit -q -m "unrelated root" ) >/dev/null 2>&1

out="$(CLAUDE_PROJECT_DIR="${fork_dir}" CHIEF_CANON_REMOTE="${canon_dir}" \
  bash "${here}/../.claude/hooks/anchor.sh" SessionStart \
  <<< '{"hook_event_name":"SessionStart","source":"startup"}' 2>/dev/null)"
check want     "Template FORK"        "unrelated histories are reported as a fork"
check want     "neither ahead nor behind" "and no direction is claimed"
check want-not "this copy is AHEAD"   "a fork is never reported as a lead"
check want-not "offer to sync"        "and the sync is not offered across a fork"

# The environment the rail actually runs in. Cloud sessions clone shallow, so the
# first version of this check skipped itself there and fell through to comparing
# numbers — it reported a confident AHEAD over a fork for a full day before anybody
# measured it. A guard that never fires is worse than none: the next reader trusts
# that the question is covered.
shallow_dir="${tmp}/shallow"
rm -rf "${shallow_dir}"; mkdir -p "${shallow_dir}"
git clone -q --depth 1 "file://${fork_dir}" "${shallow_dir}/copy" >/dev/null 2>&1
if [[ "$(git -C "${shallow_dir}/copy" rev-parse --is-shallow-repository 2>/dev/null)" == "true" ]]; then
  cp "${here}/now.sh" "${here}/clocks.sh" "${shallow_dir}/copy/tools/" 2>/dev/null
  ( cd "${shallow_dir}/copy" && git remote set-url origin https://github.com/someone/their-copy ) >/dev/null 2>&1
  out="$(CLAUDE_PROJECT_DIR="${shallow_dir}/copy" CHIEF_CANON_REMOTE="${canon_dir}" \
    bash "${here}/../.claude/hooks/anchor.sh" SessionStart \
    <<< '{"hook_event_name":"SessionStart","source":"startup"}' 2>/dev/null)"
  check want     "DIRECTION UNVERIFIABLE"  "a shallow clone is told the direction cannot be read"
  check want     "fetch --unshallow"       "and is given the command that settles it"
  check want-not "this copy is AHEAD"      "and is never handed a direction it cannot support"
else
  printf 'skip  shallow clone could not be built here\n'
fi

if (( fails )); then
  printf '\n%d failed\n' "${fails}"; exit 1
fi
printf '\nall green\n'
