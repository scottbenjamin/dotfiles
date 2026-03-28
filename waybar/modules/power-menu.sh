#!/usr/bin/env sh

choice=$(printf '%s\n' Lock Suspend Reboot Shutdown Logout | fuzzel --dmenu --prompt='Power: ')

case "$choice" in
  Lock)
    exec swaylock -f
    ;;
  Suspend)
    loginctl lock-session && systemctl suspend
    ;;
  Reboot)
    systemctl reboot
    ;;
  Shutdown)
    systemctl poweroff
    ;;
  Logout)
    niri msg action quit
    ;;
esac
