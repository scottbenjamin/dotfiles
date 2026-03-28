#!/usr/bin/env python3
import json
import subprocess
import sys

TARGET = sys.argv[1] if len(sys.argv) > 1 else "1"


def get_workspaces():
    try:
        out = subprocess.check_output(["niri", "msg", "workspaces"], text=True)
    except Exception:
        return []

    result = []
    current_output = None
    for raw in out.splitlines():
        line = raw.rstrip()
        if line.startswith('Output "') and line.endswith('":'):
            current_output = line[len('Output "'):-2]
            continue

        s = line.strip()
        if not s:
            continue

        active = s.startswith('*')
        if active:
            s = s[1:].strip()

        parts = s.split(maxsplit=1)
        if not parts:
            continue

        name = None
        if len(parts) > 1 and parts[1].startswith('"') and parts[1].endswith('"'):
            name = parts[1][1:-1]

        result.append({"output": current_output, "active": active, "name": name})

    return result


workspaces = get_workspaces()
active = any(ws.get("name") == TARGET and ws.get("active") for ws in workspaces)
print(json.dumps({
    "text": TARGET,
    "class": f"{'active' if active else 'inactive'} ws-{TARGET}",
    "tooltip": f"Workspace {TARGET}"
}))
