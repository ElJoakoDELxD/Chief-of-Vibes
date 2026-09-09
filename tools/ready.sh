#!/usr/bin/env bash
#
# Answers one question before a change is proposed to the canon: can this
# session carry it well, right now.
#
# The trigger is the direction, not the edit. Changing the template inside your
# own copy is your copy's business and costs nobody else anything. Taking it to
# the canon puts it in front of every copy that will ever sync, and that is
# where doing it badly damages the thing that would have caught it. So the
# precondition is measured rather than felt (SYSTEM.md section 8).
#
# It is also where the cost lands. The session proposing pays for its own
# reading, and the canon pays nothing to be proposed to.
#
# Three questions, none of them a judgment:
#
#   1. Are this repository's own rails green? A session whose benches fail
#      cannot judge a change to them, and would be reading a red tree as noise.
#   2. Is this copy at the canon's version? Section 6 already says a copy on an
#      older specification obeys superseded rules. Proposing upstream from a
#      drifted copy proposes against a document that already moved.
#   3. What does admission cost? The specification, its leaves and the memory a
#      session opens have to be read before the first edit, and that reading is
#      the entry fee. It is reported in characters, which are measured, and in
#      tokens through a stated divisor, which is a conversion and says so.
#
# What this deliberately does NOT do: guess how much context window is left. The
# runtime owns that number and this tool cannot see it, so it reports the fee
# and names the half it cannot measure. An estimated budget is the fabricated
# reading section 3 forbids, and it would be the most convincing kind.
#
# Rung 3: it reports and never blocks, so it always exits 0. Whether to proceed
# is the session's call, made against numbers instead of a feeling.
#
# Usage:  bash tools/ready.sh            # the full report
#         bash tools/ready.sh --fee      # the entry fee alone, one line

set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || { echo "$(basename "$0"): could not reach the repository root; nothing was measured." >&2; exit 1; }

# Characters per token. Stated rather than hidden, because every token figure
# below is this divisor's opinion and not a measurement. 3.8 is the ratio this
# repository has used since 02-08-2026; the hard number needs a tokenizer the
# session does not carry.
DIVISOR=3.8

fee_chars() {
  local total=0 f
  for f in SYSTEM.md CLAUDE.md INDEX.md system/*.md \
           memory/state.md memory/backlog.md memory/corrections.md; do
    [[ -f "${f}" ]] && total=$(( total + $(wc -c < "${f}" | tr -d '[:space:]') ))
  done
  printf '%s' "${total}"
}

chars="$(fee_chars)"
tokens="$(awk -v c="${chars}" -v d="${DIVISOR}" 'BEGIN { printf "%d", c / d }')"

if [[ "${1-}" == "--fee" ]]; then
  printf '%s chars, about %s tokens at %s chars/token\n' "${chars}" "${tokens}" "${DIVISOR}"
  exit 0
fi

echo "Ready to take this to the canon?"
echo

# --- 1. the rails ---------------------------------------------------------
red=0
green=0
# **Green is exit 0 AND at least one case reported.** A bench that dies before its
# first assertion exits 0 having asserted nothing, and every reader that trusts the
# exit code alone counts it as passing. Measured 08-09-2026: replacing a sourced
# library with `exit 0` made its bench print nothing, exit 0, and read as green in
# this loop. That is the shape section 8 names — logic whose failure mode is a
# green check — and it is the second time this repository has hit it.
for bench in tools/test-*.sh; do
  [[ -f "${bench}" ]] || continue
  out="$(bash "${bench}" 2>&1)"; code=$?
  cases="$(printf '%s' "${out}" | grep -cE '^(ok|FAIL)')"
  if (( code == 0 )) && (( cases > 0 )); then
    green=$(( green + 1 ))
  elif (( code == 0 )); then
    red=$(( red + 1 ))
    echo "  MUTE  ${bench} exited 0 and asserted nothing. A bench that ran no case did not pass."
  else
    red=$(( red + 1 ))
    echo "  RED   ${bench}"
  fi
done
if (( red )); then
  echo "  Rails: ${green} green, ${red} red. Fix the red one before editing what it guards."
else
  echo "  Rails: ${green} of ${green} benches green."
fi

# --- 2. parity with the canon ---------------------------------------------
# Read from the tree, never from the network: this tool is a local probe and the
# anchor hook already makes the one network call at session start (§1).
version() { sed -n 's/^\*\*Version \([0-9][0-9.]*\)\.\*\*.*/\1/p' "$1" 2>/dev/null | head -n1; }
here_v="$(version SYSTEM.md)"
main_v="$(git show origin/main:SYSTEM.md 2>/dev/null | sed -n 's/^\*\*Version \([0-9][0-9.]*\)\.\*\*.*/\1/p' | head -n1)"
if [[ -z "${here_v}" ]]; then
  echo "  Version: SYSTEM.md carries no version line, so nothing can be compared."
elif [[ -z "${main_v}" ]]; then
  echo "  Version: ${here_v} here. No local origin/main to compare against, so parity is UNCHECKED."
elif [[ "${here_v}" == "${main_v}" ]]; then
  echo "  Version: ${here_v}, matching origin/main."
else
  echo "  Version: ${here_v} here against ${main_v} on origin/main. Land the gap before proposing (§6)."
fi
echo "             Parity with the canon is a different question, answered by the"
echo "             drift check at session start. This one only reads the tree."

# --- 3. the entry fee ------------------------------------------------------
echo "  Entry fee: ${chars} chars of specification and memory, about ${tokens} tokens at ${DIVISOR} chars/token."
echo "  Remaining window: UNREADABLE from here. The runtime owns it, so the session"
echo "                    reads it there and compares, or says it could not."

# --- 4. what this change grows ---------------------------------------------
# Section 8: **if a change grows the machinery and the prose both, it has not
# finished.** That test was rung 4 and applied to one release at a time, so a run
# of them could add to both and no release was ever the one that broke the rule.
# Measured 09-09-2026 over thirteen: +2724 words of specification and +1046 lines
# of shell, with nothing having reported it. Reading it is still judgment; the
# labour of looking is what moves here.
prose_now=0; prose_was=0; code_now=0; code_was=0
for f in SYSTEM.md CLAUDE.md README.md CONTRIBUTING.md $(ls system/*.md 2>/dev/null); do
  [[ -f "${f}" ]] && prose_now=$(( prose_now + $(wc -w < "${f}") ))
  was="$(git show "origin/main:${f}" 2>/dev/null | wc -w)" || was=0
  prose_was=$(( prose_was + was ))
done
while IFS= read -r f; do
  [[ -f "${f}" ]] && code_now=$(( code_now + $(wc -l < "${f}") ))
done < <(ls tools/*.sh .claude/hooks/*.sh .claude/hooks/lib/*.sh .github/*.sh 2>/dev/null)
while IFS= read -r f; do
  [[ -z "${f}" ]] && continue
  was="$(git show "origin/main:${f}" 2>/dev/null | wc -l)" || was=0
  code_was=$(( code_was + was ))
done < <(git ls-tree -r --name-only origin/main 2>/dev/null | grep -E '^(tools|\.claude/hooks|\.claude/hooks/lib|\.github)/.*\.sh$')
dp=$(( prose_now - prose_was )); dc=$(( code_now - code_was ))
printf '  Growth against main: prose %+d words, machinery %+d lines.\n' "${dp}" "${dc}"
if (( dp > 0 && dc > 0 )); then
  echo "                       Both grew. Section 8 calls that unfinished: say what was"
  echo "                       removed and make the case, or pay one of them down."
fi

echo
echo "The fee is the floor, not the cost. It buys reading, and the proposal is still unwritten."
exit 0
