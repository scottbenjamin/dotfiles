# Run before vendor_conf.d (alphabetically first)
# Disable mise auto-activate - we use shims instead
set -gx MISE_FISH_AUTO_ACTIVATE 0

# Keep agent prompt caches warm and disable optional RTK telemetry
set -gx PI_CACHE_RETENTION long
set -gx RTK_TELEMETRY_DISABLED 1

# Cache brew prefix
set -gx HOMEBREW_PREFIX /opt/homebrew
