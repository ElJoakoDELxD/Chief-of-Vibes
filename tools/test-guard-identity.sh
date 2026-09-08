#!/usr/bin/env bash
#
# Bench for .claude/hooks/guard-identity.sh. It pins both directions: what must
# be refused, and what must be left alone. A rail that blocks ordinary work gets
# turned off, and a rail narrowed around the habit it exists to catch is not a
# rail (SYSTEM.md section 8).
#
# **This file is written by a shell here-document, and that is the point.** It
# holds the exact strings the rail refuses, so an earlier version of the rail
# read the write as the command and denied it. The comment here then called that
# erring closed. It was not. A body on its way to a file is data by the shell's
# own grammar, and .claude/hooks/lib/command.sh reads that grammar, so the rail
# now judges what will run and nothing else. The last two sections below pin
# both sides of it.
#
# Usage:  bash tools/test-guard-identity.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
hook="${here}/../.claude/hooks/guard-identity.sh"

fails=0
feed() {  # feed <command> -> exit code of the hook
  printf '{"tool_input":{"command":%s}}' \
    "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$1")" \
    | bash "${hook}" >/dev/null 2>&1
  printf '%s' "$?"
}
denied() {  # denied <command> <label>
  local code; code="$(feed "$1")"
  if [[ "${code}" == 2 ]]; then printf 'ok   %s\n' "$2"
  else printf 'FAIL %s: wanted exit 2, got %s\n' "$2" "${code}"; fails=$((fails + 1)); fi
}
allowed() {  # allowed <command> <label>
  local code; code="$(feed "$1")"
  if [[ "${code}" == 0 ]]; then printf 'ok   %s\n' "$2"
  else printf 'FAIL %s: wanted exit 0, got %s\n' "$2" "${code}"; fails=$((fails + 1)); fi
}

# The email was the half an earlier version narrowed to. The name is refused for
# the same reason: the override itself is the defect, not the value it carries.
denied 'git -c user.email=someone@example.com commit -m x' "an inline email override is refused"
denied 'git -c user.name=Someone commit -m x'              "an inline name override is refused too"
denied 'git -c user.email=a@b -c user.name=C commit'       "both at once is refused"
denied 'git  -c  user.email=a@b  commit'                   "extra spacing does not evade it"
denied 'cd /tmp && git -c user.name=X commit -m y'         "a later segment is read, not only the first"

allowed 'git commit -m "ordinary work"'                    "a plain commit is untouched"
allowed 'git config user.email'                            "reading the configured identity is allowed"
allowed 'git -c core.pager=cat log'                        "an unrelated -c setting is untouched"
allowed 'git push -u origin some-branch'                   "a push is untouched"

# Text is not a command, where the two can be told apart. The flag alone, with
# no git invocation beside it, is prose or a search and must not fire.
allowed 'echo "the flag we refuse is the identity one" > note.md' "prose is not a git invocation"
allowed 'grep -rn "identity override" tools/'              "searching for the rule is allowed"

# A body on its way to a file is data. This is the write that authors this very
# file, and refusing it taught the agent to route around the rail instead.
allowed "$(printf 'cat > tools/bench.sh <<%sEOF%s\ngit -c user.email=a@b commit -m x\nEOF\n' "'" "'")" \
        "a here-document writing a fixture is data, not a command"
allowed "$(printf 'cat > tools/bench.sh <<EOF\ngit -c user.name=Someone commit\nEOF\necho written\n')" \
        "an unquoted here-document into a file is data too"

# The same body reaching a shell is a command, and stays refused. This is the
# half that makes dropping the other one safe.
denied "$(printf 'cat <<EOF | bash\ngit -c user.email=a@b commit -m x\nEOF\n')" \
       "a here-document piped into a shell is a command"
denied "$(printf 'bash <<EOF\ngit -c user.name=Someone commit\nEOF\n')" \
       "a here-document fed straight to a shell is a command"

if (( fails )); then echo ".claude/hooks/guard-identity.sh: bench FAILED"; exit 1; fi
echo ".claude/hooks/guard-identity.sh: bench passed"
