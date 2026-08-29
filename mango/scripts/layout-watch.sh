#!/usr/bin/env bash
set -u

lock_file="${XDG_RUNTIME_DIR:-/tmp}/mango-layout-watch.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

previous_layout=""

while :; do
    while IFS= read -r event; do
        layout_symbol=$(jq -r '
            .monitors[]
            | select(.active == true)
            | .layout_symbol
        ' <<<"$event" 2>/dev/null) || continue

        [ -n "$layout_symbol" ] || continue
        [ "$layout_symbol" = "$previous_layout" ] && continue
        previous_layout="$layout_symbol"

        noctalia msg plugin \
            scott/mango_layouts:btn \
            all \
            set-layout \
            "$layout_symbol" >/dev/null 2>&1 || true
    done < <(mmsg watch all-monitors 9>&- 2>/dev/null)

    sleep 1
done
