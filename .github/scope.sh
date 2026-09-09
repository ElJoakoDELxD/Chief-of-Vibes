#!/usr/bin/env bash
#
# Decides whether the guard jobs apply to this pull request, and writes
# skip=true or skip=false to the step output.
#
# **It reads the branch, never its name.** A branch carrying memory/state.md is
# an agent's workspace: it holds memory/ and projects/ by design, and the guard
# jobs would reject exactly what belongs there. Every other branch is template
# work and is checked. Until 1.79.0 the same exclusion was a list of branch-name
# prefixes in the workflow trigger, which named a prefix this repository had
# stopped using; the effect was two layers of a four-layer stack opening with no
# checks. A name list is rung 5 wearing a trigger's clothes (SYSTEM.md section 8),
# and a copy that names its branches differently inherits the defect with it.
#
# The checkout for a pull_request event is the merge of head into base, so the
# file is present whenever the head branch carries it.

set -uo pipefail

# An agent is a FILLED form, never a present file. The vault ships empty on main
# (SYSTEM.md section 5), so every branch carries memory/state.md and only an agent's
# carries a value in `agent:`. Testing existence here would skip the guard jobs on
# every pull request and report success while checking nothing.
if [[ -f memory/state.md ]] \
   && [[ -n "$(sed -n 's/^agent:[[:space:]]*//p' memory/state.md 2>/dev/null | head -n1 | sed 's/[[:space:]]*#.*$//')" ]]; then
  echo "memory/state.md names an agent, so this branch is an agent's workspace."
  echo "The guard jobs check template work and are skipped here (SYSTEM.md section 6)."
  echo "skip=true" >> "${GITHUB_OUTPUT:-/dev/stdout}"
else
  echo "skip=false" >> "${GITHUB_OUTPUT:-/dev/stdout}"
fi
