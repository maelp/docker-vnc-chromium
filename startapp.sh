#!/bin/sh

set -e  # Exit on error
set -u  # Treat unset variables as an error

# Clean up any lock files that might exist
rm -rf /config/userdata/SingletonLock /config/userdata/SingletonCookie
[ -d "/config/userdata/Default" ] && rm -rf /config/userdata/Default/Singleton*

echo "Starting Chromium browser..."
echo "Args: ${CHROME_CUSTOM_ARGS:-}"
# Use socat to proxy the debugging interface
# This creates a proxy that:
# 1. Listens on 0.0.0.0:9222 (accessible from outside the container)
# 2. Forwards all connections to 127.0.0.1:9223 (Chromium's internal debugging port)
# 3. This works around issues with Chromium in this environment not properly accepting
#    external connections when asked to bind directly to 0.0.0.0
socat TCP-LISTEN:9222,fork,reuseaddr,bind=0.0.0.0 TCP:127.0.0.1:9223 &

# Run Chromium with debugging on internal port
exec chromium-browser \
    --user-data-dir=/config/userdata \
    --disk-cache-dir=/config/cache \
    --remote-debugging-address=127.0.0.1 \
    --remote-debugging-port=9223 \
    --remote-allow-origins=* \
    ${CHROME_CUSTOM_ARGS:-} \
    about:blank
