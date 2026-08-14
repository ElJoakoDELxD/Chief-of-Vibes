#!/usr/bin/env bash
#
# Scores prose against the writing system in .claude/skills/ste-writing/
# (derived from ASD-STE100). Prints violations per 100 words. Lower is better.
# The publication register (SYSTEM.md section 7) sets the gate: < 1.5 to publish.
#
# Own implementation. The idea comes from woosal1337's ste-lint experiment
# (see the skill's provenance); the code here is this repository's.
#
# Usage:  bash tools/prose-lint.sh <file.md> [...]

set -uo pipefail

python3 - "$@" <<'PY'
import re, sys

# A Windows console defaults to a codepage that cannot encode §, and python's
# text stdout rewrites every newline as CRLF. Redirected into a file, the result
# is neither valid UTF-8 nor byte-identical to what CI regenerates on Linux, so
# the check reports a stale tree that nobody touched. Both are fixed at the
# stream, once, rather than at each print.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", newline="\n")

MARKETING = {"seamless","seamlessly","robust","powerful","cutting-edge","effortless",
 "world-class","revolutionary","blazing","elegant","delightful","best-in-class",
 "state-of-the-art","game-changing","battle-tested","enterprise-grade","supercharge",
 "unlock","unleash","empower","empowers"}
WORDY = {"utilize","utilizes","utilizing","leverage","leverages","leveraging",
 "facilitate","facilitates","commence","commences","obtain","obtains","acquire",
 "demonstrate","demonstrates","additionally","furthermore","moreover","aforementioned",
 "whilst","amongst","myriad","plethora","comprehensive"}
PHRASES = ["in order to","prior to","subsequent to","due to the fact that",
 "it is important to note","it should be noted","it is worth noting","a variety of",
 "not only"]
def strip_code(t):
    t = re.sub(r"```.*?```"," ",t,flags=re.S)
    t = re.sub(r"`[^`]*`"," ",t)
    t = re.sub(r"^\s*\|.*$"," ",t,flags=re.M)          # tables
    t = re.sub(r"\[([^\]]*)\]\([^)]*\)",r"\1",t)       # links -> text
    return t

total_v = total_w = 0
for path in sys.argv[1:]:
    text = strip_code(open(path,encoding="utf-8").read())
    words = re.findall(r"[A-Za-z']+", text)
    low = text.lower()
    v = 0
    v += len(re.findall(r"—", text))                                   # em-dash
    v += len(re.findall(r";", text))                                   # semicolon
    v += sum(low.count(p) for p in PHRASES)
    v += sum(1 for w in words if w.lower() in MARKETING | WORDY)
    v += len(re.findall(r"\b(?:is|are|was|were|been|being|be)\s+\w+ed\b", low))  # passive
    v += len(re.findall(r"\b\w+n't\b|\b(?:it's|that's|there's|here's|what's)\b", low))  # contractions
    # sentence length > 25 words
    for s in re.split(r"[.!?]\s", text):
        if len(re.findall(r"[A-Za-z']+", s)) > 25: v += 1
    n = max(len(words),1)
    print(f"{path:30s} words={n:5d} violations={v:4d} per100w={100*v/n:6.2f}")
    total_v += v; total_w += n
if len(sys.argv) > 2:
    print(f"{'TOTAL':30s} words={total_w:5d} violations={total_v:4d} per100w={100*total_v/total_w:6.2f}")
PY
