#!/usr/bin/env bash
# Reapply mango monitorrules when outputs drifted after remount/suspend.
# Expected layout matches cfg/monitors.conf (portrait DP-2 left of DP-1).
set -euo pipefail

need_reload=0
for _ in $(seq 1 20); do
  layout=$(wlr-randr 2>/dev/null) || layout=""
  if printf '%s\n' "$layout" | grep -q '^DP-1 ' && printf '%s\n' "$layout" | grep -q '^DP-2 '; then
    break
  fi
  sleep 0.25
done

dp2_pos=$(printf '%s\n' "$layout" | awk '/^DP-2 /{p=1;next} p&&/Position:/{print $2; exit}')
dp1_pos=$(printf '%s\n' "$layout" | awk '/^DP-1 /{p=1;next} p&&/Position:/{print $2; exit}')
dp2_xf=$(printf '%s\n' "$layout" | awk '/^DP-2 /{p=1;next} p&&/Transform:/{print $2; exit}')

# Portrait left @ 0,0; primary beside it @ 1440,560 with transform 270 on DP-2.
if [ "$dp2_pos" != "0,0" ] || [ "$dp1_pos" != "1440,560" ] || [ "$dp2_xf" != "270" ]; then
  need_reload=1
fi

if [ "$need_reload" -eq 1 ]; then
  mmsg dispatch reload_config >/dev/null
  # XWayland primary can drift after remount too.
  "$HOME/.config/mango/scripts/xwayland-primary.sh" >/dev/null 2>&1 || true
fi
