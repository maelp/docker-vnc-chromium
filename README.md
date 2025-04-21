# Docker VNC Chromium

A Docker container that runs Chromium browser accessible via VNC, allowing for persistent sessions and cookie storage.

## Features

- Chromium browser with GUI accessible via VNC
- Enhanced font rendering with multi-language support
- Improved performance with SwiftShader support
- Persistent cookie and session storage
- Remote debugging enabled
- Web interface for easy access
- Based on Alpine Linux for a lightweight footprint
- Optional security features:
  - VNC password protection
  - Web interface authentication

## Use Cases

- Maintain persistent browser sessions in the cloud
- Access websites requiring authentication while preserving cookies
- Automated web scraping while maintaining logged-in sessions
- Integration with tools like Karakeep for bookmarking and scraping
- Provide secure browsing environment with optional access controls

## How It Works

The container:
1. Uses `jlesage/baseimage-gui:alpine-3.19-v4` as the base image
2. Installs Chromium browser and TigerVNC server
3. Configures persistent storage for browser data/cookies in `/config` directories
4. Exposes ports 5800 (web interface) and 5900 (VNC)
5. Starts VNC server with 1920x1080 resolution
6. Launches Chromium with remote debugging enabled

## Installation

### Build the Docker image locally

```bash
git clone https://github.com/maelp/docker-vnc-chromium.git
cd docker-vnc-chromium
docker build -t maelp/docker-vnc-chromium:latest .
```

### Or pull from Docker Hub

```bash
docker pull maelp/docker-vnc-chromium
```

## Usage

### Run the container

```bash
docker run -d \
  --name chromium-vnc \
  -p 5800:5800 \
  -p 5900:5900 \
  -v /tmp/docker-vnc-chromium-config:/config \
  maelp/docker-vnc-chromium:latest
```

For a quick test with temporary configuration, use:

```bash
docker run --rm \
  --name chromium-vnc \
  -p 5800:5800 \
  -p 5900:5900 \
  -v /tmp/docker-vnc-chromium-config:/config \
  maelp/docker-vnc-chromium:latest
```

### Secure Container Setup

To run with basic VNC password protection:

```bash
docker run -d \
  --name chromium-vnc-secure \
  -p 5800:5800 \
  -p 5900:5900 \
  -v /tmp/docker-vnc-chromium-config:/config \
  -e VNC_PASSWORD=your-secure-password \
  maelp/docker-vnc-chromium:latest
```

To enable web interface authentication:

```bash
docker run -d \
  --name chromium-vnc-webauth \
  -p 5800:5800 \
  -p 5900:5900 \
  -v /tmp/docker-vnc-chromium-config:/config \
  -e WEB_AUTHENTICATION=1 \
  -e WEB_AUTHENTICATION_USERNAME=admin \
  -e WEB_AUTHENTICATION_PASSWORD=your-secure-password \
  maelp/docker-vnc-chromium:latest
```

Where:
- Port 5800: Web interface for VNC
- Port 5900: VNC server port
- `/tmp/docker-vnc-chromium-config`: Local path for storing persistent browser data (use a permanent path for production)

### Connect to the browser

1. **Web interface**: Open `http://localhost:5800` in your browser
   - If you enabled WEB_AUTHENTICATION, you'll be prompted for the username and password
2. **VNC client**: Connect to `localhost:5900` using any VNC client
   - If you set VNC_PASSWORD, you'll be prompted for the password

#### Access Methods Comparison

| Method | Port | Advantages | Authentication |
|--------|------|------------|----------------|
| Web Interface | 5800 | Works in any browser, no client needed | WEB_AUTHENTICATION variables |
| VNC Client | 5900 | More responsive, potentially better performance | VNC_PASSWORD |

## Docker Hub Publication

### Building and Pushing Multi-Architecture Images

This repository includes a script to build and push multi-architecture images (AMD64 and ARM64) that work across different platforms:

```bash
# Login to Docker Hub first
docker login

# Build and push with default version (1.0)
./build_and_push.sh

# Or specify a custom version
./build_and_push.sh 1.1
```

The script uses Docker Buildx to create images for multiple architectures, ensuring that when users pull the image, they automatically get the correct version for their platform.

### Manual Build and Push

If you prefer to build manually for a single architecture:

1. Build the image:
```bash
docker build -t maelp/docker-vnc-chromium:latest .
```

2. Login to Docker Hub:
```bash
docker login
```

3. Push the image:
```bash
docker push maelp/docker-vnc-chromium:latest
```

### Version Tags

When working with different Chromium versions, consider using version tags:

```bash
# Build with version tag
docker build -t maelp/docker-vnc-chromium:124.0.6367.78 .

# Run with specific version
docker run -d \
  --name chromium-vnc \
  -p 5800:5800 \
  -p 5900:5900 \
  -v /tmp/docker-vnc-chromium-config:/config \
  maelp/docker-vnc-chromium:124.0.6367.78
```

## Environment Variables

### Application Variables

| Variable | Description | Default |
|----------|-------------|---------|
| CHROMIUM_FLAGS | Core flags for Chromium | Empty |
| CHROME_OPEN_URL | URL to open on startup | Empty |
| CHROME_KIOSK | Enable kiosk mode (1=enabled, 0=disabled) | `0` |
| CHROME_CUSTOM_ARGS | Custom arguments for Chromium | Empty |
| KEEP_APP_RUNNING | Auto-restart the application if it crashes | `1` (enabled) |

### Security Variables

| Variable | Description | Use Case | Default |
|----------|-------------|----------|---------|
| VNC_PASSWORD | Password for VNC access | Protect direct VNC connections (port 5900) from unauthorized access | Empty (no password) |
| WEB_AUTHENTICATION | Enable web interface authentication (1=enabled, 0=disabled) | Protect web interface (port 5800) with login screen | `0` (disabled) |
| WEB_AUTHENTICATION_USERNAME | Username for web interface login | Used when WEB_AUTHENTICATION=1 | Empty |
| WEB_AUTHENTICATION_PASSWORD | Password for web interface login | Used when WEB_AUTHENTICATION=1 | Empty |
| SECURE_CONNECTION | Enable HTTPS for web interface and SSL for VNC (1=enabled, 0=disabled) | Encrypt all connections for additional security | `0` (disabled) |

**Note about security:** When running behind a reverse proxy that handles HTTPS termination, enabling `SECURE_CONNECTION` may not be necessary. However, `VNC_PASSWORD` and `WEB_AUTHENTICATION` can still provide valuable access control even in secure environments.

### Display Variables

| Variable | Description | Default |
|----------|-------------|---------|
| DISPLAY_WIDTH | Width of the application window | `1920` |
| DISPLAY_HEIGHT | Height of the application window | `1080` |

## Persistent Data

Browser data is stored in:
- `/config/userdata`: User profile, cookies, history, etc.
- `/config/cache`: Browser cache

You can mount these directories separately for more control over data persistence and backup strategies:

```bash
# Example: Mounting userdata and cache separately
docker run -d \
  --name chromium-vnc \
  -p 5800:5800 \
  -v /path/to/userdata:/config/userdata \
  -v /path/to/cache:/config/cache \
  maelp/docker-vnc-chromium:latest
```

## License

[MIT License](LICENSE)