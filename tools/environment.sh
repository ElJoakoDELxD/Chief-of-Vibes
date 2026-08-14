#!/usr/bin/env bash
#
# Reports the session's environment: what it can reach, what it keeps, and what
# only the Principal can change.
#
# It exists because the agent was guessing. A session measured two hosts of a
# domain, filed "cannot reach it" under the Principal, and left the item there
# for eight days while a third host answered 200 the whole time. The frame was
# never the platform. It was the two hosts somebody happened to try.
#
# Every line here is measured in this run. Nothing is inferred from the name of
# the runtime, and a probe that cannot answer says so rather than guessing.
#
# Usage:  bash tools/environment.sh [extra.example.com ...]
#
# Extra hosts are probed alongside the fixed set, so a session can ask about the
# domain it actually needs instead of reading a generic report.

set -uo pipefail

# One probe. Prints reach/blocked/unknown for a host, never an opinion.
probe() {
  local host="$1" code
  code=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 12 \
         -A 'Mozilla/5.0' "https://${host}/" 2>/dev/null)
  case "${code}" in
    000) echo "blocked" ;;
    "")  echo "unknown" ;;
    *)   echo "reach ${code}" ;;
  esac
}

echo "Environment, measured this run."
echo

# --- 1. Is there an egress proxy, and what does it say about itself? ---------
if [[ -n "${HTTPS_PROXY:-}" ]]; then
  echo "  Egress proxy: ${HTTPS_PROXY}"
  status=$(curl -sS --max-time 10 "${HTTPS_PROXY}/__agentproxy/status" 2>/dev/null)
  if [[ -n "${status}" ]]; then
    echo "  Proxy status: answered. Recent denials name the host they rejected."
  else
    echo "  Proxy status: UNREADABLE. The proxy is set and did not answer."
  fi
else
  echo "  Egress proxy: none set. This session is not behind one."
fi
echo

# --- 2. Reach, measured -----------------------------------------------------
# Three fixed probes classify the level without asking anyone:
#   an arbitrary domain nobody allowlists on purpose -> Full
#   GitHub, which rides its own proxy               -> present at every level
#   a package registry                              -> the default list
echo "  Reach:"
arbitrary=$(probe example.com)
printf '    %-28s %s\n' "example.com" "${arbitrary}"
for h in github.com registry.npmjs.org; do
  printf '    %-28s %s\n' "${h}" "$(probe "${h}")"
done
for h in "$@"; do
  printf '    %-28s %s\n' "${h}" "$(probe "${h}")"
done
echo

case "${arbitrary}" in
  reach*) echo "  Level: an arbitrary domain answered, so this is Full access." ;;
  *)      echo "  Level: an arbitrary domain is blocked, so an allowlist is in force." ;;
esac
echo "  A blocked host is a control, never a wall to route around (SYSTEM.md 3)."
echo "  It is also a setting the Principal can change. Ask, naming the domains."
echo

# --- 3. What this filesystem keeps ------------------------------------------
echo "  Durability:"
if [[ -e "${HOME}/.chief-of-vibes-durable" || "${COV_DURABLE_HOME:-}" == "1" ]]; then
  echo "    DECLARED. This machine says it persists, so installs are allowed (4)."
else
  echo "    Undeclared, so the session filesystem is treated as disposable (4)."
  echo "    A managed cloud environment can still hold an install: its setup"
  echo "    script runs before the session and its filesystem is snapshotted."
  echo "    That layer belongs to the Principal, so the agent asks for it and"
  echo "    never writes an installer that pretends to be one."
fi
echo

# --- 4. What the Principal owns ---------------------------------------------
cat <<'ASK'
  Only the Principal can change these, so a need becomes a request, not a block:
    Network access  - None, Trusted, Full, or Custom with a domain list.
                      Domains, not URLs. A leading *. covers subdomains.
    Variables       - .env format, copied once at session start. Readable by
                      anyone using the environment, so never a credential.
                      COV_TZ=<IANA zone> keeps the clock working on branches
                      that carry no memory/, which is every template branch.
    Setup script    - Bash, as root, before the session. Must exit zero.
                      Its filesystem is cached and reused.
ASK
