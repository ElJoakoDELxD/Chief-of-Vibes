#!/usr/bin/env bash
#
# The two rejections a pull request bound for main has to pass: it touches only
# template files, and a template change bumps the version (SYSTEM.md section 8).
#
# This lived inline in .github/workflows/guard.yml, where nothing could test it.
# Every other check in this repository is a tool with a bench beside it, and the
# one that decides what reaches main was the exception. Logic that only exists
# inside a workflow is logic whose failure mode is a green check.
#
# Both checks always run. The workflow ran them as consecutive steps, which are
# fail-fast, so a rejected path hid whatever the version check would have said
# and the author found the second problem only after fixing the first.
#
# Rung 2: it blocks. Exits 1 when either check rejects, 0 when both pass.
#
# Usage:  bash tools/pr-guard.sh <base-ref> <head-ref> [owner/repo]
#
# The repository argument decides one thing only: whether this is the canon.
# It defaults to the `origin` remote, so a local run answers like CI does.

set -uo pipefail

base="${1:?usage: pr-guard.sh <base-ref> <head-ref> [owner/repo]}"
head="${2:?usage: pr-guard.sh <base-ref> <head-ref> [owner/repo]}"
repo="${3:-}"

if [[ -z "${repo}" ]]; then
  repo="$(git config --get remote.origin.url 2>/dev/null \
    | sed -E 's#^.*[:/]([^/]+/[^/]+?)(\.git)?/?$#\1#')" || repo=""
fi

# Custody is held with the post, not shipped in the template, so `.canon` lives
# on the branch that holds it and never reaches main (section 6). A checkout of
# a pull request's head is template content, so this tool cannot read it here.
#
# That is the point rather than a gap. The version question below is a judgment
# about whether a change is a release, made by whoever is writing it, and it is
# asked by running this tool **from the branch that holds the post**, against the
# two refs:
#
#     bash tools/pr-guard.sh origin/main <work-branch> <owner/repo>
#
# The marker is then on disk, where identity is read, while the refs being
# diffed carry none — which is also why no branch name is hard-coded anywhere. What this guard must never do is answer it anyway:
# a missing marker used to mean `is_canon=0`, which printed *no bump required* and
# went green, reporting a check that had not run (section 3).
lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }
# head -n1, matching .claude/hooks/anchor.sh. Until 1.73.0 this read the whole
# file through `tr -d '[:space:]'` while the hook read the first line, so the two
# agreed only while the marker stayed one line. A comment added to explain the
# file would have made this guard match nothing, set is_canon=0, and drop the
# version rail with a green check. The parsers agree now.
canon=""
[[ -f .canon ]] && canon="$(lower "$(head -n1 .canon | tr -d '[:space:]')")"
here="$(lower "${repo}")"
have_marker=0
[[ -n "${canon}" ]] && have_marker=1
is_canon=0
[[ "${have_marker}" == 1 && "${canon}" == "${here}" ]] && is_canon=1


fail=0

# --- 1. only template files reach main ----------------------------------------
# posts/ and functions/ are the catalogue, and they are definitions rather than
# instances: a copy's agent must hold a post from the moment it is created and
# cannot hold one nothing defines, so a fresh copy needs them to become itself
# (section 6). Which post an agent holds is memory/state.md and never travels.
#
# Agent memory and project output belong on agent branches. knowledge/ is a
# template path in both repositories since 1.61.0, and the difference between
# them is no longer WHETHER the folder may exist but WHAT it admits: a copy
# takes whatever it learned, the canon only what is agnostic (section 5). That
# distinction is a judgment about content, so it belongs to the reviewer and not
# to a path pattern. This guard checks the path and says nothing about the
# entry.
allow='^((SYSTEM|CLAUDE|README|CONTRIBUTING|LANGUAGES|CLOCKS|INDEX)\.md|LICENSE|repomix\.config\.json|\.gitignore|\.canon)$|^(\.claude|\.github|tools|system|knowledge|posts|functions)/'
# The vault ships as an empty form, so exactly those paths are template and nothing
# else under memory/ is. A filled form is identity and never reaches main (§5), and
# this is the rail that says so rather than a rule anybody has to remember.
allow="${allow}"'|^memory/(state|backlog|corrections)\.md$|^memory/(journal|handoff|projects|posts|functions|quarantine)/\.gitkeep$'
scope='outside the template'

while IFS= read -r -d '' f; do
  if ! printf '%s' "${f}" | grep -qE "${allow}"; then
    echo "REJECT: ${f} is ${scope}"
    fail=1
  fi
done < <(git diff -z --name-only "${base}...${head}")
(( fail )) || echo "Paths: every changed file is a template file."

# `.canon` stays an allowed *path* so the release that removed it could remove
# it. What is forbidden is the file existing on main: custody belongs to the post
# that holds it and never ships in the template (section 6). Stating the rule as
# presence rather than as an omission from the list above is what lets the error
# say why.
if git cat-file -e "${head}:.canon" 2>/dev/null; then
  echo "REJECT: .canon is on main. Custody lives with the post, on the branch that holds it, and never ships (SYSTEM.md section 6)."
  fail=1
fi

# --- 2. a template change is a release ----------------------------------------
# The canon holds the master version, and a copy holds a superset of it. A copy
# improves itself first and proposes upstream in a batch, so its own main moves
# while the version stays where the canon put it. Asking a copy for a bump would
# make it invent numbers the canon never issued.
if (( ! have_marker )); then
  echo "Version: NOT ASKED HERE. Custody lives with the post, so this checkout carries no marker"
  echo "         and cannot tell the canon from a copy. The question is answered on the branch"
  echo "         the change was written on, before the pull request exists (SYSTEM.md section 6)."
  exit "${fail}"
fi

if (( ! is_canon )); then
  echo "Version: a copy does not carry the master version; no bump required."
  exit "${fail}"
fi

version() {
  git show "$1:SYSTEM.md" 2>/dev/null \
    | sed -n 's/^\*\*Version \([0-9][0-9.]*\)\.\*\*.*/\1/p' | head -n1
}
base_v="$(version "${base}")"
head_v="$(version "${head}")"

if [[ -z "${head_v}" ]]; then
  echo "REJECT: SYSTEM.md carries no '**Version X.Y.Z.**' line"
  exit 1
fi

# A version is a template release, and three kinds of pull request are not one.
# knowledge/ records what this repository learned (section 5). LANGUAGES.md and
# CLOCKS.md are the two reach records (section 8), and a line lands in them when
# somebody used the system somewhere new, which changes no rule. Demanding a
# bump for any of the three would turn the changelog into noise, and treating
# the two reach records differently from each other would be the contradiction
# section 8 warns about. INDEX.md rides along, because it is generated from the
# tree and a new entry always changes it.
if ! git diff --name-only "${base}...${head}" \
     | grep -qvE '^(knowledge/|(INDEX|LANGUAGES|CLOCKS)\.md$)'; then
  echo "Version: record-only change, no bump required (still ${head_v})"
  exit "${fail}"
fi

if [[ "${base_v}" == "${head_v}" ]]; then
  echo "REJECT: every merge into main is a release — bump SYSTEM.md's version (still ${head_v})"
  exit 1
fi

echo "Version ${base_v} → ${head_v}"
exit "${fail}"
