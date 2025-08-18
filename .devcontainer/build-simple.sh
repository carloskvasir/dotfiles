#!/bin/bash
# Simplified Docker build script with debugging

set -e

echo "🚀 Simplified Docker Build"
echo "=========================="

# Fixed variables
IMAGE_NAME="dotfiles-dev"
IMAGE_TAG="latest"

echo "Variables:"
echo "  IMAGE_NAME: $IMAGE_NAME"
echo "  IMAGE_TAG: $IMAGE_TAG"
echo ""

# Test basic build first
echo "🏗️  Testing basic build..."

# Change to repository root regardless of where script is run
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

echo "Current directory: $(pwd)"

echo "Building base-deps stage..."
docker build \
    --target base-deps \
    --tag "$IMAGE_NAME:base-deps" \
    --file .devcontainer/Dockerfile \
    . || {
    echo "❌ Failed at base-deps"
    exit 1
}
echo "✅ base-deps completed"

echo "Building user-setup stage..."
docker build \
    --target user-setup \
    --tag "$IMAGE_NAME:user-setup" \
    --file .devcontainer/Dockerfile \
    . || {
    echo "❌ Failed at user-setup"
    exit 1
}
echo "✅ user-setup completed"

echo "Building tools-cache stage..."
docker build \
    --target tools-cache \
    --tag "$IMAGE_NAME:tools-cache" \
    --file .devcontainer/Dockerfile \
    . || {
    echo "❌ Failed at tools-cache"
    exit 1
}
echo "✅ tools-cache completed"

echo "Building runtime stage..."
docker build \
    --target runtime \
    --tag "$IMAGE_NAME:$IMAGE_TAG" \
    --file .devcontainer/Dockerfile \
    . || {
    echo "❌ Failed at runtime"
    exit 1
}
echo "✅ runtime completed"

echo ""
echo "🎉 All stages built successfully!"
docker images | grep "$IMAGE_NAME"
