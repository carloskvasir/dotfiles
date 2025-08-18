#!/bin/bash
# Build and Push DevContainer - All-in-one script
echo "🔐 Logging into GitHub Container Registry..."
if echo "$GITHUB_REGISTRY_TOKEN" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin; then
    echo "✅ Login successful"
else
    echo "❌ Login failed. Check your token and username."
    exit 1
fi
# This script builds the DevContainer and pushes to GitHub Container Registry

set -e

echo "🚀 DevContainer Build & Push Pipeline"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

echo -e "${BLUE}📋 Configuration:${NC}"
echo "   Repository: $REPOSITORY_NAME"
echo "   GitHub User: $GITHUB_USERNAME"
echo "   Image: $IMAGE_NAME:$IMAGE_TAG"
echo "   Registry: $REGISTRY"
echo "   Token: ${GITHUB_REGISTRY_TOKEN:+'Configured' || 'Not set'}"
echo ""

# Validate prerequisites
echo "🔍 Checking prerequisites..."

# Check if GITHUB_REGISTRY_TOKEN is set
if [[ -z "$GITHUB_REGISTRY_TOKEN" ]]; then
    echo "❌ GITHUB_REGISTRY_TOKEN not set"
    echo "💡 Run './setup-github-token.sh' to configure it"
    exit 1
fi

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker not found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites OK${NC}"
echo ""

# Step 1: Build the DevContainer
echo -e "${YELLOW}🏗️  Step 1: Building DevContainer...${NC}"

if ./.devcontainer/build-production.sh; then
    echo -e "${GREEN}✅ Build completed successfully${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo ""

# Step 2: Login to GitHub Container Registry
if echo "$GITHUB_REGISTRY_TOKEN" | docker login "$REGISTRY" -u "$GITHUB_USERNAME" --password-stdin; then

if echo "$GITHUB_TOKEN" | docker login "$REGISTRY" -u "$GITHUB_USERNAME" --password-stdin; then
    echo -e "${GREEN}✅ Login successful${NC}"
else
    echo -e "${RED}❌ Login failed${NC}"
    echo "Check your token permissions and expiration"
    exit 1
fi

echo ""

# Step 3: Tag and Push Images
echo -e "${YELLOW}🚀 Step 3: Tagging and pushing images...${NC}"

REMOTE_IMAGE="$REGISTRY/$GITHUB_USERNAME/$REPOSITORY_NAME/devcontainer"

# Generate tags
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
GIT_COMMIT=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_COMMIT=$(git rev-parse --short HEAD)
fi

# Tag images
echo "Tagging images..."
docker tag "$IMAGE_NAME:$IMAGE_TAG" "$REMOTE_IMAGE:latest"
docker tag "$IMAGE_NAME:$IMAGE_TAG" "$REMOTE_IMAGE:$TIMESTAMP"

if [[ -n "$GIT_COMMIT" ]]; then
    docker tag "$IMAGE_NAME:$IMAGE_TAG" "$REMOTE_IMAGE:$GIT_COMMIT"
fi

# Push images
echo "Pushing to registry..."

echo "📤 Pushing latest tag..."
if docker push "$REMOTE_IMAGE:latest"; then
    echo -e "${GREEN}✅ Pushed: latest${NC}"
else
    echo -e "${RED}❌ Failed to push: latest${NC}"
    exit 1
fi

echo "📤 Pushing timestamp tag..."
if docker push "$REMOTE_IMAGE:$TIMESTAMP"; then
    echo -e "${GREEN}✅ Pushed: $TIMESTAMP${NC}"
else
    echo -e "${YELLOW}⚠️  Failed to push timestamp tag${NC}"
fi

if [[ -n "$GIT_COMMIT" ]]; then
    echo "📤 Pushing git commit tag..."
    if docker push "$REMOTE_IMAGE:$GIT_COMMIT"; then
        echo -e "${GREEN}✅ Pushed: $GIT_COMMIT${NC}"
    else
        echo -e "${YELLOW}⚠️  Failed to push git commit tag${NC}"
    fi
fi

echo ""

# Step 4: Cleanup and Summary
echo -e "${YELLOW}🧹 Step 4: Cleanup...${NC}"

# Logout
docker logout "$REGISTRY" &>/dev/null

# Remove local registry tags to save space
docker rmi "$REMOTE_IMAGE:latest" 2>/dev/null || true
docker rmi "$REMOTE_IMAGE:$TIMESTAMP" 2>/dev/null || true
if [[ -n "$GIT_COMMIT" ]]; then
    docker rmi "$REMOTE_IMAGE:$GIT_COMMIT" 2>/dev/null || true
fi

echo -e "${GREEN}✅ Cleanup completed${NC}"
echo ""

# Final Summary
echo "=================================================="
echo -e "${GREEN}🎉 Build & Push Pipeline Completed Successfully!${NC}"
echo ""
echo -e "${BLUE}📦 Published Images:${NC}"
echo "   $REMOTE_IMAGE:latest"
echo "   $REMOTE_IMAGE:$TIMESTAMP"
if [[ -n "$GIT_COMMIT" ]]; then
    echo "   $REMOTE_IMAGE:$GIT_COMMIT"
fi

echo ""
echo -e "${BLUE}🔗 View your packages at:${NC}"
echo "   https://github.com/$GITHUB_USERNAME?tab=packages"

echo ""
echo -e "${BLUE}📋 To use in Codespaces, update .devcontainer/devcontainer.json:${NC}"
echo ""
echo "Replace:"
echo '  "dockerFile": "Dockerfile",'
echo '  "context": ".."'
echo ""
echo "With:"
echo "  \"image\": \"$REMOTE_IMAGE:latest\""

echo ""
echo -e "${BLUE}🚀 Usage Examples:${NC}"
echo ""
echo "Pull and run locally:"
echo "  docker pull $REMOTE_IMAGE:latest"
echo "  docker run -it $REMOTE_IMAGE:latest"
echo ""
echo "Use in VS Code Dev Containers:"
echo "  1. Update devcontainer.json with image URL above"
echo "  2. Rebuild container in VS Code"
echo "  3. Faster startup with pre-built image!"

echo ""
echo -e "${GREEN}✅ Ready for production use!${NC}"
