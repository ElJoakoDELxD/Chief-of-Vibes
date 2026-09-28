#!/bin/bash
# Setup script for a claude.ai/code environment: puts the sandbox tools that
# this branch carries (tools/sandbox/linux-x86_64) on the system PATH before
# Claude Code launches. Paste it in the environment's Setup script field.
# BRANCH names the branch that carries the tools.
BRANCH=spike/s6-sandbox
R="https://raw.githubusercontent.com/ElJoakoDELxD/Chief-of-Vibes/${BRANCH}/tools/sandbox/linux-x86_64"
d=/usr/local/lib/cov-sandbox
mkdir -p "$d/lib"
for f in bwrap socat.bin socat lib/libwrap.so.0; do curl -fsSL "$R/$f" -o "$d/$f" || echo "setup: could not fetch $f" >&2; done
chmod +x "$d/bwrap" "$d/socat.bin" "$d/socat" 2>/dev/null
ln -sf "$d/bwrap" /usr/local/bin/bwrap
ln -sf "$d/socat" /usr/local/bin/socat
exit 0
