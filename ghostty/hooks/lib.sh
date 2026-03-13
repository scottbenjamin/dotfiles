#!/bin/bash
# Shared library for Claude Code Ghostty visual hooks
# Source this from hook scripts: source "$(dirname "$0")/lib.sh"

# --- Theme: Kanagawabones ---
# Override these to match your terminal theme
THEME_FG="#ddd8bb"
THEME_BG="#1f1f28"
THEME_CURSOR="#e6e0c2"

# Waiting state (agent finished, needs user input)
WAITING_FG="#e6d5a8"
WAITING_BG="#2a2018"
WAITING_CURSOR="#ff9e64"

# Prompt state (agent asking user to choose/approve — needs attention)
PROMPT_FG="#ddd8bb"
PROMPT_BG="#281a1a"
PROMPT_CURSOR="#e46876"

# Working state (agent processing)
WORKING_FG="#555555"
WORKING_BG="#17171f"
WORKING_CURSOR="#555555"

# Dimmed ANSI palette for working state
DIMMED_PALETTE=(
  "#1a1a1a" "#5a4040" "#405a40" "#5a5a40"
  "#40405a" "#5a405a" "#405a5a" "#4a4a4a"
  "#333333" "#6a5050" "#506a50" "#6a6a50"
  "#50506a" "#6a506a" "#506a6a" "#555555"
)

# --- TTY discovery ---
# Claude Code hooks run in subprocesses without /dev/tty access.
# Walk the process tree to find the controlling terminal.
find_tty() {
  local pid=$$
  while [ "$pid" != "1" ] && [ -n "$pid" ]; do
    local tty_name
    tty_name=$(ps -o tty= -p "$pid" 2>/dev/null | tr -d ' ')
    if [ -n "$tty_name" ] && [ "$tty_name" != "??" ]; then
      echo "/dev/$tty_name"
      return
    fi
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  done
}

# --- Color helpers ---
osc() { printf '\033]%s\007' "$1" > "$TTY"; }

set_fg()     { osc "10;$1"; }
set_bg()     { osc "11;$1"; }
set_cursor() { osc "12;$1"; }
send_bell()  { printf '\a' > "$TTY"; }

set_ansi_palette() {
  for i in $(seq 0 15); do
    osc "4;$i;${DIMMED_PALETTE[$i]}"
  done
}

reset_ansi_palette() {
  for i in $(seq 0 15); do
    osc "104;$i"
  done
}

apply_default() {
  reset_ansi_palette
  set_fg "$THEME_FG"
  set_bg "$THEME_BG"
  set_cursor "$THEME_CURSOR"
}

apply_waiting() {
  apply_default
  set_bg "$WAITING_BG"
  set_cursor "$WAITING_CURSOR"
}

apply_prompt() {
  apply_default
  set_fg "$PROMPT_FG"
  set_bg "$PROMPT_BG"
  set_cursor "$PROMPT_CURSOR"
  send_bell
}

apply_working() {
  apply_default
  set_fg "$WORKING_FG"
  set_bg "$WORKING_BG"
  set_cursor "$WORKING_CURSOR"
  set_ansi_palette
}
