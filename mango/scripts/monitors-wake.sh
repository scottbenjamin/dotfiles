#!/usr/bin/env bash
# Wake monitors after monitors-sleep.sh, then reapply layout if mangled.
set -euo pipefail

mmsg get all-monitors | jq -r '.monitors[].name' | while read -r name; do
  [ -n "$name" ] || continue
  mmsg dispatch "wakeup_monitor,$name" >/dev/null
done

exec "$HOME/.config/mango/scripts/restore-monitors.sh"
