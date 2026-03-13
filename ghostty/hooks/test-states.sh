#!/bin/bash
# Interactive test for Claude Code visual states in Ghostty
# Usage: bash ghostty/hooks/test-states.sh
source "$(dirname "$0")/lib.sh"
TTY=/dev/tty

trap apply_default EXIT

while true; do
  echo ""
  echo "  Claude Code Visual States Tester"
  echo "  ─────────────────────────────────"
  echo "  1) Waiting  (orange cursor + warm glow)"
  echo "  2) Prompt   (blue cursor + bell — choose/approve)"
  echo "  3) Working  (full terminal dim)"
  echo "  4) Default  (theme reset)"
  echo "  5) Cycle    (auto-play all states)"
  echo "  q) Quit"
  echo ""
  printf "  Pick a state: "
  read -r choice

  case "$choice" in
    1) apply_waiting;  echo "  → Waiting: Claude finished, your turn" ;;
    2) apply_prompt;   echo "  → Prompt: Claude needs you to choose/approve" ;;
    3) apply_working;  echo "  → Working: Claude is thinking..." ;;
    4) apply_default;  echo "  → Default colors restored" ;;
    5)
      echo "  → Cycling through states..."
      apply_default;  echo "    [default] ...";                        sleep 2
      apply_waiting;  echo "    [waiting] Claude finished...";         sleep 3
      apply_working;  echo "    [working] User submitted, thinking..."; sleep 3
      apply_prompt;   echo "    [prompt] Claude needs approval...";    sleep 3
      apply_working;  echo "    [working] Approved, continuing...";    sleep 3
      apply_waiting;  echo "    [waiting] Claude finished again...";   sleep 3
      apply_default;  echo "    [default] Session exited";             sleep 1
      ;;
    q|Q) echo "  Bye!"; exit 0 ;;
    *)   echo "  Unknown option" ;;
  esac
done
