#!/bin/sh

set -e  # Exit on error
set -u  # Treat unset variables as an error

# Clean up any lock files that might exist
rm -rf /config/userdata/SingletonLock
rm -rf /config/userdata/SingletonCookie

# Create data directories if they don't exist
mkdir -p /config/userdata /config/cache

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
exec chromium --user-data-dir=/config/userdata --disk-cache-dir=/config/cache $CHROMIUM_FLAGS $ARGS
