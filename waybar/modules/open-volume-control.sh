#!/usr/bin/env bash
set -euo pipefail

if command -v pwvucontrol >/dev/null 2>&1; then
  exec pwvucontrol
fi

if command -v pavucontrol >/dev/null 2>&1; then
  exec pavucontrol
fi

exec notify-send "Waybar" "No volume control app found (pwvucontrol/pavucontrol)."
