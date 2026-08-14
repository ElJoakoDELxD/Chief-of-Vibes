#!/usr/bin/env bash
#
# Bench for tools/environment.sh. It pins the two things the report must never
# get wrong: it must classify reach from what it measured, and it must say
# UNREADABLE rather than invent a reading.
#
# Every probe is faked with a curl stub on PATH, so the bench needs no network
# and gives the same answer on any machine. A bench that reaches the internet
# measures the internet, not the tool.
#
# Usage:  bash tools/test-environment.sh

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
  local name="$1" absent="$2" got="$3"
  if [[ "${got}" != *"${absent}"* ]]; then
    echo "ok   ${name}"
  else
    echo "FAIL ${name}"
    echo "     must not contain: ${absent}"
    fail=1
  fi
}

# A curl stub. Reads the mode from CURL_MODE and answers every probe the same
# way, except the proxy status endpoint, which has its own switch.
mkdir -p "${tmp}/bin"
cat > "${tmp}/bin/curl" <<'STUB'
#!/usr/bin/env bash
for a in "$@"; do
  case "$a" in
    *__agentproxy/status)
      [[ "${PROXY_ANSWERS:-1}" == "1" ]] && echo '{"enabled":true}'
      exit 0 ;;
  esac
done
case "${CURL_MODE:-blocked}" in
  full)    printf '200' ;;
  blocked) printf '000' ;;
  quiet)   printf '' ;;
esac
exit 0
STUB
chmod +x "${tmp}/bin/curl"
# The real session sets HTTPS_PROXY, and a bench that inherits it cannot test
# the case where no proxy exists. So every case starts clean and asks for one
# through PROXY_URL when it wants one.
run() {
  local -a e=(env -u HTTPS_PROXY "PATH=${tmp}/bin:${PATH}" "HOME=${tmp}/home")
  [[ -n "${PROXY_URL:-}" ]] && e+=("HTTPS_PROXY=${PROXY_URL}")
  "${e[@]}" bash "${here}/environment.sh" "$@" 2>&1
}
mkdir -p "${tmp}/home"

# 1. An arbitrary domain that answers means Full access.
out="$(CURL_MODE=full PROXY_URL=http://127.0.0.1:1 run)"
check "an arbitrary domain answering is reported as Full" "this is Full access" "${out}"

# 2. An arbitrary domain blocked means an allowlist, never Full.
out="$(CURL_MODE=blocked PROXY_URL=http://127.0.0.1:1 run)"
check "a blocked arbitrary domain names an allowlist" "an allowlist is in force" "${out}"
check_absent "a blocked arbitrary domain is never called Full" "is Full access" "${out}"

# 3. A blocked host is named a control, so no session tries to route around it.
check "a block is named a control, not a wall" "never a wall to route around" "${out}"

# 4. The proxy that does not answer says UNREADABLE instead of guessing.
out="$(CURL_MODE=blocked PROXY_ANSWERS=0 PROXY_URL=http://127.0.0.1:1 run)"
check "a silent proxy is UNREADABLE" "Proxy status: UNREADABLE" "${out}"

# 5. With no proxy set, the report says so rather than describing one.
out="$(CURL_MODE=full run)"
check "no proxy set is reported plainly" "none set" "${out}"

# 6. Undeclared durability names the setup script as the Principal's layer.
out="$(CURL_MODE=blocked PROXY_URL=http://127.0.0.1:1 run)"
check "undeclared durability names the cached setup script" "snapshotted" "${out}"
check_absent "undeclared durability never claims installs are allowed" "installs are allowed" "${out}"

# 7. A declared machine flips the durability line.
touch "${tmp}/home/.chief-of-vibes-durable"
out="$(CURL_MODE=blocked PROXY_URL=http://127.0.0.1:1 run)"
check "a declared machine reports DECLARED" "DECLARED" "${out}"
rm -f "${tmp}/home/.chief-of-vibes-durable"

# 8. COV_DURABLE_HOME declares the same thing without a file.
out="$(CURL_MODE=blocked COV_DURABLE_HOME=1 PROXY_URL=http://127.0.0.1:1 run)"
check "COV_DURABLE_HOME declares durability too" "DECLARED" "${out}"

# 9. Extra hosts are probed, so a session asks about the domain it needs.
out="$(CURL_MODE=blocked PROXY_URL=http://127.0.0.1:1 run pedido.example.org)"
check "an extra host appears in the report" "pedido.example.org" "${out}"

# 10. The three settings the Principal owns are always named.
check "the report names the network field" "Network access" "${out}"
check "the report names the variables field" "Variables" "${out}"
check "the report names the setup script" "Setup script" "${out}"

# 11. Variables are never proposed as a place for a credential.
check "variables carry their warning" "never a credential" "${out}"

echo
if [[ ${fail} -eq 0 ]]; then echo "all environment checks passed"; else echo "environment checks FAILED"; fi
exit ${fail}
