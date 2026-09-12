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
# Arriving is not the same as arriving *here*. A cd that succeeds into a
# directory without these runs the tool against a tree that is not this system's,
# and every count it prints is about that one — measured by a monitor, which
# found a full confident report reading "0 of 0 benches green".
[[ -f SYSTEM.md && -d tools ]] || { echo "$(basename "$0"): $(pwd) is not this repository (no SYSTEM.md and tools/); nothing was measured." >&2; exit 1; }

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
# Reading the numbers is still judgment; the labour of looking is what moves.
#
# Three things this got wrong on its first attempt, each caught by a monitor:
#   - with no origin/main it reported the whole tree as growth, as a fact. A
#     measure that cannot compare says so (section 3), because a fabricated
#     reading inside a sensor is worse than no sensor.
#   - it walked the working tree only, so deleting a file moved the number by
#     zero. A measure that cannot see a payment-down cannot ask for one.
#   - its two sides used different file sets. Both sides read one list now.
if ! git rev-parse --verify -q origin/main >/dev/null 2>&1; then
  echo "  Growth against main: UNAVAILABLE (no origin/main to compare against). Say the measure did not run."
else
  python3 - <<'GROWTH'
import subprocess, glob, os

PROSE = ["SYSTEM.md", "CLAUDE.md", "README.md", "CONTRIBUTING.md"]
# Every prose surface the template ships, not only the specification. A skill,
# a post and a privilege are read by sessions exactly as a section is, and until
# 1.90.0 this counted none of them: a release could add hundreds of words of
# skill and the measure reported +0. INDEX.md is generated, so it is not charged
# to a release, and memory/ never ships filled.
PROSE_DIRS = ("system/", ".claude/skills/", "posts/", "privileges/", "knowledge/")
def prose_paths(names):
    return [n for n in names
            if n in PROSE or (n.endswith(".md") and n.startswith(PROSE_DIRS))]
def code_paths(names):
    return [n for n in names
            if n.endswith(".sh") and (n.startswith("tools/") or n.startswith(".claude/hooks/")
                                      or n.startswith(".github/"))]

def old_names():
    out = subprocess.run(["git", "ls-tree", "-r", "--name-only", "origin/main"],
                         capture_output=True, text=True).stdout.split()
    return out
def new_names():
    # Tracked AND untracked-but-not-ignored. A release adds files, and one that is
    # written but not yet staged is still growth; counting only the tracked side
    # reported +0 for a new tool. Caught by this measure's own bench.
    out = subprocess.run(["git", "ls-files", "--cached", "--others", "--exclude-standard"],
                         capture_output=True, text=True).stdout.split()
    return out

def old_body(path):
    r = subprocess.run(["git", "show", f"origin/main:{path}"], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else ""
def new_body(path):
    try:
        return open(path, encoding="utf-8", errors="replace").read()
    except OSError:
        return ""

# The union of both sides. A path present on one side and absent on the other is
# exactly what a deletion or an addition looks like, and it must count.
old_all, new_all = old_names(), new_names()
union = sorted(set(old_all) | set(new_all))

pw_old = sum(len(old_body(f).split()) for f in prose_paths(union))
pw_new = sum(len(new_body(f).split()) for f in prose_paths(union))
cl_old = sum(old_body(f).count("\n") for f in code_paths(union))
cl_new = sum(new_body(f).count("\n") for f in code_paths(union))

dp, dc = pw_new - pw_old, cl_new - cl_old
print(f"  Growth against main: prose {dp:+d} words, machinery {dc:+d} lines.")
if dp > 0 and dc > 0:
    print("                       Both grew. Section 8 calls that unfinished: say what was")
    print("                       removed and make the case, or pay one of them down.")
GROWTH
fi

echo
echo "The fee is the floor, not the cost. It buys reading, and the proposal is still unwritten."
exit 0
