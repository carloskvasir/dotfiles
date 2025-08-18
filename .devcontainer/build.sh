#!/bin/bash
# ZSH-optimized Docker build script for dotfiles DevContainer

set -e

echo "🐳 Building ZSH-optimized DevContainer..."

# Build arguments
USERNAME=${USERNAME:-vscode}
USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-$USER_UID}

# Build with ZSH optimizations
docker build \
    --build-arg USERNAME="$USERNAME" \
    --build-arg USER_UID="$USER_UID" \
    --build-arg USER_GID="$USER_GID" \
    --tag dotfiles-devcontainer:zsh \
    --file .devcontainer/Dockerfile \
    .

echo "✅ ZSH-optimized build completed!"
echo "📊 Image sizes:"
docker images dotfiles-devcontainer:zsh --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

echo ""
echo "🔍 Build cache info:"
docker system df

echo ""
echo "🧪 Testing zsh + mise integration:"
docker run --rm dotfiles-devcontainer:zsh /home/vscode/test-zsh-mise.sh

echo ""
echo "💡 To run interactively: docker run -it --rm dotfiles-devcontainer:zsh"
