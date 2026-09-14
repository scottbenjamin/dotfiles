#!/usr/bin/env bash
# Wait for a StatusNotifier host (noctalia) before launching the update tray.
# Starting too early exits with: failed to register to the StatusNotifierWatcher.
set -u

for _ in $(seq 1 60); do
  if busctl --user get-property \
    org.kde.StatusNotifierWatcher \
    /StatusNotifierWatcher \
    org.kde.StatusNotifierWatcher \
    ProtocolVersion >/dev/null 2>&1; then
    exec /usr/bin/cachy-update --tray
  fi
  sleep 0.5
done

echo "cachy-update-tray: StatusNotifierWatcher not available after 30s" >&2
exit 1
