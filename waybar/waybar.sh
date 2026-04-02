#!/usr/bin/env sh

# Terminate already running bar instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

export WAYBAR_CONFIG_DIR="$HOME/.config/waybar"

style="$WAYBAR_CONFIG_DIR/style.css"
if [ -n "${NIRI_SOCKET:-}" ] && [ -f "$WAYBAR_CONFIG_DIR/config-niri.jsonc" ]; then
  config="$WAYBAR_CONFIG_DIR/config-niri.jsonc"
else
  config="$WAYBAR_CONFIG_DIR/config.jsonc"
fi

waybar -c "$config" -s "$style" &
