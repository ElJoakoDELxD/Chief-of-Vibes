#!/usr/bin/env bash
# Spike S8: record what Claude Code hands a hook about the model and the effort.
python3 -c '
import json, sys, datetime
d = json.load(sys.stdin)
row = {"t": datetime.datetime.utcnow().strftime("%H:%M:%S"), "event": d.get("hook_event_name"),
       "model": d.get("model"), "from_model": d.get("from_model"), "to_model": d.get("to_model"),
       "effort": d.get("effort"), "tool": d.get("tool_name")}
open("/tmp/cov-s8-hooks.log", "a").write(json.dumps(row) + "\n")
' 2>/dev/null
exit 0
