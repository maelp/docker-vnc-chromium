#!/bin/sh

set -e  # Exit on error
set -u  # Treat unset variables as an error

# Clean up any lock files that might exist
rm -rf /config/userdata/SingletonLock /config/userdata/SingletonCookie
[ -d "/config/userdata/Default" ] && rm -rf /config/userdata/Default/Singleton*

# Create NSS directory in /config which should be writable
mkdir -p /config/nssdb
export NSS_DB_DIR=/config/nssdb

# Reset environment variable for DBus to prevent errors
export DBUS_SESSION_BUS_ADDRESS=disabled

# Handle custom parameters
ARGS=""

# Add any custom arguments
if [ -n "${CHROME_CUSTOM_ARGS}" ]; then
    ARGS="$ARGS ${CHROME_CUSTOM_ARGS}"
fi

echo "Starting Chromium browser..."
exec chromium-browser --user-data-dir=/config/userdata --disk-cache-dir=/config/cache ${CHROMIUM_FLAGS:-} $ARGS
