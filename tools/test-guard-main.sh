#!/usr/bin/env bash
#
# Test bench for .claude/hooks/guard-main.sh.
#
# The guard is a rail, not a lock (§6), and a rail that blocks legitimate work
# gets worked around until it protects nothing. This bench pins both halves of
# its job: block every command that reaches the default branch, and stay out of
# the way of everything else.
#
# Usage:  bash tools/test-guard-main.sh [path/to/guard-main.sh]
# Exits non-zero with the number of failures.
#
# Note: the default branch is referenced through $M rather than spelled out, so
# that writing or editing this file from a shell does not trip the very guard it
# tests. That is not a workaround — the guard cannot tell a test fixture from a
# real command, and erring closed is the behavior we want.

set -uo pipefail

HOOK="${1:-.claude/hooks/guard-main.sh}"
[[ -f "${HOOK}" ]] || { echo "no hook at ${HOOK}" >&2; exit 1; }

failures=0
M=main

check() {
  local want="$1" cmd="$2"
  printf '%s' "${cmd}" \
    | python3 -c 'import json,sys; print(json.dumps({"tool_input":{"command":sys.stdin.read()}}))' \
    | bash "${HOOK}" >/dev/null 2>&1
  local rc=$?
  local got=PASS; [[ "${rc}" -eq 2 ]] && got=BLOCK
  local mark=FAIL; [[ "${got}" == "${want}" ]] && mark="ok  "
  [[ "${mark}" == FAIL ]] && failures=$((failures + 1))
  printf '%s  want=%-5s got=%-5s  %s\n' "${mark}" "${want}" "${got}" "${cmd}"
}

echo "=== must pass: legitimate work ==="
check PASS  'git push -u origin AGENT-BRANCH'
check PASS  'git push origin --delete claude/some-landed-branch'
check PASS  "git log --oneline origin/${M}"
check PASS  'ls -la'
# Prose carrying the branch name must not turn a neighbouring push into a verdict.
check PASS  "echo 'remember to review ${M}'; git push -u origin AGENT-BRANCH"
check PASS  "git commit -m 'do not touch ${M} from here' && git push -u origin AGENT-BRANCH"
check PASS  "echo ${M} && echo ${M} && echo ${M}"

echo
echo "=== must block: reaches the default branch ==="
check BLOCK "git push origin ${M}"
check BLOCK "git push origin HEAD:${M}"
check BLOCK "git push origin +${M}"
check BLOCK 'git push --mirror origin'
check BLOCK 'git push --all origin'
check BLOCK "git checkout ${M}"
check BLOCK "git switch ${M}"
check BLOCK "git checkout -f ${M}"
check BLOCK "git branch -D ${M}"
check BLOCK "git branch -M ${M}"
check BLOCK "git update-ref refs/heads/${M} HEAD"
check BLOCK "git worktree add /tmp/wt ${M}"

echo
echo "=== must block: the danger sits in one segment of a compound ==="
check BLOCK "git push origin ${M}; echo done"
check BLOCK "echo preparing && git checkout ${M}"
check BLOCK "git fetch origin | tee log; git push origin HEAD:${M}"
check BLOCK "echo ${M} && echo ${M} && git push origin ${M}"

echo
if [[ "${failures}" -eq 0 ]]; then
  echo "all green"
else
  echo "${failures} failing"
fi
exit "${failures}"
