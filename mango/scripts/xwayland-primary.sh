#!/usr/bin/env bash
# Point XWayland's primary at the gaming output. EQ reads the primary / origin
# size; without this it opens as DP-2's 1440x2560 inside a 2560x1440 window.
set -euo pipefail
export DISPLAY="${DISPLAY:-:0}"
for _ in $(seq 1 30); do
  if xrandr --output DP-1 --primary >/dev/null 2>&1; then
    exit 0
  fi
  sleep 1
done
exit 1
