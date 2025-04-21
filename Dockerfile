# Use a base image with X11 and VNC support
FROM jlesage/baseimage-gui:alpine-3.19-v4

# Docker image version is provided via build arg
ARG DOCKER_IMAGE_VERSION=

# Define software versions
ARG CHROMIUM_VERSION=124.0.6367.78-r0

# Install Chromium and VNC server
RUN add-pkg \
    chromium=${CHROMIUM_VERSION} \
    ttf-freefont \
    nss \
    freetype \
    harfbuzz \
    alsa-lib \
    dbus \
    dbus-x11 \
    mesa-dri-gallium \
    mesa-egl \
    mesa-gl \
    xvfb \
    tigervnc \
    # Add UI improvements
    adwaita-icon-theme \
    font-dejavu \
    xdotool

# Set internal environment variables
RUN \
    set-cont-env APP_NAME "Chromium" && \
    set-cont-env APP_VERSION "$CHROMIUM_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION"

# Set environment variables
ENV CHROMIUM_FLAGS=""
ENV \
    CHROME_OPEN_URL= \
    CHROME_KIOSK=0 \
    CHROME_CUSTOM_ARGS="--no-first-run --no-sandbox --disable-setuid-sandbox --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --disable-accelerated-2d-canvas --disable-webgl --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 --disable-extensions --hide-scrollbars" \
    KEEP_APP_RUNNING=1 \
    DBUS_SESSION_BUS_ADDRESS="disabled" \
    VNC_RESOLUTION="1920x1080"

# Create necessary directories for user data and configurations with proper permissions
RUN mkdir -p /config/userdata /config/cache /config/nssdb && \
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
