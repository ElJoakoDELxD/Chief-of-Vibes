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

# `.canon` names the canon as owner/repo, and the comparison is case-insensitive
# because GitHub treats owner/repo that way.
lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }
canon="$(lower "$(tr -d '[:space:]' < .canon 2>/dev/null)")"
here="$(lower "${repo}")"
is_canon=0
[[ -n "${canon}" && "${canon}" == "${here}" ]] && is_canon=1

fail=0

# --- 1. only template files reach main ----------------------------------------
# Agent memory and project output belong on agent branches. knowledge/ (section
# 5) is where a COPY records what its agents verified; the canon has no agents
# and therefore nothing to have learned, so there the folder is rejected like
# any other non-template path.
allow='^((SYSTEM|CLAUDE|README|CONTRIBUTING|LANGUAGES|CLOCKS|INDEX)\.md|LICENSE|repomix\.config\.json|\.gitignore|\.canon)$|^(\.claude|\.github|tools|system)/'
if (( is_canon )); then
  scope='outside the template — knowledge/ belongs in a copy, not the canon'
else
  allow="${allow}|^knowledge/"
  scope='outside the template'
fi

while IFS= read -r -d '' f; do
  if ! printf '%s' "${f}" | grep -qE "${allow}"; then
    echo "REJECT: ${f} is ${scope}"
    fail=1
  fi
done < <(git diff -z --name-only "${base}...${head}")
(( fail )) || echo "Paths: every changed file is a template file."

# --- 2. a template change is a release ----------------------------------------
# The canon holds the master version, and a copy holds a superset of it. A copy
# improves itself first and proposes upstream in a batch, so its own main moves
# while the version stays where the canon put it. Asking a copy for a bump would
# make it invent numbers the canon never issued.
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
