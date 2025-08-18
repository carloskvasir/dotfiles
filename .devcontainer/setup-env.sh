#!/bin/bash
# Environment setup script for secure dotfiles configuration
# This script helps set up environment variables without hardcoding personal info

set -e

echo "🔧 Environment Configuration Setup"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get repository information dynamically
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REPO_NAME="$(basename "$REPO_ROOT")"
CURRENT_USER="$(whoami)"

# Try to get GitHub info from git config
GIT_USER="$(git config user.name 2>/dev/null || echo "")"
GIT_EMAIL="$(git config user.email 2>/dev/null || echo "")"

# Extract GitHub username from remote URL if available
GITHUB_USERNAME=""
if git remote get-url origin &>/dev/null; then
    REPO_URL=$(git remote get-url origin)
    if [[ "$REPO_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
        GITHUB_USERNAME="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
    fi
fi

echo -e "${BLUE}📋 Detected Information:${NC}"
echo "   Repository: $REPO_NAME"
echo "   Path: $REPO_ROOT"
echo "   System User: $CURRENT_USER"
echo "   Git User: ${GIT_USER:-'Not configured'}"
echo "   Git Email: ${GIT_EMAIL:-'Not configured'}"
echo "   GitHub Username: ${GITHUB_USERNAME:-'Not detected'}"
echo ""

# Function to create .env file
create_env_file() {
    local env_file="$REPO_ROOT/.env"
    
    echo -e "${YELLOW}📝 Creating .env file...${NC}"
    
    # Use detected values or defaults
    local github_user="${GITHUB_USERNAME:-${GIT_USER:-$CURRENT_USER}}"
    
    cat > "$env_file" << EOF
# Auto-generated environment configuration
# Generated on $(date)

# GitHub Configuration
GITHUB_USERNAME=$github_user
# GITHUB_TOKEN=your-personal-access-token-here

# Repository Configuration  
REPOSITORY_NAME=$REPO_NAME
REPO_ROOT=$REPO_ROOT

# Docker Registry
REGISTRY=ghcr.io

# Development Environment
CURRENT_USER=$CURRENT_USER
EDITOR=${EDITOR:-nvim}
SHELL=${SHELL:-zsh}

# Git Configuration
GIT_USER_NAME=$GIT_USER
GIT_USER_EMAIL=$GIT_EMAIL

# Optional: Custom configurations
# MISE_DATA_DIR=$HOME/.local/share/mise
# MISE_CONFIG_DIR=$HOME/.config/mise

# Docker Build Configuration
IMAGE_NAME=${REPO_NAME}-dev
IMAGE_TAG=latest
EOF
    
    echo -e "${GREEN}✅ Created $env_file${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Important: Add your GitHub token to .env if needed${NC}"
    echo "   GITHUB_TOKEN=your-personal-access-token"
    echo ""
}

# Function to update scripts to use environment variables
update_scripts_for_env() {
    echo -e "${YELLOW}🔄 Updating scripts to use environment variables...${NC}"
    
    # Create a helper script for loading environment
    cat > "$REPO_ROOT/.devcontainer/load-env.sh" << 'EOF'
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
EOF
    
    chmod +x "$REPO_ROOT/.devcontainer/load-env.sh"
    echo -e "${GREEN}✅ Created environment loader${NC}"
}

# Function to show usage examples
show_usage_examples() {
    echo -e "${BLUE}📖 Usage Examples:${NC}"
    echo ""
    echo "1. 🔧 In your scripts, add at the top:"
    echo '   source "$(dirname "${BASH_SOURCE[0]}")/load-env.sh"'
    echo ""
    echo "2. 🐳 For Docker builds:"
    echo '   docker build --tag "$IMAGE_NAME:$IMAGE_TAG" .'
    echo ""
    echo "3. 📦 For GitHub Container Registry:"
    echo '   docker tag "$IMAGE_NAME:$IMAGE_TAG" "$REGISTRY/$GITHUB_USERNAME/$REPOSITORY_NAME:$IMAGE_TAG"'
    echo ""
    echo "4. 🧪 Testing environment:"
    echo '   echo "Building for user: $GITHUB_USERNAME"'
    echo '   echo "Repository: $REPOSITORY_NAME"'
    echo ""
}

# Function to test environment
test_environment() {
    echo -e "${YELLOW}🧪 Testing environment configuration...${NC}"
    
    # Source the environment
    if [[ -f "$REPO_ROOT/.env" ]]; then
        source "$REPO_ROOT/.env"
    fi
    
    echo "Environment variables:"
    echo "   GITHUB_USERNAME: ${GITHUB_USERNAME:-'Not set'}"
    echo "   REPOSITORY_NAME: ${REPOSITORY_NAME:-'Not set'}"
    echo "   REPO_ROOT: ${REPO_ROOT:-'Not set'}"
    echo "   IMAGE_NAME: ${IMAGE_NAME:-'Not set'}"
    echo "   CURRENT_USER: ${CURRENT_USER:-'Not set'}"
    echo ""
    
    if [[ -n "$GITHUB_USERNAME" && -n "$REPOSITORY_NAME" ]]; then
        echo -e "${GREEN}✅ Environment looks good!${NC}"
        echo "   Full image path: $REGISTRY/$GITHUB_USERNAME/$REPOSITORY_NAME/$IMAGE_NAME:$IMAGE_TAG"
    else
        echo -e "${YELLOW}⚠️  Some variables not set - check .env file${NC}"
    fi
}

# Main execution
echo -e "${BLUE}🚀 Setting up secure environment...${NC}"
echo ""

# Check if .env already exists
if [[ -f "$REPO_ROOT/.env" ]]; then
    echo -e "${YELLOW}⚠️  .env file already exists${NC}"
    read -p "🔄 Overwrite existing .env file? (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        create_env_file
    else
        echo "Keeping existing .env file"
    fi
else
    create_env_file
fi

update_scripts_for_env
show_usage_examples
test_environment

echo ""
echo -e "${GREEN}🎉 Environment setup completed!${NC}"
echo ""
echo "📝 Next steps:"
echo "1. Review and edit .env file if needed"
echo "2. Add GitHub token to .env if you plan to push to registry"
echo "3. Update your scripts to source load-env.sh"
echo "4. Test with: source .env && echo \$GITHUB_USERNAME"
echo ""
echo -e "${BLUE}🔒 Security note: .env is already in .gitignore${NC}"
