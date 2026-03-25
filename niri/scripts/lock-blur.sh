#!/usr/bin/env bash
set -euo pipefail

wallpaper="${LOCK_WALLPAPER:-}"
if [[ -z "${wallpaper}" ]]; then
  niri_startup_conf="${HOME}/.config/niri/config.d/00-startup-and-core.kdl"
  if [[ -f "${niri_startup_conf}" ]]; then
    wallpaper="$(sed -n 's/.*spawn-at-startup "swaybg".*"-i" "\([^"]\+\)".*/\1/p' "${niri_startup_conf}" | head -n1 || true)"
  fi
fi

if [[ -z "${wallpaper}" || ! -f "${wallpaper}" ]]; then
  exec swaylock -f
fi

exec swaylock -f --scaling fill -i "${wallpaper}"
