#!/usr/bin/env bash
set -euo pipefail

out_dir="/tmp/handy-niri-debug-$(date +%Y%m%d-%H%M%S)"
mkdir -p "${out_dir}"

echo "Output dir: ${out_dir}"
echo "Starting captures..."

# Start Handy with debug logging in the background.
pkill handy >/dev/null 2>&1 || true
handy --debug >"${out_dir}/handy-debug.log" 2>&1 &
handy_pid=$!

# Start Niri event stream capture in the background.
niri msg -j event-stream >"${out_dir}/niri-events.jsonl" 2>"${out_dir}/niri-events.err" &
niri_pid=$!

cleanup() {
  kill "${niri_pid}" >/dev/null 2>&1 || true
  kill "${handy_pid}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

cat <<'EOF'

Reproduce now:
1. Focus the app where paste/input breaks.
2. Press your Handy hotkey, speak, press again.
3. Type a few keys to see if remap/stuck-modifier happens.

When done, press Enter here.
EOF

read -r _

echo "Collecting final state snapshots..."
niri msg -j windows >"${out_dir}/niri-windows.json" 2>"${out_dir}/niri-windows.err" || true
niri msg -j focused-window >"${out_dir}/niri-focused.json" 2>"${out_dir}/niri-focused.err" || true
niri msg -j keyboard-layouts >"${out_dir}/niri-keyboard-layouts.json" 2>"${out_dir}/niri-keyboard-layouts.err" || true

# Stop background captures before summary extraction.
cleanup
trap - EXIT

echo "Extracting quick summary..."
{
  echo "=== Last 80 lines: handy-debug.log ==="
  tail -n 80 "${out_dir}/handy-debug.log" || true
  echo
  echo "=== Last 120 lines: niri-events.jsonl ==="
  tail -n 120 "${out_dir}/niri-events.jsonl" || true
} >"${out_dir}/summary.txt"

cat <<EOF

Done.
Logs saved under:
  ${out_dir}

Start with:
  ${out_dir}/summary.txt

Share that path and I will analyze it.
EOF
