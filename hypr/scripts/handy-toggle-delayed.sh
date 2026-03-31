#!/usr/bin/env bash
set -euo pipefail

# Give the key combo time to fully release before Handy toggles/pastes.
orig_addr="$(hyprctl activewindow -j 2>/dev/null | jq -r '.address // empty' 2>/dev/null || true)"

sleep 0.08

# Ensure a background Handy instance exists.
if ! pgrep -x handy >/dev/null 2>&1; then
    nohup /home/scott/.local/bin/handy-launch-tuned.sh >/tmp/handy-tuned.log 2>&1 &
    sleep 0.45
fi

# Prefer signal path (more robust than synthetic key hook paths); fallback to CLI IPC.
pkill -USR2 -x handy >/dev/null 2>&1 || handy --toggle-transcription

# After toggling/paste, if focus moved to Handy, force focus back.
sleep 0.18
new_class="$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty' 2>/dev/null || true)"
if [[ -n "${orig_addr}" ]] && [[ "${new_class,,}" =~ handy|com\.pais\.handy ]]; then
    hyprctl dispatch focuswindow "address:${orig_addr}" >/dev/null 2>&1 || true
fi
