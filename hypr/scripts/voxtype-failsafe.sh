#!/usr/bin/env bash
set -euo pipefail

out_dir="/tmp/voxtype-failsafe-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$out_dir"

hyprctl activewindow -j >"${out_dir}/activewindow.json" 2>"${out_dir}/activewindow.err" || true
hyprctl clients -j >"${out_dir}/clients.json" 2>"${out_dir}/clients.err" || true
pgrep -af voxtype >"${out_dir}/voxtype-procs.txt" 2>/dev/null || true

voxtype record stop >/dev/null 2>&1 || true
pkill -x voxtype >/dev/null 2>&1 || true

{
    echo "voxtype failsafe triggered"
    echo "timestamp: $(date --iso-8601=seconds)"
    echo "bundle: ${out_dir}"
} >"${out_dir}/README.txt"

notify-send "Voxtype failsafe" "Stopped Voxtype and wrote debug to ${out_dir}" >/dev/null 2>&1 || true
