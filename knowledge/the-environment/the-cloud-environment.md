---
topic: What a cloud session actually is, and which parts of it the agent can change
updated: 13-08-2026
verified: read from the official documentation on 13-08-2026, and every reach claim
  measured in-session with `bash tools/environment.sh`. The durable-install claim is
  documentation, not yet run: no setup script has been used from here.
---

## When this applies

Any session that hits a wall it did not build: a domain that will not resolve, a tool that
is missing, a variable that is not set, an install that will not survive. Read this before
filing the wall under **Principal**, because three times in two days this repository filed
one that did not exist.

## The shape of the thing

A cloud session runs inside an **environment**: a saved configuration that outlives the
session and applies wherever a session starts. It carries three settings and one property.

| | |
|---|---|
| **Network access** | one of four levels, below |
| **Environment variables** | `.env` format, copied once at session start |
| **Setup script** | Bash, as root, before the session starts |
| **A cached filesystem** | the snapshot the setup script leaves behind |

The agent owns none of them, and that is the point: each one is a request the Principal can
grant in a minute, not a law.

## Network access, and why one blocked host proves nothing

Four levels: **None**, **Trusted**, **Full**, **Custom**.

- **Trusted** is the default and allows package registries, GitHub, and cloud SDKs.
- **Custom** takes a list of **domains, not URLs**, one per line. A leading `*.` covers
  every subdomain. A checkbox keeps the package-manager defaults alongside the list.
- **GitHub traffic rides its own proxy** and ignores this setting entirely. So does MCP
  connector traffic. A session with no network at all can still reach GitHub.

**The failure this closes.** A domain and its API often live on different hosts, and an
allowlist admits them separately. Measured here on 13-08:

| asked for | answered |
|---|---|
| `old.reddit.com`, `api.reddit.com` | blocked at CONNECT |
| `www.reddit.com` | **200**, and it serves RSS for listings and whole threads |
| the five YouTube hosts | blocked at CONNECT |
| `www.googleapis.com` | **reached**, and returned Google's own 403 asking for a key |

So *"the platform is unreachable"* was false twice, and the second time the data was one
credential away with no policy change at all.

**The mechanical test, and it removes the judgment.** The proxy records its own denials:

    curl -sS "$HTTPS_PROXY/__agentproxy/status"

A host rejected by policy appears in `recentRelayFailures` as `connect_rejected`. A host
that reached the destination and was refused there **does not appear**. That single
difference separates *blocked* from *needs a credential*, and no reading of the error text
is required.

`bash tools/environment.sh <host>...` runs the whole survey and classifies the level.

**A block is a control, never a wall to route around** (SYSTEM.md §3). The proxy's own
README says the same: *"Do not retry or route around it — report the blocked host."* A CI
job that fetches what the policy refuses is a workaround, not a relay, and §3's relay clause
does not cover it.

## Variables

`.env` format, one `KEY=value` per line. Quote a value that spans lines or contains `#`.

Two properties that matter more than the format:

- **Copied once, at session start.** A running session never re-reads them, so a change
  reaches the *next* session. Asking for a variable is never a fix for the session asking.
- **Readable by anyone who uses the environment, and there is no secrets store.** So a
  credential never goes there. A session that needs one says so and takes it another way.

## The durable layer, which the specification used to deny

**The setup script is the install that survives.** It runs as root on Ubuntu before Claude
Code starts, and afterwards the filesystem it produced is **snapshotted and reused** by
later sessions. Packages, toolchains, and pulled images carry over. Anything merely
*running* does not: a database the script started is gone, so that belongs in a
`SessionStart` hook instead.

Three constraints to write around:

- **Exit zero**, or the session fails to start. Append `|| true` to anything optional.
- **Finish inside about five minutes**, or the cache cannot build.
- **Installs need the registries**, so they fail at network level **None**.

It re-runs when the script changes, when the allowed hosts change, or after roughly seven
days.

**What this corrects.** §4 said a hosted machine keeps nothing outside the repository, so
the agent refused every install as un-durable. That is right for what the *session* writes
by hand and wrong for the environment: there is a durable layer, it belongs to the
Principal, and the answer is a request carrying the exact script lines.

## What is already installed, so nothing gets asked for twice

Run `check-tools` on the session VM. It prints versions for Python, Node 20/21/22, Ruby,
PHP, Java, Go, Rust, C/C++, Docker, PostgreSQL, Redis, and the usual utilities. Measured
here: Python 3.11.15, pytest 9.0.2, uv, poetry, ruff, black, mypy.

Chromium and Playwright are present at `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers`. Use
`playwright-core` and point `executablePath` at `/opt/pw-browsers/chromium`; installing
`playwright` pulls a browser the image already has.

## How to ask, so the request is answerable

A block ends as a named request, never as a backlog item shaped like a law. Give the
Principal four things:

1. **Which field.** Network access, Variables, or Setup script.
2. **The exact lines to paste.** Domains one per line; `KEY=value`; or the script.
3. **What each one buys**, in one clause.
4. **What stays blocked if they say no**, so the decision is informed.

Group them by what they unlock rather than by hostname. On 13-08 that turned a wall into
four lines, and the Principal pasted them in under a minute.

## Traps

- **A policy change can be silent and can revert.** `steamcommunity.com` answered 200 at
  22:47 and was `connect_rejected` at 23:01 the same night. **Reach is measured per use, not
  remembered from earlier in the session.**
- **The session does not re-read variables**, so a variable added mid-session changes
  nothing until the next one.
- **`check-tools` is a shell command on the VM**, not a slash command.
- **Do not run `playwright install`.** The browsers are already there.
