#!/usr/bin/env bash
set -euo pipefail

# Give the key combo time to fully release before Handy toggles/pastes.
# Keep this short for responsiveness.
sleep 0.08
exec handy --toggle-transcription
