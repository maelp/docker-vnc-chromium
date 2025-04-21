# Use a base image with X11 and VNC support
FROM jlesage/baseimage-gui:alpine-3.19-v4

# Docker image version is provided via build arg
ARG DOCKER_IMAGE_VERSION=

# Install Chromium and VNC server with enhanced fonts and better rendering
RUN apk upgrade --no-cache --available \
    && apk add --no-cache \
    chromium-swiftshader \
    ttf-freefont \
    font-noto-emoji \
    && apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    font-wqy-zenhei

# Copy font configuration for better rendering
COPY local.conf /etc/fonts/local.conf

# Add Chrome as a user
RUN mkdir -p /usr/src/app \
    && adduser -D chrome \
    && chown -R chrome:chrome /usr/src/app

# Set environment variables
ENV CHROME_CUSTOM_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --disable-accelerated-2d-canvas --disable-webgl --hide-scrollbars" \
    KEEP_APP_RUNNING=1 \
    VNC_RESOLUTION="1920x1080" \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

# Create necessary directories for user data and configurations with proper permissions
RUN mkdir -p /config/userdata /config/cache && \
    chmod -R 777 /config

# Add the startup script
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Expose necessary ports for VNC and the web interface
EXPOSE 5900 5800

# Metadata
LABEL \
    org.label-schema.name="chromium-vnc" \
    org.label-schema.description="Docker container for Chromium with VNC access" \
    org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
    org.label-schema.schema-version="1.0"
