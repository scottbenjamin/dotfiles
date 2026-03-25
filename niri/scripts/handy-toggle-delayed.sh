#!/usr/bin/env bash
set -euo pipefail

# Give the key combo time to fully release before Handy toggles/pastes.
# Slightly longer delay avoids post-paste input/focus desync in some apps.
sleep 0.25
exec handy --toggle-transcription
