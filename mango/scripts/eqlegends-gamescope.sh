#!/usr/bin/env bash
# Nested compositor so EQ Legends fills DP-1 the way Niri fullscreen did.
# Steam launch options: ~/.config/mango/scripts/eqlegends-gamescope.sh %command%
set -euo pipefail
exec gamescope \
  -f \
  -W 2560 \
  -H 1440 \
  -r 280 \
  --adaptive-sync \
  --force-grab-cursor \
  -- "$@"
