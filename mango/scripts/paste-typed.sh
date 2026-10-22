#!/usr/bin/env bash
# Type the Wayland clipboard into the focused window. Use for Proton/CEF
# (Battle.net login) where Ctrl+V does not receive the X11 selection.
set -euo pipefail
data=$(wl-paste -n 2>/dev/null || true)
[ -n "$data" ] || exit 0
if command -v xclip >/dev/null; then
  printf '%s' "$data" | xclip -selection clipboard -loops 0 >/dev/null 2>&1 &
fi
sleep 0.08
printf '%s' "$data" | ydotool type --file -
