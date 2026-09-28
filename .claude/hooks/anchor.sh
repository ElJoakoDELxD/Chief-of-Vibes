#!/usr/bin/env bash
#
# Claude Code hook: injects the measured time and current branch so replies
# are anchored to real values instead of model estimates. On a chat with no
# agent memory it also injects the start menu — which menu depends on whether
# this repository is the canon named in .canon or a copy of it.
#
# Custody lives with the post, so neither marker ships in the template
# (section 6). The canon's role branch carries .canon; a copy's carries
# .blueprint, naming the blueprint it came from. A copy of a copy still names
# the blueprint: every generation proposes to the same place, none proxies
# through its parent.
#
# At session start it also compares this copy's SYSTEM.md version against the
# canon's and reports drift: one network call, SessionStart only, reported
# unavailable rather than guessed when the canon cannot be reached.
#
# On a start whose source is `clear` it also hands the thread back: the
# runtime reports how the session began, so resumption is a signal rather
# than a thing the agent must notice and remember (SYSTEM.md §8, §9).
#
# Usage:  anchor.sh <SessionStart|UserPromptSubmit>
# Input:  the runtime's hook JSON on stdin, which carries `source` at SessionStart.
# Output: hook JSON with `additionalContext`, plus `initialUserMessage` after a clear.

set -uo pipefail

event="${1:?usage: anchor.sh <SessionStart|UserPromptSubmit>}"

# A cd that fails must not be followed by measurements: without this guard a
# session could read another repository's tree and print its agent, posts and
# drift as its own, every field well-formed and every one about somebody
# else. Silence would be worse than saying so (SYSTEM.md section 3).
if ! cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null; then
  HOOK_EVENT="${event}" \
  HOOK_CONTEXT="Anchors: UNAVAILABLE. The project directory (CLAUDE_PROJECT_DIR=${CLAUDE_PROJECT_DIR:-unset}) could not be entered, so nothing here was measured and no value was read from any tree. Say the anchors could not be taken. Do not build the time, the branch, the agent or the posts from memory or from another directory (SYSTEM.md section 3)." \
  python3 -c 'import json,os; print(json.dumps({"hookSpecificOutput":{"hookEventName":os.environ["HOOK_EVENT"],"additionalContext":os.environ["HOOK_CONTEXT"]}}))'
  exit 0
fi

# How this session began: startup, resume, clear, compact or fork, sent by
# the runtime as `source` on stdin. A runtime that sends nothing leaves this
# empty, which reads as "not a clear" and keeps every other path unchanged.
origin_kind=""
if [[ ! -t 0 ]]; then
  origin_kind="$(python3 -c 'import json,sys
try:
    print(json.load(sys.stdin).get("source", ""))
except Exception:
    print("")' 2>/dev/null)" || origin_kind=""
fi

# The hook measures no time and names no branch. The reply header is a sanity
# check the agent performs itself, with `clock | header` (tools/bin/, put on
# PATH by .claude/hooks/path.sh) — a hook that handed over the answer would
# let a session copy the header without doing the work it is there to prove.

# The agent's name, read rather than remembered, so a header naming the wrong
# vault is visible at a glance instead of silently consistent with itself.
# The vault ships as an empty form on main (SYSTEM.md section 5), so the file
# is present on every branch: **an agent is a filled form, not a present
# file** — testing existence would read every branch as an agent's.
field() {  # field <name> -> its value in memory/state.md, comments and space removed
  sed -n "s/^$1:[[:space:]]*//p" memory/state.md 2>/dev/null \
    | head -n1 | sed 's/[[:space:]]*#.*$//; s/[[:space:]]*$//'
}
has_agent() { [[ -f memory/state.md && -n "$(field agent)" ]]; }

agent="$(field agent)"
posts="$(field posts)"
identity=""
[[ -n "${agent}" ]] && identity=" Agent: ${agent}."
# A session with no agent still holds a post: `founder`, granted by the
# absence of an agent and by nothing else (SYSTEM.md section 5). Naming it
# here is what makes the header's fourth field readable before an agent exists.
if has_agent; then
  [[ -n "${posts}" ]] && identity="${identity} Posts held: ${posts}. Declare which one this session exercises with header --declare function=<name>; the header prints it as post/function (SYSTEM.md section 9)."
else
  identity="${identity} Posts held: [founder], granted by the absence of an agent and by nothing else. It authorizes one function, onboard, and becomes steward the moment memory/state.md names an agent — same session, same chat, different post (SYSTEM.md section 5)."
fi

# The model gate cannot read what the runtime served, so the obligation to
# fetch it is stated here where a session cannot miss it.
if [[ -n "${posts}" ]] && grep -q '^models:' memory/posts/*.md 2>/dev/null; then
  identity="${identity} Before exercising a post: ask the runtime which model served this session, then run \`bash tools/models.sh <that-model> <post>\`. No reading is a refusal, not a pass."
fi

# The reach record for time (SYSTEM.md §8). Silent on every platform already
# listed, which is every session after the first one on a machine.
clocks="$(bash tools/clocks.sh 2>/dev/null)" || clocks=""
[[ -n "${clocks}" ]] && clocks=" Clock reach: ${clocks}"

menu=""
if ! has_agent; then
  # Canon or copy? The canon is the repository named in .canon; every other
  # repository carrying these files is somebody's copy, and a copy is where
  # agents are created. The remote is matched on its trailing owner/repo, so
  # ssh, https and proxied remotes all answer alike. A missing .canon or
  # origin leaves the question unanswered — the menu says so instead of
  # guessing (§3 never fabricate a reading).
  origin_url="$(git remote get-url origin 2>/dev/null \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's#^[a-z+]+://##; s#^[^/@]*@##; s#^[^/:]*[:/]##; s#\.git$##; s#/+$##')" || true
  canon_slug="$(head -n1 .canon 2>/dev/null \
    | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | sed -E 's#\.git$##; s#^/+##; s#/+$##')" || true
  # .blueprint present means derived, whatever else is on disk: absence of
  # provenance is what makes a repository the root, so nothing has to assert it.
  blueprint_slug="$(head -n1 .blueprint 2>/dev/null \
    | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | sed -E 's#\.git$##; s#^/+##; s#/+$##')" || true

  # Agent branches: every remote head that is not main or a chat surface.
  candidates="$(git ls-remote --heads origin 2>/dev/null \
    | sed -E 's#.*refs/heads/##' \
    | grep -vE '^(main$|claude/|HEAD$)' \
    | paste -sd ',' - | sed 's/,/, /g')" || true

  if [[ -n "${blueprint_slug}" ]]; then
    menu=" No agent lives on this branch (memory/state.md is the empty form), and this repository is derived: .blueprint names ${blueprint_slug} as the blueprint it came from. **Begin onboarding now** (.claude/skills/onboard/), whatever this first message says: greet in the user's language and ask its first question. Nobody has to request an agent. Maintaining the template through a pull request is the other path, named only if they ask for it."
  elif [[ -z "${canon_slug}" || -z "${origin_url}" ]]; then
    menu=" No agent lives here (memory/state.md is the empty form), and whether this repository is the canon or the user's own copy could not be determined (no marker on this branch, or no origin remote): say so and ask which it is before creating an agent — never guess. Greet briefly in the user's language, assuming they may not know what this is."
  elif [[ "/${origin_url}" == *"/${canon_slug}" ]]; then
    menu=" This session runs on the canon (origin matches .canon): no agent is created here and no work lands here. Greet briefly in the user's language, assuming they may not know what this is, and offer the two legitimate reasons to be on the canon: create their own copy of the template (the session makes the repository for them when a tool allows it, .claude/skills/onboard/ step 0, with GitHub's 'Use this template' as the fallback), or contribute a template change through a pull request."
  else
    menu=" No agent lives here yet (memory/state.md is the empty form), and this repository is the user's own copy of the template (origin does not match .canon) — this is where their agent belongs. **Begin onboarding now** (.claude/skills/onboard/), whatever this first message says: greet in the user's language and ask its first question. Nobody has to request an agent, and a person who does not know what this is cannot choose from a menu. Maintaining the template through a pull request is the other path, named only if they ask for it."
  fi

  # Continuing an agent belongs to a copy, where the Principal is returning to
  # their own agent. On the canon the person standing here is a visitor and
  # the agent they can see is the demonstration, never handed over.
  if [[ -n "${candidates}" ]]; then
    if [[ -z "${blueprint_slug}" && -n "${canon_slug}" && "/${origin_url}" == *"/${canon_slug}" ]]; then
      menu="${menu} An agent already lives here and it is the demonstration, on: ${candidates}. Name it and let them read it. Never offer to continue it — a visitor is offered their own copy or a pull request."
    else
      menu="${menu} Existing agent branches to offer continuing first: ${candidates}."
    fi
  fi
  menu="${menu} Act on evident intent without re-asking."
fi

# Template drift, at session start only (§6): a copy running an older spec
# than the canon obeys superseded rules with the old rails still wired in,
# and the failure is invisible because everything looks normal. One network
# call, at SessionStart and never on a prompt; on any failure the check
# reports itself unavailable rather than claiming parity (§3 forbids
# fabricating a reading).
drift=""
if [[ "${event}" == "SessionStart" ]]; then
  canon_slug="$(head -n1 .blueprint 2>/dev/null | tr -d '[:space:]' | sed -E 's#\.git$##; s#^/+##; s#/+$##')" || true
  # .blueprint names where the template comes from; without one this is the
  # root, and .canon is read only to confirm that rather than to find a source.
  [[ -n "${canon_slug}" ]] || canon_slug="$(head -n1 .canon 2>/dev/null | tr -d '[:space:]' | sed -E 's#\.git$##; s#^/+##; s#/+$##')" || true
  origin_url="$(git remote get-url origin 2>/dev/null | tr '[:upper:]' '[:lower:]' \
    | sed -E 's#^[a-z+]+://##; s#^[^/@]*@##; s#^[^/:]*[:/]##; s#\.git$##; s#/+$##')" || true

  if [[ -z "${canon_slug}" || -z "${origin_url}" ]]; then
    drift=" Template drift check: UNAVAILABLE (no .blueprint or .canon on this branch, or no origin remote, so this copy cannot be compared against anything). Say the check did not run rather than assuming this copy is current."

  # The canon cannot drift from itself.
  elif [[ "/${origin_url}" != *"/$(printf '%s' "${canon_slug}" | tr '[:upper:]' '[:lower:]')" ]]; then
    version_of() { sed -n 's/^\*\*Version \([0-9][0-9.]*\)\.\*\*.*/\1/p' | head -n1; }
    here_version="$(version_of < SYSTEM.md 2>/dev/null)" || true

    canon_version=""
    # Read from the GitHub URL in every real session; the bench points it at
    # a local repository so the direction of the gap can be pinned with no
    # network call.
    canon_remote="${CHIEF_CANON_REMOTE:-https://github.com/${canon_slug}}"
    if timeout 20 git fetch --quiet "${canon_remote}" HEAD 2>/dev/null; then
      canon_version="$(git show FETCH_HEAD:SYSTEM.md 2>/dev/null | version_of)" || true
    fi

    if [[ -z "${canon_version}" ]]; then
      drift=" Template drift check: UNAVAILABLE (could not read the canon's SYSTEM.md; this copy is at ${here_version:-unknown}). Say the check did not run rather than assuming this copy is current."
    elif [[ "${canon_version}" != "${here_version}" ]]; then
      # The gap has a direction: behind runs superseded rules with the old
      # rails; ahead is the system working, since §6 says improvement is
      # born in the copy — nothing to sync, and syncing would move it
      # backwards.
      older="$(printf '%s
%s
' "${here_version:-0}" "${canon_version}" | sort -V | head -n1)"
      if [[ "${older}" == "${canon_version}" ]]; then
        drift=" Template lead: this copy is at ${here_version:-unknown} and the canon is at ${canon_version}, so this copy is AHEAD. Nothing to sync, and syncing would move it backwards. What is missing is the other direction: these changes reach other copies only through a pull request to the canon (§6, §9). Tell the Principal which releases are waiting."
      else
        drift=" Template drift: this copy is at ${here_version:-unknown} and the canon is at ${canon_version}, so this copy is BEHIND. Rules and hooks here are the older ones, so a rule written upstream is not in force in this session. Before substantive work, tell the Principal and offer to sync (SYSTEM.md §6): a pull request bringing the canon's template into this copy's main, then tools/sync.sh onto the agent branch."
      fi
    fi
  fi
fi

# Findings kept instead of sent upstream, at session start only (§1, §9). The
# canon has no agent and no backlog, so this is silent there by construction.
# It reports and never blocks: deciding that a finding generalizes is a
# judgment, and a rail on a judgment lies (§8).
candidates=""
if [[ "${event}" == "SessionStart" ]] && has_agent; then
  waiting="$(bash tools/candidates.sh 2 2>/dev/null)" || waiting=""
  if [[ -n "${waiting}" ]]; then
    candidates=" Findings tagged for upstream and still waiting:
${waiting}
Each one reaches other copies only through a pull request to the canon (§9). Route them or say why they stay."
  fi
fi

# Memory hygiene, in the same hole and for the same reason: reports, never
# blocks.
hygiene=""
if [[ "${event}" == "SessionStart" ]] && has_agent; then
  untidy="$(bash tools/hygiene.sh 2>/dev/null)" || untidy=""
  if [[ -n "${untidy}" ]]; then
    hygiene=" Memory hygiene:
${untidy}
Tell the Principal what this says, with its numbers, in this session's first reply. A sensor whose report stops at the agent is rung 4 wearing rung 3's clothes."
  fi
fi

# Resumption after a cleared window (§9 succession): a clear empties the
# conversation and leaves no turn behind, so the runtime's `source` turns the
# hand-back into a turn the agent cannot miss, via `initialUserMessage`.
#
# `clear` only. On `compact` the runtime's summary already carries the
# thread; on `startup` and `resume` nothing was destroyed. The message names
# the notes by path, because a reader never looks for what it must read (§3).
resume=""
if [[ "${event}" == "SessionStart" && "${origin_kind}" == "clear" ]] && has_agent; then
  notes=""
  for note in memory/handoff/*.md; do
    [[ -e "${note}" ]] || continue
    notes="${notes}${notes:+, }${note}"
  done

  resume="This window was just cleared. The conversation above is gone, and none of it is a source of truth: not what was decided, not what was tried, not what the Principal said."
  if [[ -n "${notes}" ]]; then
    resume="${resume} The thread lives on disk. Read ${notes}, then memory/state.md and memory/backlog.md, and continue from the note's next step. Do not ask what we were working on."
  else
    resume="${resume} memory/handoff/ holds no note, so no thread was left in flight. Read memory/state.md and memory/backlog.md and surface the highest-priority pending work."
  fi
fi

HOOK_EVENT="${event}" \
HOOK_CONTEXT="Session context.${identity} Never work on main.${menu}${drift}${candidates}${hygiene}${clocks}" \
HOOK_RESUME="${resume}" \
python3 - <<'PY'
import json
import os

out = {
    "hookEventName": os.environ["HOOK_EVENT"],
    "additionalContext": os.environ["HOOK_CONTEXT"],
}
if os.environ.get("HOOK_RESUME"):
    out["initialUserMessage"] = os.environ["HOOK_RESUME"]
print(json.dumps({"hookSpecificOutput": out}))
PY
