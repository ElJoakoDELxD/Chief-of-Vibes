#!/usr/bin/env bash
#
# Reports three ways the agent's memory goes out of sync. The first two returned
# after the 5S run of 03-08-2026 because nothing was watching for them.
#
#   1. The backlog grows past the point where it can be acted on. That run found
#      the same measurement written three times in a file that had gone from 586
#      to 2904 words in a day. Size is the mechanical proxy: nothing here judges
#      the content.
#   2. A handoff goes stale. SYSTEM.md section 5 already calls an old handoff a
#      second memory drifting out of sync. A handoff whose `updated:` date is
#      older than the last change to SYSTEM.md describes a session that ran under
#      rules no longer in force.
#   3. A file under memory/projects/ is outside the shape section 5 fixes: a
#      topic folder, a thread folder inside it, and the topic's brief.md as the
#      only file the topic level holds. A loose file there belongs to no thread,
#      so the next session cannot tell what work it came from.
#
# The third cannot be a rail. memory/ lives on the agent branch and never passes
# through a pull request (section 6), so there is no gate to block at.
#
# Rung 3: it reports and never blocks, so it always exits 0. Silence means both
# checks passed. It prints nothing at all outside a copy, because the canon has
# no memory/ to measure.
#
# Usage:  bash tools/hygiene.sh [backlog-word-threshold]
#
# The default threshold is 2000 words, chosen from the one measurement available
# rather than from taste: the 03-08 run found duplication at 2904, and the file
# was workable at 586. A threshold under the point where duplication was found
# fires before the same defect returns.

set -uo pipefail

threshold="${1:-2000}"

[[ -d memory ]] || exit 0

if [[ -f memory/backlog.md ]]; then
  words="$(wc -w < memory/backlog.md | tr -d '[:space:]')"
  if (( words > threshold )); then
    echo "backlog.md is ${words} words, over ${threshold}. Run the 5S over memory before it holds the same thing twice."
  fi
fi

# A folder memory/ was never meant to hold is invisible to the check below,
# because that one only ever walks inside memory/projects/. On 13-08-2026 a
# sibling called memory/thinking/ had existed for nine days holding one note,
# and that note already said the effort was going to the system instead of the
# goal. Nobody read it because nothing looked there. The names section 5 lists
# are few and fixed, so naming an intruder is mechanical, not a judgment.
if [[ -d memory ]]; then
  while IFS= read -r dir; do
    name="${dir#memory/}"
    case "${name}" in
      projects|journal|handoff) continue ;;
    esac
    echo "memory/${name}/ is not a folder SYSTEM.md 5 names. Its contents are invisible to every check that walks memory/projects/. Move it or fold it in."
  done < <(find memory -mindepth 1 -maxdepth 1 -type d | sort)
fi

if [[ -d memory/projects ]]; then
  while IFS= read -r file; do
    rel="${file#memory/projects/}"
    depth="$(awk -F/ '{print NF}' <<<"${rel}")"
    if (( depth == 1 )); then
      echo "${file} sits loose in memory/projects/. Every file belongs to a topic and a thread inside it (SYSTEM.md 5)."
    elif (( depth == 2 )) && [[ "${rel##*/}" != "brief.md" ]]; then
      echo "${file} sits at the topic level, where only brief.md belongs. Move it into its thread's folder (SYSTEM.md 5)."
    fi
  done < <(find memory/projects -type f | sort)
fi

# The date of the last commit that touched SYSTEM.md is the age of the rules in
# force. Without git, or without that file, the check has no reference and says
# nothing rather than guessing.
spec_date="$(git log -1 --format=%ad --date=short -- SYSTEM.md 2>/dev/null)" || spec_date=""
[[ -n "${spec_date}" ]] || exit 0

shopt -s nullglob
for note in memory/handoff/*.md; do
  python3 - "$note" "$spec_date" <<'PY'
import re, sys
path, spec = sys.argv[1], sys.argv[2]
head = open(path, encoding="utf-8").read(2000)
m = re.search(r"^updated:\s*(\d{2})-(\d{2})-(\d{4})", head, re.M)
if not m:
    print(f"{path} carries no `updated:` date, so nothing can tell whether it is current.")
    raise SystemExit(0)
d, mo, y = m.groups()
if f"{y}-{mo}-{d}" < spec:
    print(f"{path} was updated {d}-{mo}-{y}, before the specification last changed on {spec}. Read it and delete it, or bring it current.")
PY
done

exit 0
