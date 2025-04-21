#!/bin/sh

set -e  # Exit on error
set -u  # Treat unset variables as an error

# Clean up any lock files that might exist
rm -rf /config/userdata/SingletonLock /config/userdata/SingletonCookie
[ -d "/config/userdata/Default" ] && rm -rf /config/userdata/Default/Singleton*

echo "Starting Chromium browser..."
echo "Args: ${CHROME_CUSTOM_ARGS:-}"
# Add a socat proxy for the debugging port
socat TCP-LISTEN:9222,fork,reuseaddr TCP:127.0.0.1:9223 &

exec chromium-browser \
    --user-data-dir=/config/userdata \
    --disk-cache-dir=/config/cache \
    --remote-debugging-address=127.0.0.1 \
    --remote-debugging-port=9223 \
    ${CHROME_CUSTOM_ARGS:-} \
    about:blank
