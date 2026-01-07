# Run before vendor_conf.d (alphabetically first)
# Disable mise auto-activate - we use shims instead
set -gx MISE_FISH_AUTO_ACTIVATE 0

# Disable direnv auto-hook - we lazy load it instead
set -gx DIRENV_DISABLE_HOOK 1

# Cache brew prefix
set -gx HOMEBREW_PREFIX /opt/homebrew
