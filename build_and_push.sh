#!/bin/bash

# Exit on any error
set -e

# Check if version is provided
if [ -z "$1" ]; then
  echo "Error: Version parameter is required"
  echo "Please use: ./build_and_push.sh 2.0"
  exit 1
fi

VERSION=$1
IMAGE_NAME="maelp/docker-vnc-chromium"

echo "Building and pushing $IMAGE_NAME:$VERSION for multiple architectures"

# Setup buildx builder if it doesn't exist
if ! docker buildx inspect builder &>/dev/null; then
  echo "Creating new Docker buildx builder..."
  docker buildx create --name builder --use
fi

# Switch to the builder
docker buildx use builder

# Start the builder
docker buildx inspect --bootstrap

# Build and push for multiple platforms
echo "Building for AMD64 and ARM64..."
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg DOCKER_IMAGE_VERSION="$VERSION" \
  --tag "$IMAGE_NAME:$VERSION" \
  --tag "$IMAGE_NAME:latest" \
  --push \
  .

echo "Build and push completed successfully!"
echo "Image available as:"
echo " - $IMAGE_NAME:$VERSION"
echo " - $IMAGE_NAME:latest"
