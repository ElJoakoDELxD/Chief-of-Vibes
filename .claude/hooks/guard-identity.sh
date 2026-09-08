#!/usr/bin/env bash
#
# Claude Code hook (PreToolUse on Bash): refuses a git invocation that sets the
# commit identity inline.
#
# The two flags that name an author are both refused, and the second is not an
# afterthought. The Principal ruled on 03-09-2026 that the agent **observes** its
# identity and never sets it: the environment configures it and a session-start
# hook pins it, because the signing key is registered to that address. Whether
# the value an override substitutes is a good one is not the question.
#
# The failure it exists to end: on 03-09-2026 an agent authored four commits
# under the Principal's personal address, taken from the session context, into a
# public repository. The first fix replaced a bad override with a good one and
# called the leak stopped, when the override itself was the defect.
#
# A rail narrowed to the email alone would bend around the habit it exists to
# catch, which is why it covers the name too.
#
# **What it judges, and what it leaves to judgment.** It reads the text the shell
# will run, which .claude/hooks/lib/command.sh separates from the text on its way
# to a file. A bench holding these flags as fixtures is data and passes; the same
# body piped into a shell is a command and does not. Whether a given override is
# defensible is intent, so no rail decides it: the custodian post carries that,
# and the answer written down is that none is.
#
# Exit 2 denies the call, reason on stderr. Input: PreToolUse hook JSON on stdin.

set -uo pipefail
# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/lib/command.sh"

command="$(hook_command)"
[[ -n "${command}" ]] || exit 0

# Only a git invocation, and only the -c form that sets an identity. Prose about
# the rule must not trip it: the match requires `git` on the same segment.
while IFS= read -r segment; do
  printf '%s' "${segment}" | grep -qE '(^|[[:space:];&|(])git([[:space:]]|$)' || continue
  if printf '%s' "${segment}" | grep -qE -- '-c[[:space:]]*user\.(email|name)='; then
    {
      echo "BLOCKED by guard-identity.sh: that command sets the commit identity inline."
      echo "The agent observes its identity and never sets it (SYSTEM.md section 7)."
      echo "Read what the environment configured and confirm it matches. A mismatch is"
      echo "reported, never corrected in place."
    } >&2
    exit 2
  fi
# A trailing newline, because `read` returns non-zero on a last line without
# one and the loop body then never runs. The first version of this rail passed
# every case it was meant to refuse, silently, for exactly that reason.
done < <(command_segments "$(executable_text "${command}")"; printf '\n')

exit 0
