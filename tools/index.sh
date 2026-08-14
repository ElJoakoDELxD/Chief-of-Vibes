#!/usr/bin/env bash
#
# Generates INDEX.md: where every rule is stored, and what this repository can do.
#
# The index is generated and nobody maintains it (SYSTEM.md section 1). A
# hand-written list is a second copy, and it starts to drift the day after
# somebody writes it. This one reads the tree, so an entry exists because the
# thing exists, and a thing that exists is listed.
#
# Usage:  bash tools/index.sh           # print to stdout
#         bash tools/index.sh > INDEX.md
#         bash tools/index.sh --check   # exit 1 when INDEX.md is stale

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

generate() {
python3 - <<'PY'
import glob, os, re, sys

# A Windows console defaults to a codepage that cannot encode §, and python's
# text stdout rewrites every newline as CRLF. Redirected into a file, the result
# is neither valid UTF-8 nor byte-identical to what CI regenerates on Linux, so
# the check reports a stale tree that nobody touched. Both are fixed at the
# stream, once, rather than at each print.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", newline="\n")

def anchor(title):
    a = title.lower()
    a = re.sub(r"[^\w\s-]", "", a)
    return re.sub(r"\s+", "-", a.strip())

out = []
w = out.append

core = open("SYSTEM.md", encoding="utf-8").read()
version = re.search(r"\*\*Version ([0-9]+\.[0-9]+\.[0-9]+)\.\*\*", core)

# The specification is a core plus leaves, so a section lives in one of two
# places and the index has to read both. tools/sections.sh checks that this
# reading and the core's own map agree.
sources = {"SYSTEM.md": core}
# glob returns the platform's separator, and these paths are printed into the
# index as links. On Windows that emits a backslash path, which the check then
# reads back as a stale index on a tree nobody touched. Normalising here keeps
# the generated file identical on every platform.
def g(pattern):
    return sorted(x.replace(os.sep, "/") for x in glob.glob(pattern))

for leaf in g("system/*.md"):
    sources[leaf] = open(leaf, encoding="utf-8").read()

sections = []
for path, text in sources.items():
    for num, title in re.findall(r"(?m)^## (\d+)\. (.+)$", text):
        sections.append((int(num), title, path))
sections.sort()

spec = "\n".join(sources.values())

w("# INDEX\n")
w("Where a rule is stored, and what this repository can do. `tools/index.sh` generates")
w("this file from the tree. Do not edit it: CI regenerates it and fails when it is stale.\n")
w(f"Specification version: **{version.group(1) if version else 'unknown'}**\n")

w("## The specification\n")
w("`SYSTEM.md` is the core, read every session. `system/` holds the leaves, read when the")
w("work reaches them. Each section is one address.\n")
w("| Section | Holds | File |")
w("|---|---|---|")
for num, title, path in sections:
    w(f"| [§{num}]({path}#{anchor(str(num) + '. ' + title)}) | {title} | `{path}` |")

sec3 = re.search(r"(?ms)^## 3\..*?(?=^## \d+\.|\Z)", core)
if sec3:
    names = re.findall(r"(?m)^- \*\*([^*]+)\*\*", sec3.group(0))
    w(f"\n### The rules of §3, by name. There are {len(names)}.\n")
    for n in names:
        w(f"- {n.strip()}")

w("\n## Capabilities\n")
w("Read from `.claude/skills/`, the same source `tools/skills.sh` reads.\n")
w("| Skill | Summary | Leaves |")
w("|---|---|---|")
for f in g(".claude/skills/*/SKILL.md"):
    d = os.path.dirname(f)
    name = os.path.basename(d)
    text = open(f, encoding="utf-8").read()
    m = re.search(r"(?m)^summary:\s*(.+)$", text)
    summary = m.group(1).strip() if m else "no summary field"
    leaves = sorted(os.path.basename(x)[:-3] for x in glob.glob(f"{d}/references/*.md"))
    w(f"| `{name}` | {summary} | {', '.join(leaves) if leaves else '—'} |")

w("\n## Machinery\n")
w("| Tool | What it does |")
w("|---|---|")
for f in sorted(g("tools/*.sh") + g("tools/*.py")):
    text = open(f, encoding="utf-8").read()
    if f.endswith(".py"):
        # A python tool states itself in its docstring's first line, where a
        # shell tool states itself in the comment under the shebang.
        m = re.search(r'(?m)^"""(.+)$', text)
        desc = m.group(1).strip() if m else "no description"
    else:
        lines = text.split("\n")[1:10]
        desc = next((l[2:].strip() for l in lines if re.match(r"^# [A-Z]", l)), "no description")
    w(f"| `{f}` | {desc} |")

entries = g("knowledge/*.md")
if entries:
    w("\n## What this repository has learned\n")
    w("| Entry | Topic | Verified by |")
    w("|---|---|---|")
    for f in entries:
        text = open(f, encoding="utf-8").read()
        t = re.search(r"(?m)^topic:\s*(.+)$", text)
        v = re.search(r"(?m)^verified:\s*(.+)$", text)
        vs = v.group(1).strip() if v else "NOT STATED"
        if len(vs) > 70:
            vs = vs[:70] + "…"
        w(f"| [`{os.path.basename(f)}`]({f}) | {t.group(1).strip() if t else '—'} | {vs} |")

print("\n".join(out))
PY
}

if [[ "${1:-}" == "--check" ]]; then
  if [[ ! -f INDEX.md ]]; then
    printf 'INDEX.md is missing. Run: bash tools/index.sh > INDEX.md\n' >&2
    exit 1
  fi
  if ! diff -q <(generate) INDEX.md >/dev/null 2>&1; then
    printf 'INDEX.md is stale. Run: bash tools/index.sh > INDEX.md\n\n' >&2
    diff <(generate) INDEX.md | head -20 >&2
    exit 1
  fi
  printf 'INDEX.md is current.\n'
  exit 0
fi

generate
