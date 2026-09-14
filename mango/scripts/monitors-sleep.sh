#!/usr/bin/env bash
# DPMS-style sleep without tearing outputs out of mango's layout.
# Noctalia's native screen_off uses disable_monitor/enable_monitor, which
# remounts displays and auto-places them (DP-1 left, DP-2 right) until
# reload_config reapplies monitorrules.
set -euo pipefail

mmsg get all-monitors | jq -r '.monitors[].name' | while read -r name; do
  [ -n "$name" ] || continue
  mmsg dispatch "sleep_monitor,$name" >/dev/null
done
