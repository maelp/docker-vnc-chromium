#!/bin/sh

set -e  # Exit on error
set -u  # Treat unset variables as an error

# Clean up any lock files that might exist
rm -rf /config/userdata/SingletonLock /config/userdata/SingletonCookie
[ -d "/config/userdata/Default" ] && rm -rf /config/userdata/Default/Singleton*

# Handle custom parameters
ARGS=""

# Add any custom arguments
if [ -n "${CHROME_CUSTOM_ARGS}" ]; then
    ARGS="$ARGS ${CHROME_CUSTOM_ARGS}"
fi

echo "Starting Chromium browser..."
exec chromium-browser --user-data-dir=/config/userdata --disk-cache-dir=/config/cache ${CHROMIUM_FLAGS:-} $ARGS
