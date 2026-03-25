#!/usr/bin/env bash
set -euo pipefail

if ! command -v checkupdates >/dev/null 2>&1; then
  printf '{"text":"","tooltip":"Install pacman-contrib for checkupdates","class":"updated"}\n'
  exit 0
fi

count="$(checkupdates 2>/dev/null | wc -l | tr -d ' ')"

if [ "${count}" -gt 0 ]; then
  printf '{"text":"%s UPD","tooltip":"%s package updates available","class":"has-updates"}\n' "${count}" "${count}"
else
  printf '{"text":"","tooltip":"System up to date","class":"updated"}\n'
fi
