#!/usr/bin/env bash
# Bridge Wayland clipboard -> X11 CLIPBOARD for Wine/Proton (XWayland).
# Never push empty data (that races back through XWayland and clears Wayland).
set -u

lock_file="${XDG_RUNTIME_DIR:-/tmp}/mango-clipboard-sync.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

export DISPLAY="${DISPLAY:-:0}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

command -v wl-paste >/dev/null || exit 1
command -v xclip >/dev/null || exit 1

log="${XDG_RUNTIME_DIR:-/tmp}/mango-clipboard-sync.log"

# Display -> last hash pushed there. Gamescope starts its own Xwayland
# (DISPLAY=:1, not the desktop :0). Battle.net only sees that clipboard.
declare -A synced=()

while true; do
  data=$(wl-paste -n 2>/dev/null) || { sleep 0.25; continue; }
  if [ -n "$data" ]; then
    hash=$(printf '%s' "$data" | sha256sum | awk '{print $1}')
    need_push=0
    displays=()
    for sock in /tmp/.X11-unix/X*; do
      [ -S "$sock" ] || continue
      disp=":${sock##*/X}"
      displays+=("$disp")
      if [ "${synced[$disp]:-}" != "$hash" ]; then
        need_push=1
      fi
    done
    if [ "$need_push" = 1 ]; then
      pkill -f 'xclip -selection clipboard -loops 0' 2>/dev/null || true
      pkill -f 'xclip -selection primary -loops 0' 2>/dev/null || true
      for disp in "${displays[@]}"; do
        printf '%s' "$data" | DISPLAY="$disp" xclip -selection clipboard -loops 0 >/dev/null 2>&1 &
        printf '%s' "$data" | DISPLAY="$disp" xclip -selection primary -loops 0 >/dev/null 2>&1 &
        synced[$disp]=$hash
      done
      printf '%s synced %s bytes to %s\n' "$(date -Iseconds)" "${#data}" "${displays[*]}" >>"$log"
    fi
  fi
  sleep 0.25
done
