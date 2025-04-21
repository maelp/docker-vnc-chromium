#!/bin/sh

set -e  # Exit on error
set -u  # Treat unset variables as an error

# Clean up any lock files that might exist
rm -rf /config/userdata/SingletonLock /config/userdata/SingletonCookie
[ -d "/config/userdata/Default" ] && rm -rf /config/userdata/Default/Singleton*

echo "Starting Chromium browser..."
exec chromium-browser --user-data-dir=/config/userdata --disk-cache-dir=/config/cache --no-first-run --no-sandbox --disable-setuid-sandbox --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --disable-accelerated-2d-canvas --disable-webgl --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 --disable-extensions --hide-scrollbars ${CHROME_CUSTOM_ARGS:-}
