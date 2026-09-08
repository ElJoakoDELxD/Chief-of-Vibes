#!/usr/bin/env bash
#
# Shared reader for the PreToolUse rails. It answers one question, and it is the
# only question a rail can answer without guessing: **what will the shell
# actually run?**
#
# Why it exists. Each rail used to judge the whole command string, so a file
# being written was read as a command being run. Writing the bench for a rail
# tripped the rail, and the comments that grew around that called it erring
# closed. It was not: a here-document body is data by the shell's own grammar,
# the same grammar the rail is reading, so treating it as a command is a false
# positive and SYSTEM.md section 8 says what those cost. A rail routed around
# protects less than none.
#
# What is mechanical, and what is not. That a body is data is grammar. Whether
# running a given command is right is intent, and no rail decides that. The
# division is deliberate: a rail keeps the half it can prove, and the other half
# is named to a post and left to judgment (SYSTEM.md section 8).
#
# The limit, stated rather than papered over. A command written to a file now
# and run by name in the next call walks past every rail here, as it always did.
# These rails stop the reflex; they do not defeat an adversary.
#
# Usage:  source .claude/hooks/lib/command.sh
#         command="$(hook_command)"          # the command field, from stdin JSON
#         text="$(executable_text "${command}")"
#         segments="$(command_segments "${text}")"

# The command field of a PreToolUse payload on stdin. Empty for Edit and Write,
# which carry no command, and empty for malformed input.
hook_command() {
  local input
  input="$(cat)"
  printf '%s' "${input}" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))' \
    2>/dev/null || printf ''
}

# The interpreters. A here-document reaching one of these is executed, so its
# body stays. Anywhere on the opener line counts, because the body can be piped
# onward as easily as fed directly.
_COV_INTERPRETERS='sh|bash|zsh|ksh|dash|ash|busybox|python|python2|python3|node|deno|bun|perl|ruby|php|eval|source|exec|xargs|env|command'

# The command with every here-document body removed, except the bodies that
# reach an interpreter. Line-oriented, following the shell's own rule: after an
# opener the lines up to the delimiter are data, and `<<-` strips leading tabs
# from the delimiter line.
executable_text() {
  printf '%s\n' "$1" | python3 -c '
import re, sys

INTERP = re.compile(r"(^|[|&;(\s])(" + sys.argv[1] + r")([\s|;&)]|$)")
OPENER = re.compile(r"<<(-?)\s*([\x27\"]?)([A-Za-z_][A-Za-z0-9_]*)\2")

out, delim, dash, keep = [], None, False, False
for line in sys.stdin.read().split("\n"):
    if delim is not None:
        candidate = line.lstrip("\t") if dash else line
        if candidate.strip() == delim:
            delim = None
        elif keep:
            out.append(line)
        continue
    out.append(line)
    m = OPENER.search(line)
    if m:
        dash = m.group(1) == "-"
        delim = m.group(3)
        # Err closed: an opener line that names an interpreter, or that builds
        # its command by substitution, keeps its body as executable text.
        head = OPENER.sub(" ", line)
        keep = bool(INTERP.search(head)) or "$(" in head or "`" in head
print("\n".join(out))
' "${_COV_INTERPRETERS}"
}

# One segment per line: the shell operators that separate commands, plus the
# newline. A rail judges each segment alone, so prose in one is never evidence
# about a git invocation in the next.
command_segments() {
  printf '%s' "$1" | sed 's/&&/\n/g; s/||/\n/g' | tr ';|&' '\n'
}
