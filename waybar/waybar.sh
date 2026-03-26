#!/usr/bin/env sh

# Terminate already running bar instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

style="$HOME/.config/waybar/style.css"
if [ -n "${NIRI_SOCKET:-}" ] && [ -f "$HOME/.config/waybar/config-niri.jsonc" ]; then
  config="$HOME/.config/waybar/config-niri.jsonc"
elif [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && [ -f "$HOME/.config/waybar/config-hyprland.jsonc" ]; then
  config="$HOME/.config/waybar/config-hyprland.jsonc"
else
  config="$HOME/.config/waybar/config.jsonc"
fi

waybar -c "$config" -s "$style" &
