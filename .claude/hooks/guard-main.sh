#!/usr/bin/env bash
#
# Claude Code hook (PreToolUse on Edit|Write|Bash): keeps the default branch
# read-only. Standing there it blocks everything; elsewhere it blocks the git
# commands that reach it. Exit 2 denies the call, reason on stderr. Input:
# PreToolUse hook JSON on stdin.
#
# A rail, not a lock: it only runs in sessions that wire it, and it reads one
# command at a time. The guarantee is branch protection plus CI.
#
# **It judges what the shell will run, in the position the word holds.** Three
# grammars are already there to be read, and reading them is not a guess:
#
#   the shell's       a here-document body bound for a file is data, and each
#                     segment is a command of its own (lib/command.sh)
#   the shell's       quoting marks where a word starts and ends, so a message
#                     is one word and never a list of refs
#   git's own         a subcommand decides what its operands mean, and only
#                     seven of them can reach a branch at all
#
# So `git commit -m "do not push to main"` is a commit with one message operand,
# and `git push origin main` is a push with a ref. The words are the same. The
# positions are not, and the position is what this reads. Until 1.77.0 the rail
# read the flat string and refused three of five ordinary messages.
#
# Where a command cannot be tokenized, an unbalanced quote being the usual
# reason, it falls back to matching the flat text. That direction is safe and it
# is the only place this errs closed.
#
# What is left over is intent, whether this checkout is the one that was meant,
# and no rail decides that. It belongs to the post holding the session
# (SYSTEM.md section 8). tools/test-guard-main.sh pins every half.

set -uo pipefail
# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/lib/command.sh"

branch="$(git branch --show-current 2>/dev/null || echo "")"
command="$(hook_command)"

if [[ "${branch}" == "main" ]]; then
  # The escape hatch, and it is one command wide.
  #
  # A session created from a source lands on the default branch, and denying
  # everything here also denied the only command that leaves it. Measured
  # 02-09-2026: a session fired with a source was paralysed in its shell from
  # its first turn — it could not run `git checkout -b`, and it could not run
  # `date` either. It escaped only because it happened to hold API tools that
  # do not go through a shell; a session without them has no first move at all.
  # A rail that traps the sessions it is meant to guide gets worked around
  # until it protects nothing (§8).
  #
  # So exactly one shape passes: a lone branch-creating checkout. One segment,
  # no chaining, no redirection, no substitution, and the new branch is not the
  # default one. Everything else here is still denied, Edit and Write included —
  # they carry no command field, so they can never match this.
  esc="$(printf '%s' "${command}" | tr -d "\"'")"
  if [[ "${command}" != *[\;\|\&\>\<\`\$\(]* ]] \
     && [[ "${esc}" =~ ^[[:space:]]*git[[:space:]]+(checkout|switch)[[:space:]]+(-b|-c)[[:space:]]+([^[:space:]]+)[[:space:]]*$ ]] \
     && [[ "${BASH_REMATCH[3]}" != "main" ]]; then
    exit 0
  fi
  echo "BLOCKED by guard-main.sh: main is the template, not a workspace. Create an agent branch first — 'git checkout -b <name>' is the one command allowed from here — and template changes go through an approved pull request." >&2
  exit 2
fi

# This repository's own tree, for the -C rule. Empty outside a checkout, which
# makes every -C read as ours and the rail err closed.
toplevel="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"

reason="$(executable_text "${command}" | python3 -c '
import re, shlex, sys

BRANCH = "main"
TOPLEVEL = sys.argv[1]

# The seven subcommands that can move or reach a branch. Everything else git
# does — commit, log, diff, add, merge-base — takes no operand this rail cares
# about, so its words are never read as refs.
REACHING = {"push", "checkout", "switch", "branch", "worktree",
            "update-ref", "symbolic-ref"}

# Global options that consume the next word, so the subcommand is not mistaken
# for the value of one.
GLOBAL_VALUE = {"-C", "-c", "--git-dir", "--work-tree", "--namespace",
                "--exec-path", "--super-prefix"}
# Words a segment can open with that are not the program this rail judges: a
# privilege wrapper, an assignment, or an interpreter reading its script from
# somewhere else. A body fed to one of these arrives as words of its own, so
# stepping past the interpreter is what lets the rail read it.
PREFIX = {"sudo", "env", "command", "exec", "nohup", "time",
          "sh", "bash", "zsh", "ksh", "dash", "python", "python3",
          "node", "perl", "ruby", "eval", "xargs", "source"}
REDIRECT = {">", ">>", "<", "<<", "2>", "&>", ">|"}
ASSIGN = re.compile(r"[A-Za-z_][A-Za-z0-9_]*=")

def is_operator(tok):
    return tok != "" and all(c in ";|&\n" for c in tok)

def segments(text):
    """Tokenize once, then cut on the shell operators. Quoting survives, so a
    message holding a semicolon stays one word. The newline is an operator here
    rather than whitespace, because it separates commands."""
    lexer = shlex.shlex(text, posix=True, punctuation_chars="();<>|&\n")
    lexer.whitespace = " \t\r"
    lexer.whitespace_split = True
    out, cur = [], []
    for tok in lexer:              # raises ValueError on an unbalanced quote
        if is_operator(tok):
            out.append(cur); cur = []
        else:
            cur.append(tok)
    out.append(cur)
    return out

def ends_in_branch(word):
    """A refspec whose destination is the protected branch: main, +main,
    HEAD:main, refs/heads/main. Not maintenance, and not main..HEAD."""
    return word == BRANCH or bool(re.fullmatch(r".*[:+/]" + BRANCH, word))

SHELLS = {"sh", "bash", "zsh", "ksh", "dash", "busybox"}
DASH_C = re.compile(r"-[A-Za-z]*c")

def verdict(tokens, depth=0):
    # Drop redirections and their targets; they are not arguments to git.
    words, skip = [], False
    for tok in tokens:
        if skip:
            skip = False
            continue
        if tok in REDIRECT:
            skip = True
            continue
        words.append(tok)

    i = 0
    while i < len(words) and ASSIGN.match(words[i]):
        i += 1

    # A shell asked to run a string, or eval given one, holds a command inside
    # a word. That is the one place a multi-word token is not data, and it is
    # decided by position like everything else here. A message argument is not
    # this, which is why it is read once and never again.
    if depth < 3 and i < len(words):
        prog = words[i].split("/")[-1]
        if prog in SHELLS:
            for j in range(i + 1, len(words) - 1):
                if DASH_C.fullmatch(words[j]):
                    r = analyse(words[j + 1], depth + 1)
                    if r:
                        return r
                    break
        elif prog == "eval":
            for w in words[i + 1:]:
                if not w.startswith("-"):
                    r = analyse(w, depth + 1)
                    if r:
                        return r

    while i < len(words) and (words[i].split("/")[-1] in PREFIX
                              or ASSIGN.match(words[i])):
        i += 1
    if i >= len(words) or words[i].split("/")[-1] != "git":
        return ""
    i += 1

    # Global options, and the -C that names another repository.
    outside = False
    while i < len(words) and words[i].startswith("-"):
        opt = words[i]
        name = opt.split("=", 1)[0]
        if name == "-C" and "=" not in opt:
            target = words[i + 1] if i + 1 < len(words) else ""
            if target.startswith("/") and (not TOPLEVEL or not target.startswith(TOPLEVEL)):
                outside = True
        if name in GLOBAL_VALUE and "=" not in opt:
            i += 2
        else:
            i += 1
    if outside:
        return ""
    if i >= len(words):
        return ""

    sub = words[i]
    if sub not in REACHING:
        return ""

    rest = words[i + 1:]
    flags = [w for w in rest if w.startswith("-")]
    operands = [w for w in rest if not w.startswith("-")]

    if sub == "push":
        if any(f in ("--mirror", "--all") for f in flags):
            return "pushes all refs (main included)"
        if any(ends_in_branch(o) for o in operands):
            return "pushes to main"
    elif sub in ("checkout", "switch"):
        if BRANCH in operands:
            return "checks out main"
    elif sub == "branch":
        moving = any(re.fullmatch(r"-[A-Za-z]*[fdDmMC][A-Za-z]*", f) for f in flags)
        if moving and BRANCH in operands:
            return "force-moves, renames, or deletes main"
    elif sub == "worktree":
        if BRANCH in operands:
            return "manipulates main via worktree or ref plumbing"
    elif sub in ("update-ref", "symbolic-ref"):
        if any(o.endswith("refs/heads/" + BRANCH) or o == BRANCH for o in operands):
            return "manipulates main via worktree or ref plumbing"
    return ""

def coarse(text):
    """The fallback, for text no tokenizer can read. It matches the flat string,
    which is what every version before 1.77.0 did everywhere."""
    flat = re.sub(r"[\"\x27]", "", text)
    for seg in re.split(r"&&|\|\||[;|&\n]", flat):
        if not re.search(r"(^|[^\w])git([\s]|$)", seg):
            continue
        has_push = re.search(r"(^|\s)push(\s|$)", seg)
        if has_push and re.search(r"(^|[\s:+/])" + BRANCH + r"(\s|$)", seg):
            return "pushes to main"
        if has_push and re.search(r"(^|\s)--(mirror|all)(\s|$)", seg):
            return "pushes all refs (main included)"
        if re.search(r"(checkout|switch)(\s+-\S+)*\s+" + BRANCH + r"(\s|$)", seg):
            return "checks out main"
        if re.search(r"branch(\s+-\S+)*\s+-[A-Za-z]*[fdDmMC][A-Za-z]*\s+" + BRANCH + r"(\s|$)", seg):
            return "force-moves, renames, or deletes main"
        if re.search(r"worktree[^|;&]*\s" + BRANCH + r"(\s|$)", seg) or \
           re.search(r"(update-ref|symbolic-ref)[^|;&]*refs/heads/" + BRANCH + r"(\s|$)", seg):
            return "manipulates main via worktree or ref plumbing"
    return ""

def analyse(text, depth=0):
    try:
        parts = segments(text)
    except ValueError:
        return coarse(text)
    for tokens in parts:
        r = verdict(tokens, depth)
        if r:
            return r
    return ""

print(analyse(sys.stdin.read()))
' "${toplevel}" 2>/dev/null)" || reason=""

if [[ -n "${reason}" ]]; then
  echo "BLOCKED by guard-main.sh: that command ${reason}. Template changes go through an approved pull request." >&2
  exit 2
fi

exit 0
