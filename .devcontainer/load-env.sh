#!/bin/bash
# Environment loader for dotfiles scripts

# Load .env file if it exists
if [[ -f "$(git rev-parse --show-toplevel 2>/dev/null || pwd)/.env" ]]; then
    set -a  # Export all variables
    source "$(git rev-parse --show-toplevel 2>/dev/null || pwd)/.env"
    set +a  # Stop exporting
fi

# Set defaults if not defined
export REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
export REPOSITORY_NAME="${REPOSITORY_NAME:-$(basename "$REPO_ROOT")}"
export GITHUB_USERNAME="${GITHUB_USERNAME:-$(git config user.name 2>/dev/null || whoami)}"
export REGISTRY="${REGISTRY:-ghcr.io}"
export IMAGE_NAME="${IMAGE_NAME:-${REPOSITORY_NAME}-dev}"
export IMAGE_TAG="${IMAGE_TAG:-latest}"
export CURRENT_USER="${CURRENT_USER:-$(whoami)}"

# Auto-detect GitHub username from remote if not set
if [[ -z "$GITHUB_USERNAME" ]] && git remote get-url origin &>/dev/null; then
    REPO_URL=$(git remote get-url origin)
    if [[ "$REPO_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
        export GITHUB_USERNAME="${BASH_REMATCH[1]}"
    fi
fi
