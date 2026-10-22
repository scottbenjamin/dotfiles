#!/usr/bin/env bash
# Nested compositor so Battle.net / WoW only see DP-1 (2560x1440).
# Without this, Wine enumerates the portrait DP-2 as Monitor 0 and WoW
# opens at 1440x2560 ("screen is so big").
# Steam launch options: ~/.config/mango/scripts/battlenet-gamescope.sh %command%
set -euo pipefail

# Stay inside gamescope's nested X11 — the global PROTON_ENABLE_WAYLAND=1
# would otherwise talk to the desktop compositor and see both monitors.
export PROTON_ENABLE_WAYLAND=0

# Launcher size, 1:1. A 2560x1440 gamescope buffer upscales Battle.net's
# small window and looks pixelated, and tag 4 then tiles that to the panel.
# -r/--adaptive-sync/-f fight mango and flicker. Linear fit avoids integer
# scaling if the frame is a few pixels off.
exec gamescope \
  -W 1280 \
  -H 720 \
  -w 1280 \
  -h 720 \
  -S fit \
  -F linear \
  --force-windows-fullscreen \
  -O DP-1 \
  -- "$@"
