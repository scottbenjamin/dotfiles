#!/usr/bin/env bash
set -euo pipefail

direction=${1:-}
case "$direction" in
    increase) delta=0.1 ;;
    decrease) delta=-0.1 ;;
    *) exit 2 ;;
esac

layout=$(mmsg get all-monitors | jq -er '.monitors[] | select(.active == true) | .layout_symbol')
[ "$layout" = "S" ] || exit 0

current=$(mmsg get focusing-client | jq -er '.scroller_proportion')
next=$(awk -v current="$current" -v delta="$delta" 'BEGIN {
    value = current + delta
    if (value < 0.1) value = 0.1
    if (value > 1.0) value = 1.0
    printf "%.1f", value
}')

mmsg dispatch "set_proportion,$next" >/dev/null
