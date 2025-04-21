# Use a base image with X11 and VNC support
FROM jlesage/baseimage-gui:alpine-3.19-v4

# Docker image version is provided via build arg
ARG DOCKER_IMAGE_VERSION=

# Installs latest Chromium package.
RUN apk upgrade --no-cache --available \
    && apk add --no-cache \
    curl \
    socat \
    chromium-swiftshader \
    ttf-freefont \
    font-noto-emoji \
    && apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    font-wqy-zenhei

# Copy font configuration for better rendering
COPY local.conf /etc/fonts/local.conf

# Set environment variables
ENV CHROME_CUSTOM_ARGS="--no-first-run --password-store=basic --no-sandbox --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --disable-accelerated-2d-canvas --disable-webgl --hide-scrollbars --remote-allow-origins=* --remote-debugging-address=0.0.0.0"
ENV KEEP_APP_RUNNING=1
ENV VNC_RESOLUTION="1920x1080"
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/

# Create necessary directories for user data and configurations with proper permissions
RUN mkdir -p /config/userdata /config/cache && \
    chmod -R 777 /config

# Add the startup script
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Expose necessary ports for VNC and the web interface
EXPOSE 5900 5800 9222
