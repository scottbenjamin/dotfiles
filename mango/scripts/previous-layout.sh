#!/usr/bin/env bash
set -euo pipefail

# Mango exposes the active layout by its index but only provides a forward
# switch-layout dispatcher. Keep this order aligned with Mango's layout table.
layouts=(
    tile
    scroller
    monocle
    grid
    deck
    center_tile
    vertical_tile
    right_tile
    vertical_scroller
    vertical_grid
    vertical_deck
    dwindle
    fair
    vertical_fair
)

current=$(mmsg get all-monitors | jq -er '.monitors[] | select(.active == true) | .layout_index')
previous=$(( (current - 1 + ${#layouts[@]}) % ${#layouts[@]} ))

mmsg dispatch "setlayout,${layouts[$previous]}" >/dev/null
