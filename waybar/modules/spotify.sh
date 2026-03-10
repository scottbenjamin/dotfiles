#!/usr/bin/env bash

class=$(playerctl metadata --player=spotify --format '{{lc(status)}}' 2>/dev/null)
icon=""

if [[ "$class" == "playing" ]]; then
  info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
  if [[ ${#info} -gt 40 ]]; then
    info="${info:0:40}..."
  fi
  text="$info $icon"
elif [[ "$class" == "paused" ]]; then
  text=$icon
elif [[ "$class" == "stopped" || -z "$class" ]]; then
  text=""
fi

echo -e "{\"text\":\"$text\", \"class\":\"$class\"}"
