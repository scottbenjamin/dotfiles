#!/usr/bin/env bash
# Nested compositor so Enshrouded (Proton/XWayland) survives focus switches.
# Without this, exclusive scanout teardown on mango 0.17.4+ freezes the game.
# Steam launch options: ~/.config/mango/scripts/enshrouded-gamescope.sh %command%
set -euo pipefail

# Stay inside gamescope's nested X11 — the global PROTON_ENABLE_WAYLAND=1
# would otherwise talk to the desktop compositor and see both monitors.
export PROTON_ENABLE_WAYLAND=0

exec gamescope \
  -f \
  -W 2560 \
  -H 1440 \
  -w 2560 \
  -h 1440 \
  -r 280 \
  --adaptive-sync \
  --force-grab-cursor \
  --force-windows-fullscreen \
  -O DP-1 \
  -- "$@"
