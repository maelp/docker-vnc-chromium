#!/bin/sh

set -e  # Exit on error
set -u  # Treat unset variables as an error

# Clean up any lock files that might exist
rm -rf /config/chromium-user-data/SingletonLock
rm -rf /config/chromium-user-data/SingletonCookie

# Handle custom parameters
ARGS=""

# Add startup URL if specified
if [ -n "${CHROME_OPEN_URL}" ]; then
    ARGS="$ARGS ${CHROME_OPEN_URL}"
fi

# Enable kiosk mode if requested
if [ "${CHROME_KIOSK}" -eq 1 ]; then
    ARGS="$ARGS --kiosk"
fi

# Add any custom arguments
if [ -n "${CHROME_CUSTOM_ARGS}" ]; then
    ARGS="$ARGS ${CHROME_CUSTOM_ARGS}"
fi

echo "Starting Chromium browser..."
exec chromium --user-data-dir=/config/chromium-user-data --disk-cache-dir=/config/chromium-cache --no-first-run $CHROMIUM_FLAGS $ARGS
