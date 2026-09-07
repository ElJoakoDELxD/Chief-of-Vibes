#!/usr/bin/env bash
#
# Compares the model that actually served this session against the models the
# Principal approved for the post it is exercising.
#
# The gate this replaces was named on 15-08-2026 and never written, so the
# identity file described a control for three weeks while nothing enforced it.
# On 06 and 07-09-2026 an unlisted model held the custodian post through seven
# releases into the blueprint and nothing noticed, because the thing that would
# have noticed was the file that did not exist.
#
# **What this tool cannot do, and says so rather than pretending.** No
# environment variable names the served model. The only source is the runtime's
# own report, which a shell script cannot call, so the served model arrives here
# as an argument the session obtained and passed. Judging is mechanical; getting
# the reading is not, and calling the whole thing a rail would be the fabricated
# reading section 3 forbids.
#
# So it fails closed. No argument is not "probably fine": it is a refusal to
# answer, exit 2, the same three-way shape tools/now.sh uses for a clock it
# cannot read.
#
# The approved list is identity: this Principal, these models, this repository.
# It lives with the holder, in memory/posts/<post>.md, and never ships. What
# ships is this tool and the rule that a post may require one (section 5).
#
# Usage:  bash tools/models.sh <served-model> [post]
#         bash tools/models.sh claude-opus-5 custodian
#
# Exit:   0  approved
#         1  served something the post does not approve — say so and stop
#         2  no reading, or no list to compare against

set -uo pipefail

served="${1:-}"
post="${2:-custodian}"
file="memory/posts/${post}.md"

if [[ -z "${served}" ]]; then
  echo "models.sh: no served model given, so nothing was checked." >&2
  echo "           Ask the runtime which model served this session and pass it." >&2
  exit 2
fi

if [[ ! -f "${file}" ]]; then
  echo "models.sh: no ${file}, so the post records no approved models." >&2
  echo "           A post with no list approves nothing; say so rather than proceeding." >&2
  exit 2
fi

approved="$(sed -n 's/^models:[[:space:]]*//p' "${file}" | head -n1)"
if [[ -z "${approved}" ]]; then
  echo "models.sh: ${file} carries no \`models:\` line, so the post approves nothing yet." >&2
  echo "           The Principal names them there; until then this is unverified." >&2
  exit 2
fi

# Commas or spaces, either way. A list a person maintains should not fail on a
# separator.
for m in ${approved//,/ }; do
  if [[ "${served}" == "${m}" ]]; then
    echo "Model: ${served} is approved for the ${post} post."
    exit 0
  fi
done

echo "STOP: ${served} is not approved for the ${post} post." >&2
echo "      Approved: ${approved}" >&2
echo "      A run that already happened is not something a Principal can decline afterwards," >&2
echo "      so say this before doing anything else, and do not continue on this post." >&2
exit 1
