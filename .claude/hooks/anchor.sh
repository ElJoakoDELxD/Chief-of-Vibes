#!/usr/bin/env bash
#
# Claude Code hook: injects the measured time and current branch so replies
# are anchored to real values instead of model estimates. On a chat with no
# agent memory it also injects the start menu — which menu depends on whether
# this repository is the canon named in .canon or a copy of it.
#
# At session start it additionally compares this copy's SYSTEM.md version
# against the canon's and reports drift. One network call, SessionStart only,
# and it reports itself unavailable rather than guessing when the canon cannot
# be reached.
#
# On a start whose source is `clear` it also hands the thread back: the runtime
# reports how the session began, so the resumption is a signal rather than a
# thing the agent must notice and remember (SYSTEM.md §8, §9).
#
# Usage:  anchor.sh <SessionStart|UserPromptSubmit>
# Input:  the runtime's hook JSON on stdin, which carries `source` at SessionStart.
# Output: hook JSON with `additionalContext`, plus `initialUserMessage` after a clear.

set -uo pipefail

event="${1:?usage: anchor.sh <SessionStart|UserPromptSubmit>}"

cd "${CLAUDE_PROJECT_DIR:-.}"

# How this session began. The runtime sends it as `source` on stdin, and the
# values are startup, resume, clear, compact and fork. A runtime that sends
# nothing leaves this empty, which reads as "not a clear" and keeps every
# other path unchanged.
origin_kind=""
if [[ ! -t 0 ]]; then
  origin_kind="$(python3 -c 'import json,sys
try:
    print(json.load(sys.stdin).get("source", ""))
except Exception:
    print("")' 2>/dev/null)" || origin_kind=""
fi

timestamp="$(bash tools/now.sh 2>/dev/null)" \
  || timestamp="CLOCK UNAVAILABLE (tools/now.sh failed) — say so; do not estimate"
branch="$(git branch --show-current 2>/dev/null || echo unknown)"

menu=""
if [[ ! -f memory/state.md ]]; then
  # Canon or copy? The canon is the repository named in .canon; every other
  # repository carrying these files is somebody's copy of it, and a copy is
  # where agents are created. The remote is matched on its trailing
  # owner/repo, so ssh, https, and proxied remotes all answer alike. A
  # missing .canon or origin leaves the question unanswered — the menu says
  # so instead of guessing (§3 never fabricate a reading).
  origin_url="$(git remote get-url origin 2>/dev/null \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's#^[a-z+]+://##; s#^[^/@]*@##; s#^[^/:]*[:/]##; s#\.git$##; s#/+$##')" || true
  canon_slug="$(head -n1 .canon 2>/dev/null \
    | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | sed -E 's#\.git$##; s#^/+##; s#/+$##')" || true

  # Agent branches: every remote head that is not main or a chat surface.
  candidates="$(git ls-remote --heads origin 2>/dev/null \
    | sed -E 's#.*refs/heads/##' \
    | grep -vE '^(main$|claude/|HEAD$)' \
    | paste -sd ',' - | sed 's/,/, /g')" || true

  if [[ -z "${canon_slug}" || -z "${origin_url}" ]]; then
    menu=" No agent lives here (no memory/state.md), and whether this repository is the canon or the user's own copy could not be determined (no .canon file, or no origin remote): say so and ask which it is before creating an agent — never guess. Greet briefly in the user's language, assuming they may not know what this is."
  elif [[ "/${origin_url}" == *"/${canon_slug}" ]]; then
    menu=" This session runs on the canon (origin matches .canon): no agent is created here and no work lands here. Greet briefly in the user's language, assuming they may not know what this is, and offer the two legitimate reasons to be on the canon: create their own copy of the template (the session makes the repository for them when a tool allows it, .claude/skills/onboard/ step 0, with GitHub's 'Use this template' as the fallback), or contribute a template change through a pull request."
  else
    menu=" No agent lives here yet (no memory/state.md), and this repository is the user's own copy of the template (origin does not match .canon) — this is where their agent belongs. Greet briefly in the user's language, assuming they may not know what this is, and offer: create their agent (.claude/skills/onboard/), or maintain the template through a pull request into this copy's main."
  fi

  if [[ -n "${candidates}" ]]; then
    menu="${menu} Existing agent branches to offer continuing first: ${candidates}."
  fi
  menu="${menu} Act on evident intent without re-asking."
fi

# Template drift, at session start only (§6). A copy running an older spec than
# the canon is an agent obeying rules that have already been superseded, and
# the rails it is running are the old ones too — the failure is invisible
# precisely because everything looks normal.
#
# One network call, at SessionStart and never on a prompt. On any failure the
# check reports itself unavailable rather than claiming parity: §3 forbids
# fabricating a reading, and a silent "probably fine" is exactly that.
drift=""
if [[ "${event}" == "SessionStart" ]]; then
  canon_slug="$(head -n1 .canon 2>/dev/null | tr -d '[:space:]' | sed -E 's#\.git$##; s#^/+##; s#/+$##')" || true
  origin_url="$(git remote get-url origin 2>/dev/null | tr '[:upper:]' '[:lower:]' \
    | sed -E 's#^[a-z+]+://##; s#^[^/@]*@##; s#^[^/:]*[:/]##; s#\.git$##; s#/+$##')" || true

  # Two silences used to look alike here, and §1 promises only one of them:
  # silence means parity. With no .canon, or no origin, the comparison cannot
  # run at all, and saying nothing would read as "current" (§3 never fabricate
  # a reading). Say the check did not run instead.
  if [[ -z "${canon_slug}" || -z "${origin_url}" ]]; then
    drift=" Template drift check: UNAVAILABLE (no .canon file, or no origin remote, so this copy cannot be compared against anything). Say the check did not run rather than assuming this copy is current."

  # The canon cannot drift from itself.
  elif [[ "/${origin_url}" != *"/$(printf '%s' "${canon_slug}" | tr '[:upper:]' '[:lower:]')" ]]; then
    version_of() { sed -n 's/^\*\*Version \([0-9][0-9.]*\)\.\*\*.*/\1/p' | head -n1; }
    here_version="$(version_of < SYSTEM.md 2>/dev/null)" || true

    canon_version=""
    if timeout 20 git fetch --quiet "https://github.com/${canon_slug}" HEAD 2>/dev/null; then
      canon_version="$(git show FETCH_HEAD:SYSTEM.md 2>/dev/null | version_of)" || true
    fi

    if [[ -z "${canon_version}" ]]; then
      drift=" Template drift check: UNAVAILABLE (could not read the canon's SYSTEM.md; this copy is at ${here_version:-unknown}). Say the check did not run rather than assuming this copy is current."
    elif [[ "${canon_version}" != "${here_version}" ]]; then
      drift=" Template drift: this copy is at ${here_version:-unknown} and the canon is at ${canon_version}. Rules and hooks here are the older ones, so a rule written upstream is not in force in this session. Before substantive work, tell the Principal and offer to sync (SYSTEM.md §6): a pull request bringing the canon's template into this copy's main, then tools/sync.sh onto the agent branch."
    fi
  fi
fi

# Findings kept instead of sent upstream, at session start only (§1, §9).
# The canon has no agent and no backlog, so this is silent there by construction.
# It reports and never blocks: deciding that a finding generalizes is a judgment,
# and a rail on a judgment lies (§8).
candidates=""
if [[ "${event}" == "SessionStart" && -f memory/state.md ]]; then
  waiting="$(bash tools/candidates.sh 2 2>/dev/null)" || waiting=""
  if [[ -n "${waiting}" ]]; then
    candidates=" Findings tagged for upstream and still waiting:
${waiting}
Each one reaches other copies only through a pull request to the canon (§9). Route them or say why they stay."
  fi
fi

# Resumption after a cleared window (§9 succession). A clear empties the
# conversation and leaves no turn behind, so the notes on disk are read only if
# the agent happens to remember to read them — rung 5, and it holds nothing.
# The runtime names the source, so the hand-back becomes a turn the agent
# cannot miss: `initialUserMessage` enters the conversation as if the Principal
# had typed it.
#
# `clear` only. On `compact` the runtime's summary already carries the thread,
# and an injected turn would talk over work still in flight. On `startup` and
# `resume` nothing was destroyed. The message names the notes by path, because
# a reader never looks for what they must read (§3).
resume=""
if [[ "${event}" == "SessionStart" && "${origin_kind}" == "clear" && -f memory/state.md ]]; then
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
  resume="${resume} Open the reply with the session header (§9)."
fi

HOOK_EVENT="${event}" \
HOOK_CONTEXT="Anchors (hook-measured): time=${timestamp} branch=${branch}. Open the reply with the header built from these values. Never work on main.${menu}${drift}${candidates}" \
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
