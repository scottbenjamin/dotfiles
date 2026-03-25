#!/usr/bin/env bash
set -euo pipefail
exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
