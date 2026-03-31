#!/usr/bin/env bash
set -euo pipefail

out_dir="/tmp/handy-failsafe-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$out_dir"

# Capture quick debug context for post-mortem.
niri msg -j focused-window >"${out_dir}/focused-window.json" 2>"${out_dir}/focused-window.err" || true
niri msg -j windows >"${out_dir}/windows.json" 2>"${out_dir}/windows.err" || true
pgrep -af handy >"${out_dir}/handy-procs.txt" 2>/dev/null || true

# Kill handy to release stuck modifier hooks.
pkill -x handy >/dev/null 2>&1 || true

{
    echo "handy failsafe triggered"
    echo "timestamp: $(date --iso-8601=seconds)"
    echo "bundle: ${out_dir}"
} >"${out_dir}/README.txt"

notify-send "Handy failsafe" "Stopped Handy and wrote debug to ${out_dir}" >/dev/null 2>&1 || true
