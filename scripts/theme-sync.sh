#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_PATH="${1:-}"
THEME_MODE="${2:-auto}"

if [[ -z "${IMAGE_PATH}" ]]; then
  IMAGE_PATH="$(find "${ROOT_DIR}/themes/wallpapers" -type f | head -n1 || true)"
fi

if [[ -z "${IMAGE_PATH}" || ! -f "${IMAGE_PATH}" ]]; then
  echo "No wallpaper found. Usage: scripts/theme-sync.sh /path/to/wallpaper.jpg [auto|dark|light]" >&2
  exit 1
fi

if [[ "${THEME_MODE}" != "auto" && "${THEME_MODE}" != "dark" && "${THEME_MODE}" != "light" ]]; then
  echo "Invalid theme mode '${THEME_MODE}'. Use: auto, dark, or light." >&2
  exit 1
fi

if ! command -v tinct >/dev/null 2>&1; then
  echo "tinct is not installed or not in PATH." >&2
  exit 1
fi

mkdir -p \
  "${ROOT_DIR}/waybar/themes" \
  "${ROOT_DIR}/fuzzel/themes" \
  "${ROOT_DIR}/ghostty/themes" \
  "${ROOT_DIR}/hypr"

tinct generate \
  -t "${THEME_MODE}" \
  -i image \
  -p "${IMAGE_PATH}" \
  -o waybar,fuzzel,ghostty,hyprlock,hyprpaper \
  --waybar.output-dir "${ROOT_DIR}/waybar/themes" \
  --waybar.generate-stub=false \
  --fuzzel.output-dir "${ROOT_DIR}/fuzzel/themes" \
  --ghostty.output-dir "${ROOT_DIR}/ghostty/themes" \
  --hyprlock.output-dir "${ROOT_DIR}/hypr" \
  --hyprpaper.output-dir "${ROOT_DIR}/hypr" \
  --force

css_file="${ROOT_DIR}/waybar/themes/tinct.css"
if [[ ! -f "${css_file}" ]]; then
  echo "Expected ${css_file} not found after tinct generate." >&2
  exit 1
fi

hex_for() {
  local key="$1"
  rg "^@define-color ${key} " "${css_file}" | awk '{print $3}' | tr -d ';'
}

background="$(hex_for background)"
surface="$(hex_for surface)"
foreground="$(hex_for foreground)"
outline="$(hex_for outline)"
border_muted="$(hex_for borderMuted)"
accent1="$(hex_for accent1)"
accent3="$(hex_for accent3)"
danger="$(hex_for danger)"
warning="$(hex_for warning)"

for val in "${background}" "${surface}" "${foreground}" "${outline}" "${border_muted}" "${accent1}" "${accent3}" "${danger}" "${warning}"; do
  if [[ -z "${val}" ]]; then
    echo "Failed to parse required palette colors from ${css_file}" >&2
    exit 1
  fi
done

perl -0pi -e 's/background-color "#[0-9A-Fa-f]{6,8}"/background-color "'"${background}"'"/g; s/backdrop-color "#[0-9A-Fa-f]{6,8}"/backdrop-color "'"${background}"'"/g' \
  "${ROOT_DIR}/niri/config.d/20-outputs-overview.kdl"

perl -0pi -e 's/active-color "#[0-9A-Fa-f]{6,8}"/active-color "'"${accent3}"'"/; s/inactive-color "#[0-9A-Fa-f]{6,8}"/inactive-color "'"${outline}"'"/; s/active-color "#[0-9A-Fa-f]{6,8}"/active-color "'"${accent1}"'"/; s/inactive-color "#[0-9A-Fa-f]{6,8}"/inactive-color "'"${border_muted}"'"/' \
  "${ROOT_DIR}/niri/config.d/30-layout.kdl"

perl -0pi -e 's/active-color "#[0-9A-Fa-f]{6,8}"/active-color "'"${accent3}"'"/g; s/inactive-color "#[0-9A-Fa-f]{6,8}"/inactive-color "'"${outline}"'"/g; s/color "#[0-9A-Fa-f]{6,8}"/color "'"${danger}"'70"/' \
  "${ROOT_DIR}/niri/config.d/53-rules-floating-and-privacy.kdl"

perl -0pi -e 's/^background-color=.*/background-color='"${surface}"'dd/m; s/^text-color=.*/text-color='"${foreground}"'/m; s/^border-color=.*/border-color='"${outline}"'/m; s/^background-color=.*/background-color='"${danger}"'dd/m; s/^border-color=.*/border-color='"${warning}"'/m' \
  "${ROOT_DIR}/mako/config"

echo "Theme synced from ${IMAGE_PATH}"
