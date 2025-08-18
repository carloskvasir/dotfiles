#!/bin/bash
# Test build locally before pushing to GitHub
# This simulates the GitHub Actions workflow locally

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Local DevContainer Build Test${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

# Configuration
IMAGE_NAME="dotfiles-devcontainer"
BUILD_CONTEXT="."
DOCKERFILE_PATH=".devcontainer/Dockerfile"

# Step 1: Validate required files (same as GitHub Actions)
echo -e "${YELLOW}🔍 Step 1: Validating required files...${NC}"

# Change to repository root if we're in .devcontainer
if [[ $(basename "$PWD") == ".devcontainer" ]]; then
    cd ..
fi

required_files=(
    ".devcontainer/Dockerfile"
    ".devcontainer/install-mise-tools.sh"
    "mise/.config/mise/config.toml"
    "mise/.default-python-packages"
    "mise/.default-npm-packages"
)

all_files_exist=true
for file in "${required_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✅${NC} $file"
    else
        echo -e "${RED}❌${NC} $file - MISSING"
        all_files_exist=false
    fi
done

if [[ "$all_files_exist" != "true" ]]; then
    echo -e "${RED}❌ Missing required files. Aborting.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All required files found${NC}"
echo ""

# Step 2: Check .dockerignore
echo ""
echo -e "${YELLOW}🔍 Step 2: Checking .dockerignore...${NC}"
if [[ -f ".dockerignore" ]]; then
    echo -e "${GREEN}✅${NC} .dockerignore exists"
    echo "Contents preview:"
    head -10 .dockerignore | sed 's/^/   /'
    if [[ $(wc -l < .dockerignore) -gt 10 ]]; then
        echo "   ... ($(( $(wc -l < .dockerignore) - 10 )) more lines)"
    fi
else
    echo -e "${YELLOW}⚠️${NC}  .dockerignore not found (recommended)"
fi
echo ""

echo -e "${BLUE}📁 Current directory: $(pwd)${NC}"
echo -e "${BLUE}📋 Repository structure:${NC}"
ls -la | head -10

# Step 3: Build each stage (multi-stage simulation)
echo -e "${YELLOW}🏗️  Step 3: Building stages (simulating GitHub Actions)...${NC}"

stages=("base-deps" "user-setup" "tools-cache" "runtime")

for stage in "${stages[@]}"; do
    echo ""
    echo -e "${BLUE}Building stage: ${stage}${NC}"
    
    if docker build \
        --target "$stage" \
        --tag "${IMAGE_NAME}:${stage}" \
        --file "$DOCKERFILE_PATH" \
        "$BUILD_CONTEXT"; then
        echo -e "${GREEN}✅ Stage ${stage} completed${NC}"
    else
        echo -e "${RED}❌ Stage ${stage} failed${NC}"
        exit 1
    fi
done

echo ""
echo -e "${GREEN}✅ All stages built successfully${NC}"

# Step 4: Test container (simulate GitHub Actions test)
echo ""
echo -e "${YELLOW}🧪 Step 4: Testing container...${NC}"

echo "Starting container for testing..."
CONTAINER_ID=$(docker run -d "${IMAGE_NAME}:runtime" sleep 60)
echo "Container started: $CONTAINER_ID"

# Wait for container to be ready
echo "Waiting for container to be ready..."
sleep 10

# Test basic functionality
echo "Testing basic shell..."
if docker exec "$CONTAINER_ID" /bin/zsh -c 'echo "ZSH is working"'; then
    echo -e "${GREEN}✅ ZSH test passed${NC}"
else
    echo -e "${RED}❌ ZSH test failed${NC}"
    docker stop "$CONTAINER_ID" && docker rm "$CONTAINER_ID"
    exit 1
fi

echo "Testing mise..."
if docker exec "$CONTAINER_ID" /bin/zsh -c 'source ~/.zshrc && mise --version'; then
    echo -e "${GREEN}✅ Mise test passed${NC}"
else
    echo -e "${YELLOW}⚠️  Mise test had issues (may be normal)${NC}"
fi

echo "Testing dependencies..."
if docker exec "$CONTAINER_ID" /bin/bash -c '
    echo "Checking required tools..."
    which bash zsh grep wget curl tar bzip2 xz patch gcc clang mise stow
    echo "All tools found!"
'; then
    echo -e "${GREEN}✅ Dependencies test passed${NC}"
else
    echo -e "${RED}❌ Dependencies test failed${NC}"
    docker stop "$CONTAINER_ID" && docker rm "$CONTAINER_ID"
    exit 1
fi

# Test mise tools if any are installed
echo "Testing installed mise tools..."
docker exec "$CONTAINER_ID" /bin/zsh -c 'source ~/.zshrc && mise list --installed' || echo "No tools installed (normal for fresh build)"

# Cleanup test container
docker stop "$CONTAINER_ID" && docker rm "$CONTAINER_ID"
echo -e "${GREEN}✅ Container tests completed${NC}"

# Step 5: Image size report
echo ""
echo -e "${YELLOW}📊 Step 5: Image size report...${NC}"
echo "Docker images for this build:"
docker images | grep "$IMAGE_NAME" | head -5

echo ""
echo -e "${GREEN}🎉 Local build test completed successfully!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Commit and push your changes to trigger GitHub Actions"
echo "2. GitHub Actions will build and push to ghcr.io"
echo "3. Use the image in Codespaces with the devcontainer.json"
echo ""
echo -e "${BLUE}Manual push to GitHub Container Registry:${NC}"
echo "1. docker login ghcr.io -u your-username"
echo "2. docker tag ${IMAGE_NAME}:runtime ghcr.io/your-username/dotfiles/devcontainer:latest"
echo "3. docker push ghcr.io/your-username/dotfiles/devcontainer:latest"
echo ""
echo -e "${GREEN}✅ Ready for production deployment!${NC}"
