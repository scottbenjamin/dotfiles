#!/usr/bin/env bash
set -euo pipefail

# Give the key combo time to fully release before Handy toggles/pastes.
sleep 0.08

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/niri"
mkdir -p "$state_dir"

# Ensure a background Handy instance exists.
if ! pgrep -x handy >/dev/null 2>&1; then
    nohup "$HOME/.local/bin/handy-launch-tuned.sh" >"$state_dir/handy-tuned.log" 2>&1 &
    sleep 0.45
fi

# Prefer signal path (more robust than synthetic key hook paths); fallback to CLI IPC.
pkill -USR2 -x handy >/dev/null 2>&1 || handy --toggle-transcription

# Niri can end up with a stale modifier-facing input state after compositor binds.
# A harmless Shift tap clears that state without forcing focus changes.
sleep 0.02
if command -v wtype >/dev/null 2>&1; then
    wtype -k Shift_L >/dev/null 2>&1 || true
fi
