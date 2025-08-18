#!/bin/bash
# Optimized multi-stage Docker build script for dotfiles DevContainer

set -e

echo "🐳 Building multi-stage DevContainer..."

# Build arguments
USERNAME=${USERNAME:-vscode}
USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-$USER_UID}

# Build with optimizations
docker build \
    --build-arg USERNAME="$USERNAME" \
    --build-arg USER_UID="$USER_UID" \
    --build-arg USER_GID="$USER_GID" \
    --target runtime \
    --tag dotfiles-devcontainer:latest \
    --file .devcontainer/Dockerfile \
    .

echo "✅ Multi-stage build completed!"
echo "📊 Image sizes:"
docker images dotfiles-devcontainer:latest --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

echo ""
echo "🔍 Build cache info:"
docker system df

echo ""
echo "💡 To run: docker run -it --rm dotfiles-devcontainer:latest zsh"
