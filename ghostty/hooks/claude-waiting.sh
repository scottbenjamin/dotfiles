#!/bin/bash
source "$(dirname "$0")/lib.sh"
TTY=$(find_tty)
[ -z "$TTY" ] && exit 0
apply_waiting
