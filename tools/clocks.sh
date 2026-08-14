#!/usr/bin/env bash
#
# Reports when this platform's clock is not yet in CLOCKS.md, the reach record
# for time (SYSTEM.md section 8). LANGUAGES.md is the same idea one step lower:
# there an agent has to notice it rendered its roster in a new language. Here
# the question is mechanically decidable, so a sensor asks it instead of a rule.
#
# A row is a platform and the origin that answered on it, and it is only written
# after a time actually came out. `tools/now.sh --origin` is the measurement, so
# the record can never claim reach nobody had.
#
# What a row deliberately does NOT carry: the configured timezone, the machine,
# the user, the repository. A zone is a location (section 7). The platform name
# is truncated at its first dash, because `uname -s` on Git Bash carries the
# Windows build number and a build number is closer to a fingerprint than to a
# platform.
#
# Rung 3: it reports and never blocks, so it always exits 0. Silence means this
# platform and origin are already recorded, which is the normal case forever
# after the first session on a machine.
#
# Usage:  bash tools/clocks.sh            # report only when unrecorded
#         bash tools/clocks.sh --line     # print this platform's row, for adding

set -uo pipefail

[[ -f CLOCKS.md ]] || exit 0

platform="$(uname -s 2>/dev/null | cut -d- -f1)"
[[ -n "${platform}" ]] || exit 0

origin="$(bash tools/now.sh --origin 2>/dev/null)" || origin=""
if [[ -z "${origin}" ]]; then
  # No origin answered, so there is nothing to record. now.sh already said why,
  # loudly, and repeating it here would be a second voice for one failure.
  exit 0
fi

row="| \`${platform}\` | \`${origin}\` |"

if [[ "${1-}" == "--line" ]]; then
  printf '%s <the day, as YYYY-MM-DD> |\n' "${row}"
  exit 0
fi

# The match is on the pair, not on the platform. A platform already recorded
# through one origin still teaches something when a second one answers there.
if ! grep -qF "${row}" CLOCKS.md; then
  printf 'CLOCKS.md has no row for `%s` answered by `%s`. This platform is new to the record (SYSTEM.md 8).\n' \
    "${platform}" "${origin}"
  printf 'Add it by pull request into the canon, one line, the day only: bash tools/clocks.sh --line\n'
fi

exit 0
