#!/usr/bin/env bash
set -euo pipefail

out_dir="/tmp/voxtype-failsafe-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$out_dir"

niri msg -j focused-window >"${out_dir}/focused-window.json" 2>"${out_dir}/focused-window.err" || true
niri msg -j windows >"${out_dir}/windows.json" 2>"${out_dir}/windows.err" || true
pgrep -af voxtype >"${out_dir}/voxtype-procs.txt" 2>/dev/null || true

voxtype record stop >/dev/null 2>&1 || true
pkill -x voxtype >/dev/null 2>&1 || true

{
    echo "voxtype failsafe triggered"
    echo "timestamp: $(date --iso-8601=seconds)"
    echo "bundle: ${out_dir}"
} >"${out_dir}/README.txt"

notify-send "Voxtype failsafe" "Stopped Voxtype and wrote debug to ${out_dir}" >/dev/null 2>&1 || true
