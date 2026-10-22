#!/usr/bin/env bash
# Keep XWayland's primary on the gaming output (DP-1).
# Xwayland / mango can reset this to the portrait DP-2; WoW then picks
# Monitor 0 as 1440x2560. Re-assert periodically.
set -u
export DISPLAY="${DISPLAY:-:0}"

lock_file="${XDG_RUNTIME_DIR:-/tmp}/mango-xwayland-primary.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

for _ in $(seq 1 30); do
  if xrandr --query 2>/dev/null | grep -q 'DP-1 connected'; then
    break
  fi
  sleep 1
done

while true; do
  if xrandr --query 2>/dev/null | grep -q 'DP-1 connected' \
    && ! xrandr --query 2>/dev/null | grep -q 'DP-1 connected primary'; then
    xrandr --output DP-1 --primary >/dev/null 2>&1 || true
  fi
  sleep 5
done
