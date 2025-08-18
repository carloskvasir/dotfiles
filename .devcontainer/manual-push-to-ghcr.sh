#!/bin/bash
# Script para push manual para GitHub Container Registry
# Use este script se quiser fazer push manual da imagem

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Manual Push to GitHub Container Registry${NC}"
echo -e "${BLUE}==========================================${NC}"
echo ""

# Configuration - Load environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/load-env.sh" ]]; then
    source "$SCRIPT_DIR/load-env.sh"
else
    # Fallback to manual detection
    GITHUB_USERNAME="${GITHUB_USERNAME:-$(git config user.name || echo "$(whoami)")}"
    REPOSITORY_NAME="${REPOSITORY_NAME:-$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo "dotfiles")")}"
    REGISTRY="ghcr.io"
    
    # Auto-detect from git remote if available
    if git remote get-url origin &>/dev/null; then
        REPO_URL=$(git remote get-url origin)
        if [[ "$REPO_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
            GITHUB_USERNAME="${BASH_REMATCH[1]}"
            REPOSITORY_NAME="${BASH_REMATCH[2]}"
        fi
    fi
fi

REMOTE_IMAGE="${REGISTRY}/${GITHUB_USERNAME}/${REPOSITORY_NAME}/devcontainer"

# Try different possible local image names
POSSIBLE_LOCAL_IMAGES=(
    "dotfiles-dev:runtime"
    "dotfiles-dev:latest"
    "dotfiles-devcontainer:runtime"
    "dotfiles-devcontainer:latest"
)

LOCAL_IMAGE=""
for img in "${POSSIBLE_LOCAL_IMAGES[@]}"; do
    if docker image inspect "$img" &> /dev/null; then
        LOCAL_IMAGE="$img"
        break
    fi
done

if [[ -z "$LOCAL_IMAGE" ]]; then
    echo -e "${RED}❌ No local image found${NC}"
    echo ""
    echo "Imagens tentadas:"
    for img in "${POSSIBLE_LOCAL_IMAGES[@]}"; do
        echo "   - $img"
    done
    echo ""
    echo "Imagens Docker disponíveis:"
    docker images | grep -E "(dotfiles|devcontainer)" || echo "   Nenhuma imagem relacionada encontrada"
    echo ""
    echo "Build a imagem primeiro com:"
    echo "   ./.devcontainer/build-production.sh"
    echo "   ou"
    echo "   cd \$(git rev-parse --show-toplevel) && ./.devcontainer/build-production.sh"
    exit 1
fi

echo -e "${YELLOW}📋 Configuration:${NC}"
echo "   Local Image: $LOCAL_IMAGE"
echo "   Remote Image: $REMOTE_IMAGE"
echo "   Registry: $REGISTRY"
echo ""

# Step 1: Check if local image exists
echo -e "${YELLOW}🔍 Step 1: Checking local image...${NC}"
echo -e "${GREEN}✅ Local image found: $LOCAL_IMAGE${NC}"
echo ""
echo "Todas as imagens relacionadas:"
docker images | grep -E "(dotfiles|devcontainer)" | head -5
echo ""

# Step 2: Login to GitHub Container Registry
echo -e "${YELLOW}🔐 Step 2: Login to GitHub Container Registry...${NC}"
echo "You'll need a GitHub Personal Access Token with 'write:packages' permission"
echo ""

if ! docker login "$REGISTRY" -u "$GITHUB_USERNAME"; then
    echo -e "${RED}❌ Login failed${NC}"
    echo ""
    echo "To create a token:"
    echo "1. Go to GitHub Settings → Developer settings → Personal access tokens"
    echo "2. Generate new token with 'write:packages' permission"
    echo "3. Use your GitHub username and the token as password"
    exit 1
fi

echo -e "${GREEN}✅ Login successful${NC}"
echo ""

# Step 3: Tag image for registry
echo -e "${YELLOW}🏷️  Step 3: Tagging image for registry...${NC}"

# Tag with latest
echo "Tagging as latest..."
docker tag "$LOCAL_IMAGE" "${REMOTE_IMAGE}:latest"

# Tag with timestamp
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
echo "Tagging with timestamp: $TIMESTAMP"
docker tag "$LOCAL_IMAGE" "${REMOTE_IMAGE}:${TIMESTAMP}"

# Tag with git commit (if available)
if git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_COMMIT=$(git rev-parse --short HEAD)
    echo "Tagging with git commit: $GIT_COMMIT"
    docker tag "$LOCAL_IMAGE" "${REMOTE_IMAGE}:${GIT_COMMIT}"
fi

echo -e "${GREEN}✅ Image tagged successfully${NC}"
echo ""

# Step 4: Push images
echo -e "${YELLOW}🚀 Step 4: Pushing images to registry...${NC}"

echo "Pushing latest tag..."
if docker push "${REMOTE_IMAGE}:latest"; then
    echo -e "${GREEN}✅ Pushed latest tag${NC}"
else
    echo -e "${RED}❌ Failed to push latest tag${NC}"
    exit 1
fi

echo "Pushing timestamp tag..."
if docker push "${REMOTE_IMAGE}:${TIMESTAMP}"; then
    echo -e "${GREEN}✅ Pushed timestamp tag${NC}"
else
    echo -e "${YELLOW}⚠️  Failed to push timestamp tag (continuing...)${NC}"
fi

if [[ -n "$GIT_COMMIT" ]]; then
    echo "Pushing git commit tag..."
    if docker push "${REMOTE_IMAGE}:${GIT_COMMIT}"; then
        echo -e "${GREEN}✅ Pushed git commit tag${NC}"
    else
        echo -e "${YELLOW}⚠️  Failed to push git commit tag (continuing...)${NC}"
    fi
fi

echo ""

# Step 5: Verification
echo -e "${YELLOW}✅ Step 5: Verification${NC}"
echo "Image pushed successfully to GitHub Container Registry!"
echo ""
echo -e "${BLUE}📦 Available images:${NC}"
echo "   ${REMOTE_IMAGE}:latest"
echo "   ${REMOTE_IMAGE}:${TIMESTAMP}"
if [[ -n "$GIT_COMMIT" ]]; then
    echo "   ${REMOTE_IMAGE}:${GIT_COMMIT}"
fi

echo ""
echo -e "${BLUE}🔗 View your packages at:${NC}"
echo "   https://github.com/${GITHUB_USERNAME}?tab=packages"

echo ""
echo -e "${BLUE}📋 To use in Codespaces, update your .devcontainer/devcontainer.json:${NC}"
echo '   {'
echo '     "image": "'${REMOTE_IMAGE}':latest",'
echo '     "customizations": {'
echo '       "vscode": {'
echo '         "extensions": ['
echo '           "ms-vscode-remote.remote-containers"'
echo '         ]'
echo '       }'
echo '     }'
echo '   }'

echo ""
echo -e "${GREEN}🎉 Manual push completed successfully!${NC}"

# Step 6: Cleanup local tags (optional)
echo ""
echo -e "${YELLOW}🧹 Cleanup local registry tags? (y/N)${NC}"
read -r cleanup_response
if [[ "$cleanup_response" =~ ^[Yy]$ ]]; then
    echo "Removing local registry tags..."
    docker rmi "${REMOTE_IMAGE}:latest" 2>/dev/null || true
    docker rmi "${REMOTE_IMAGE}:${TIMESTAMP}" 2>/dev/null || true
    if [[ -n "$GIT_COMMIT" ]]; then
        docker rmi "${REMOTE_IMAGE}:${GIT_COMMIT}" 2>/dev/null || true
    fi
    echo -e "${GREEN}✅ Local registry tags cleaned up${NC}"
else
    echo "Local registry tags kept for future use"
fi

echo ""
echo -e "${GREEN}✅ All done!${NC}"
