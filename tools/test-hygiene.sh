#!/usr/bin/env bash
#
# Bench for tools/hygiene.sh. It pins both directions: what must be reported,
# and what must be left alone. A sensor that fires on a healthy tree teaches the
# agent to stop reading it (SYSTEM.md section 8).
#
# The fixtures are whole repositories, because both checks read the tree: one
# counts a file, the other compares a date against the last commit that touched
# SYSTEM.md. A fixture without git cannot see the second check at all.
#
# Usage:  bash tools/test-hygiene.sh

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

fail=0
check() {
  local name="$1" expected="$2" got="$3"
  if [[ "${got}" == *"${expected}"* ]]; then
    echo "ok   ${name}"
  else
    echo "FAIL ${name}"
    echo "     expected to contain: ${expected}"
    echo "     got: ${got:-<empty>}"
    fail=1
  fi
}
check_absent() {
  local name="$1" forbidden="$2" got="$3"
  if [[ "${got}" == *"${forbidden}"* ]]; then
    echo "FAIL ${name}"
    echo "     should not contain: ${forbidden}"
    echo "     got: ${got}"
    fail=1
  else
    echo "ok   ${name}"
  fi
}

# A repository whose SYSTEM.md was last touched on a known date.
build() {
  local dir="$1" spec_date="$2"
  rm -rf "${dir}"; mkdir -p "${dir}/memory/handoff"
  cd "${dir}"
  git init -q .
  git config user.email bench@example.com
  git config user.name bench
  printf '**Version 9.9.9.** spec\n' > SYSTEM.md
  git add SYSTEM.md
  GIT_AUTHOR_DATE="${spec_date}T12:00:00" GIT_COMMITTER_DATE="${spec_date}T12:00:00" \
    git commit -q -m spec
  cd - >/dev/null
}

run() { ( cd "$1" && bash "${here}/hygiene.sh" "${2:-2000}" ); }

# --- the backlog over and under the threshold --------------------------------
build "${tmp}/big" 2026-08-01
yes word | head -2500 | tr '
' ' ' > "${tmp}/big/memory/backlog.md"
out="$(run "${tmp}/big")"
check "a fat backlog is reported" "over 2000" "${out}"

build "${tmp}/small" 2026-08-01
yes word | head -100 | tr '
' ' ' > "${tmp}/small/memory/backlog.md"
out="$(run "${tmp}/small")"
check_absent "a small backlog is left alone" "backlog.md is" "${out}"

# The threshold is an argument, so a repository can raise it without editing the
# tool. Pinned because a hard-coded number would make that a code change.
out="$(run "${tmp}/big" 9999)"
check_absent "the threshold is honoured" "backlog.md is" "${out}"

# --- a handoff older and newer than the specification ------------------------
build "${tmp}/stale" 2026-08-05
printf -- '---\nupdated: 01-08-2026 10:00 -04\n---\nbody\n' > "${tmp}/stale/memory/handoff/old-handoff.md"
out="$(run "${tmp}/stale")"
check "a handoff older than the spec is reported" "before the specification last changed" "${out}"

build "${tmp}/fresh" 2026-08-05
printf -- '---\nupdated: 09-08-2026 10:00 -04\n---\nbody\n' > "${tmp}/fresh/memory/handoff/new-handoff.md"
out="$(run "${tmp}/fresh")"
check_absent "a current handoff is left alone" "before the specification" "${out}"

# A handoff with no date cannot be judged, and silence would read as healthy.
build "${tmp}/undated" 2026-08-05
printf -- '---\nthread: something\n---\nbody\n' > "${tmp}/undated/memory/handoff/no-date-handoff.md"
out="$(run "${tmp}/undated")"
check "a handoff with no date is reported" "no \`updated:\` date" "${out}"

# --- the shape of memory/projects/ --------------------------------------------
# The bench pins the shape in both directions, because this is the check most
# able to lie: a topic's brief.md and a loose note sit at the same depth, and a
# rule that cannot tell them apart would fire on every project in the tree.
build "${tmp}/shape" 2026-08-05
mkdir -p "${tmp}/shape/memory/projects/onboarding ramp/reading before answering"
printf 'brief\n' > "${tmp}/shape/memory/projects/onboarding ramp/brief.md"
printf 'note\n'  > "${tmp}/shape/memory/projects/onboarding ramp/reading before answering/what-i-read.md"
printf 'note\n'  > "${tmp}/shape/memory/projects/onboarding ramp/loose-note.md"
printf 'note\n'  > "${tmp}/shape/memory/projects/orphan.md"
out="$(run "${tmp}/shape")"
check "a note at the topic level is reported" "loose-note.md sits at the topic level" "${out}"
check "a note with no topic is reported" "orphan.md sits loose" "${out}"
check_absent "a brief at the topic level is left alone" "brief.md sits" "${out}"
check_absent "a note inside a thread is left alone" "what-i-read.md" "${out}"

# --- the canon, which has no memory/ ------------------------------------------
build "${tmp}/canon" 2026-08-05
rm -rf "${tmp}/canon/memory"
out="$(run "${tmp}/canon")"
check_absent "the canon says nothing" "backlog" "${out}"

# --- a sensor never blocks ----------------------------------------------------
( cd "${tmp}/big" && bash "${here}/hygiene.sh" >/dev/null 2>&1 )
check "reporting still exits 0" "0" "$?"

# --- a sibling folder section 5 never named --------------------------------
# The projects walk cannot see one, and on 13-08-2026 that cost nine days: a
# note predicting the session's own failure sat in memory/thinking/ unread.

sib="${tmp}/sibling"
rm -rf "${sib}"; mkdir -p "${sib}/memory/projects/tema/hilo" "${sib}/memory/journal" "${sib}/memory/thinking"
: > "${sib}/memory/projects/tema/hilo/nota.md"
: > "${sib}/memory/thinking/la-pregunta.md"
out="$(cd "${sib}" && bash "${here}/hygiene.sh" 2>&1)"
check "a folder section 5 does not name is reported" "memory/thinking/" "${out}"
check "the report says why it matters" "invisible" "${out}"

# The three folders section 5 does name stay silent, or the sensor becomes noise.
quiet="${tmp}/quiet"
rm -rf "${quiet}"; mkdir -p "${quiet}/memory/projects/tema/hilo" "${quiet}/memory/journal" "${quiet}/memory/handoff"
: > "${quiet}/memory/projects/tema/hilo/nota.md"
out="$(cd "${quiet}" && bash "${here}/hygiene.sh" 2>&1)"
check_absent "projects/ is never called an intruder" "memory/projects/ is not" "${out}"
check_absent "journal/ is never called an intruder" "memory/journal/ is not" "${out}"
check_absent "handoff/ is never called an intruder" "memory/handoff/ is not" "${out}"

# --- knowledge/, which the canon carries too --------------------------------
# Both rules are mechanical, and both run where there is no memory/ at all,
# because that is what the canon looks like and its entries reach every copy.

kn="${tmp}/knowledge-canon"
rm -rf "${kn}"; mkdir -p "${kn}/knowledge/tema"
printf -- '---\ntopic: bien\nverified: se corrio el banco\n---\n' > "${kn}/knowledge/tema/bien.md"
printf -- '---\ntopic: suelta\n---\n' > "${kn}/knowledge/suelta.md"
out="$(cd "${kn}" && bash "${here}/hygiene.sh" 2>&1)"
check "an entry loose at the top of knowledge/ is reported" "sits loose in knowledge/" "${out}"
check "an entry with no verified: is reported" "carries no" "${out}"
check_absent "a placed and verified entry is left alone" "tema/bien.md" "${out}"

# The canon has no memory/, and the sensor must not go home before checking.
[[ -n "${out}" ]] \
  && echo "ok   the knowledge checks run without memory/" \
  || { echo "FAIL the knowledge checks run without memory/"; fail=1; }

# --- the agent's own posts and functions are not intruders --------------------
# Section 5 names memory/posts/ and memory/functions/: a post this agent wrote and
# has not proposed into the catalogue yet. An intruder check that did not know
# them would report the vault's own shape.
build "${tmp}/ownposts" 2026-08-01
printf 'x\n' > "${tmp}/ownposts/memory/backlog.md"
mkdir -p "${tmp}/ownposts/memory/posts" "${tmp}/ownposts/memory/functions"
printf -- '---\npost: Reviewer\n---\n' > "${tmp}/ownposts/memory/posts/reviewer.md"
printf -- '---\nfunction: Read a diff\n---\n' > "${tmp}/ownposts/memory/functions/read.md"
out="$(run "${tmp}/ownposts")"
check_absent "memory/posts/ is not an intruder" "memory/posts/ is not a folder" "${out}"
check_absent "memory/functions/ is not an intruder" "memory/functions/ is not a folder" "${out}"

# --- quarantine is a waiting room, not a cupboard -----------------------------
# An item nobody has taken must stay visible while it waits. A signed receipt is
# what ends the wait, and only the recipient can sign it.
build "${tmp}/quar" 2026-08-01
printf 'x\n' > "${tmp}/quar/memory/backlog.md"
printf 'a correction\n' > "${tmp}/quar/memory/corrections.md"
mkdir -p "${tmp}/quar/memory/quarantine"
printf -- '---\nquarantined: 08-09-2026\nbelongs_to: somebody\ngoes_to: somewhere\nreceived:\n---\n' \
  > "${tmp}/quar/memory/quarantine/thing.md"
out="$(run "${tmp}/quar")"
check "an unreceipted item is reported" "quarantined and unreceipted" "${out}"
check_absent "and quarantine/ is not called an intruder" "memory/quarantine/ is not a folder" "${out}"

printf -- '---\nquarantined: 08-09-2026\nbelongs_to: somebody\ngoes_to: somewhere\nreceived: taken 09-09-2026\n---\n' \
  > "${tmp}/quar/memory/quarantine/thing.md"
out="$(run "${tmp}/quar")"
check_absent "a signed receipt ends the report" "quarantined and unreceipted" "${out}"

# --- corrections.md, named rather than created -------------------------------
# Section 5 refuses to create it in advance and is right. What the absence needs
# is for the path to be said out loud, because section 9 says to read the file
# and section 5 is the only place its path appears.
build "${tmp}/nocorr" 2026-08-01
printf 'x\n' > "${tmp}/nocorr/memory/backlog.md"
out="$(run "${tmp}/nocorr")"
check "an absent corrections.md is named" "memory/corrections.md does not exist yet" "${out}"

printf 'a correction\n' > "${tmp}/nocorr/memory/corrections.md"
out="$(run "${tmp}/nocorr")"
check_absent "a present corrections.md is silent" "corrections.md does not exist" "${out}"

# --- two branches, one agent -------------------------------------------------
# Measured on 07-09-2026: a session read a superseded vault for its whole length
# because each branch read correctly on its own. Only a check that looks across
# branches sees it, so the fixture needs a real remote and a real clone.
#
# The fixture's default branch is called trunk. Naming it after this repository's
# protected branch would make every line here read like a command reaching for
# it, and the guard hook is right to refuse a string it cannot tell apart.
origin="${tmp}/origin.git"
work="${tmp}/twovaults"
rm -rf "${origin}" "${work}"
git init -q --bare "${origin}"
git clone -q "${origin}" "${work}" 2>/dev/null
(
  cd "${work}"
  git config user.email bench@example.com
  git config user.name bench
  git switch -q -c trunk
  printf '**Version 9.9.9.** spec\n' > SYSTEM.md
  mkdir -p memory
  printf 'x\n' > memory/backlog.md
  printf 'a correction\n' > memory/corrections.md
  git add -A && git commit -q -m spec && git push -q -u origin trunk

  git switch -q -c agent-one
  printf -- '---\nagent: One\n---\n' > memory/state.md
  git add -A && git commit -q -m one && git push -q origin agent-one
  git fetch -q origin
) >/dev/null 2>&1

out="$(cd "${work}" && bash "${here}/hygiene.sh")"
check_absent "one vault is left alone" "More than one branch carries" "${out}"

(
  cd "${work}"
  git switch -q -c agent-two trunk
  printf -- '---\nagent: One\n---\n' > memory/state.md
  git add -A && git commit -q -m two && git push -q origin agent-two
  git fetch -q origin
) >/dev/null 2>&1

out="$(cd "${work}" && bash "${here}/hygiene.sh")"
check "two vaults are reported" "More than one branch carries memory/state.md" "${out}"
check "the report names both branches" "origin/agent-two" "${out}"

if (( fail )); then
  echo "tools/hygiene.sh: bench FAILED"
  exit 1
fi
echo "tools/hygiene.sh: bench passed"
