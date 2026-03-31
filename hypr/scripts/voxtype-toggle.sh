#!/usr/bin/env bash
set -euo pipefail

# Give the key combo time to fully release before Voxtype starts outputting text.
sleep 0.08

voxtype record toggle
