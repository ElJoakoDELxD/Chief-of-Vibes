#!/usr/bin/env bash
#
# Checks that the specification's map and its tree agree.
#
# SYSTEM.md is the core and `system/` holds the leaves, so most of the
# specification is read on demand. That is only safe while the pointer is
# true: an agent that follows a row to a file which does not hold that section
# has been told a rule exists somewhere it does not. So the map is checked
# rather than trusted (SYSTEM.md section 8, consistency).
#
# It is the same contract as tools/index.sh --check, one level down: where the
# system asserts something about itself and both sides can be read, the check
# reads both.
#
# Four ways the two can disagree, and each one is named rather than counted:
#   - a section in the tree with no row in the map
#   - a row in the map pointing at a file that does not hold that section
#   - the same section number in two places
#   - a leaf whose filename does not match the section it holds
#
# Usage:  bash tools/sections.sh            # print the map it read
#         bash tools/sections.sh --check    # exit 1 on any disagreement

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

MODE="${1:-}" python3 - <<'PY'
import glob, os, re, sys, unicodedata

# A Windows console defaults to a codepage that cannot encode §, and python's
# text stdout rewrites every newline as CRLF. Redirected into a file, the result
# is neither valid UTF-8 nor byte-identical to what CI regenerates on Linux, so
# the check reports a stale tree that nobody touched. Both are fixed at the
# stream, once, rather than at each print.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", newline="\n")

def slug(title):
    s = unicodedata.normalize("NFKD", title).encode("ascii", "ignore").decode()
    s = re.sub(r"[^\w\s-]", " ", s).strip().lower()
    return re.sub(r"[\s_]+", "-", s).strip("-")

problems, found = [], {}

def scan(path):
    text = open(path, encoding="utf-8").read()
    for num, title in re.findall(r"(?m)^## (\d+)\. (.+)$", text):
        if num in found:
            problems.append(f"§{num} is defined twice: {found[num][1]} and {path}")
        found[num] = (title.strip(), path)

scan("SYSTEM.md")
# glob returns the platform's separator, so on Windows every leaf compares
# unequal to the map's forward-slash path and the check fails on a healthy tree.
leaves = sorted(x.replace(os.sep, "/") for x in glob.glob("system/*.md"))
for leaf in leaves:
    before = set(found)
    scan(leaf)
    held = [n for n in found if n not in before]
    if not held:
        problems.append(f"{leaf} holds no section heading, so nothing can point at it")
        continue
    if len(held) > 1:
        problems.append(f"{leaf} holds more than one section: {', '.join('§' + n for n in held)}")
    n = held[0]
    want = f"system/{n}-{slug(found[n][0])}.md"
    if leaf != want:
        problems.append(f"{leaf} holds §{n} '{found[n][0]}', so its name should be {want}")

# The map in the core, read as the claim it is.
core = open("SYSTEM.md", encoding="utf-8").read()
rows = re.findall(r"(?m)^\| §(\d+) \| (.+?) \| (.+?) \|$", core)
mapped = {}
for num, title, where in rows:
    target = "SYSTEM.md" if "**here**" in where else (
        re.search(r"\((system/[^)]+)\)", where).group(1)
        if re.search(r"\((system/[^)]+)\)", where) else where.strip())
    mapped[num] = (title.strip(), target)

for num in sorted(set(found) | set(mapped), key=int):
    if num not in mapped:
        problems.append(f"§{num} '{found[num][0]}' is in {found[num][1]} and has no row in the map")
        continue
    if num not in found:
        problems.append(f"the map has a row for §{num} '{mapped[num][0]}' and no file holds it")
        continue
    real_title, real_path = found[num]
    map_title, map_path = mapped[num]
    if map_path != real_path:
        problems.append(f"the map sends §{num} to {map_path}; it lives in {real_path}")
    if map_title != real_title:
        problems.append(f"the map calls §{num} '{map_title}'; the heading says '{real_title}'")

numbers = sorted(map(int, found))
if numbers and numbers != list(range(1, len(numbers) + 1)):
    problems.append(f"the sections are not 1..{len(numbers)}: found {numbers}")

if os.environ.get("MODE") == "--check":
    if problems:
        print("The specification's map and its tree disagree:")
        for p in problems:
            print(f"  {p}")
        sys.exit(1)
    print(f"The map matches the tree: {len(found)} sections, {len(leaves)} leaves.")
    sys.exit(0)

for num in sorted(found, key=int):
    title, path = found[num]
    print(f"§{num:<2} {title:<30} {path}")
if problems:
    print("\nDisagreements (run with --check to fail on these):")
    for p in problems:
        print(f"  {p}")
PY
