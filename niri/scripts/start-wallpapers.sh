#!/usr/bin/env bash
set -euo pipefail

landscape_candidates=(
  "/home/scott/Documents/wallpapers/xoazbpym3gkg1.jpeg"
  "$HOME/.config/themes/wallpapers/pine-island-under-a-billion-stars-ec-2560x1440.jpg"
  "$HOME/.config/hypr/wallpapers/Nature-Waterfall.jpg"
  "$HOME/.config/hypr/wallpapers/Abstract-Nord.png"
)

portrait_candidates=(
  "/home/scott/Documents/wallpapers/xoazbpym3gkg1.jpeg"
  "$HOME/.config/themes/wallpapers/pine-island-under-a-billion-stars-ec-1440x2560.jpg"
)

landscape_wallpaper=""
for candidate in "${landscape_candidates[@]}"; do
  if [ -f "$candidate" ]; then
    landscape_wallpaper="$candidate"
    break
  fi
done

portrait_wallpaper=""
for candidate in "${portrait_candidates[@]}"; do
  if [ -f "$candidate" ]; then
    portrait_wallpaper="$candidate"
    break
  fi
done

if [ -z "$landscape_wallpaper" ]; then
  notify-send "Niri" "No wallpaper found for swaybg" >/dev/null 2>&1 || true
  exit 0
fi

if [ -z "$portrait_wallpaper" ]; then
  portrait_wallpaper="$landscape_wallpaper"
fi

exec swaybg \
  -o DP-1 -i "$landscape_wallpaper" -m fill \
  -o DP-2 -i "$portrait_wallpaper" -m fill
