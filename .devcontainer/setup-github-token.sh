#!/bin/bash
# Interactive GitHub Token setup for DevContainer registry
# Helps user configure GitHub token safely

set -e

echo "🔑 GitHub Token Setup for Container Registry"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load environment if exists
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

if [[ -f ".env" ]]; then
    source .env
fi

echo -e "${BLUE}📋 Current Configuration:${NC}"
echo "   Repository: ${REPOSITORY_NAME:-'Not set'}"
echo "   GitHub User: ${GITHUB_USERNAME:-'Not set'}"
echo "   Registry: ${REGISTRY:-'ghcr.io'}"
echo "   Token Status: ${GITHUB_REGISTRY_TOKEN:+'Set (***hidden***)' || 'Not set'}"
echo ""

# Function to validate token format
validate_token() {
    local token="$1"
    
    # Check token format
    if [[ ! "$token" =~ ^(ghp_|github_pat_)[A-Za-z0-9_]{20,255}$ ]]; then
        echo "❌ Invalid token format. GitHub tokens should start with 'ghp_' or 'github_pat_'"
        return 1
    fi
    
    # Test token with GitHub API
    echo "🔍 Validating token with GitHub API..."
    local response=$(curl -s -H "Authorization: Bearer $token" 
                         -H "Accept: application/vnd.github.v3+json" 
                         https://api.github.com/user)
    
    if echo "$response" | grep -q '"login"'; then
        local username=$(echo "$response" | grep '"login"' | cut -d'"' -f4)
        echo "✅ Token is valid for user: $username"
        return 0
    else
        echo "❌ Token validation failed. Please check your token."
        echo "Response: $response"
        return 1
    fi
}

# (Removed duplicate test_token function definition)

configure_token() {
    local token="$1"
    local env_file="$REPO_ROOT/.env"
    
    echo "💾 Configuring token in $env_file..."
    
    # Backup existing .env
    if [[ -f "$env_file" ]]; then
        cp "$env_file" "${env_file}.backup.$(date +%s)"
        echo "📋 Backup created: ${env_file}.backup.$(date +%s)"
    fi
    
    # Update or add GITHUB_REGISTRY_TOKEN
    if grep -q "^GITHUB_REGISTRY_TOKEN=" "$env_file" 2>/dev/null; then
        # Update existing line
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/^GITHUB_REGISTRY_TOKEN=.*/GITHUB_REGISTRY_TOKEN="$token"/" "$env_file"
        else
            sed -i "s/^GITHUB_REGISTRY_TOKEN=.*/GITHUB_REGISTRY_TOKEN="$token"/" "$env_file"
        fi
        echo "✅ Updated existing GITHUB_REGISTRY_TOKEN in .env"
    else
        # Add new line
        echo "" >> "$env_file"
# (Removed duplicate configure_token function definition)

# Function to show token creation instructions
show_token_instructions() {
    echo -e "${BLUE}📖 How to create GitHub Personal Access Token:${NC}"
    echo ""
    echo "1. 🌐 Go to: https://github.com/settings/tokens"
    echo "2. 🔘 Click 'Generate new token' → 'Generate new token (classic)'"
    echo "3. ✏️  Fill in:"
    echo "   Name: dotfiles-devcontainer-registry"
    echo "   Expiration: 90 days (recommended)"
    echo ""
    echo "4. ✅ Select permissions:"
    echo "   ☑️  write:packages  (push packages)"
    echo "   ☑️  read:packages   (pull packages)"
    echo "   ☑️  delete:packages (optional - manage packages)"
    if [[ "${REPOSITORY_PRIVATE:-false}" == "true" ]]; then
        echo "   ☑️  repo           (needed for private repos)"
    fi
    echo ""
    echo "5. 🔄 Click 'Generate token'"
    echo "6. 📋 Copy the token (starts with 'ghp_')"
    echo ""
    echo -e "${YELLOW}⚠️  Token only shows once - copy immediately!${NC}"
    echo ""
}

# Function to configure token
configure_token() {
    echo -e "${YELLOW}🔑 GitHub Token Configuration${NC}"
    echo ""
    
    if [[ -n "$GITHUB_REGISTRY_TOKEN" ]]; then
        echo -e "${YELLOW}Token already configured.${NC}"
        read -p "🔄 Update existing token? (y/N): " update_response
        if [[ ! "$update_response" =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    # Check if user needs instructions
    read -p "📖 Do you need instructions to create a token? (y/N): " show_instructions
    if [[ "$show_instructions" =~ ^[Yy]$ ]]; then
        show_token_instructions
        echo "Press Enter when you have your token ready..."
        read -r
    fi
    
    # Get token from user
    echo -e "${BLUE}🔐 Enter your GitHub Personal Access Token:${NC}"
    echo "(Token will be hidden as you type)"
    read -s github_token
    echo ""
    
    if [[ -z "$github_token" ]]; then
        echo -e "${RED}❌ No token provided${NC}"
        return 1
    fi
    
    # Validate token format
    token_type=$(validate_token "$github_token")
    if [[ "$token_type" == "invalid" ]]; then
        echo -e "${RED}❌ Invalid token format${NC}"
        echo "Expected format: ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        return 1
    fi
    
    echo -e "${GREEN}✅ Token format valid ($token_type)${NC}"
    
    # Test token
    if ! test_token "$github_token"; then
        echo -e "${RED}❌ Token test failed${NC}"
        echo "Please check:"
        echo "  - Token has correct permissions"
        echo "  - Token hasn't expired"
        echo "  - Username is correct: ${GITHUB_USERNAME}"
        return 1
    fi
    
    # Save token to .env
    if grep -q "GITHUB_REGISTRY_TOKEN=" .env 2>/dev/null; then
        # Update existing line
        sed -i "s/GITHUB_REGISTRY_TOKEN=.*/GITHUB_REGISTRY_TOKEN=\"$github_token\"/" .env
    else
        # Add new line
        echo "GITHUB_REGISTRY_TOKEN=\"$github_token\"" >> .env
    fi
    
    echo -e "${GREEN}✅ Token saved to .env${NC}"
    echo -e "${GREEN}✅ Configuration complete!${NC}"
    
    # Update current session
    export GITHUB_REGISTRY_TOKEN="$github_token"
    
    return 0
}

# Function to test current setup
test_current_setup() {
    echo -e "${YELLOW}🧪 Testing current setup...${NC}"
    
    if [[ -z "$GITHUB_REGISTRY_TOKEN" ]]; then
        echo -e "${RED}❌ No token configured${NC}"
        return 1
    fi
    
    if [[ -z "$GITHUB_USERNAME" ]]; then
        echo -e "${RED}❌ No GitHub username configured${NC}"
        return 1
    fi
    
    if test_token "$GITHUB_REGISTRY_TOKEN"; then
        echo -e "${GREEN}✅ Setup working correctly!${NC}"
        echo ""
        echo "You can now:"
        echo "  🏗️  Build: ./.devcontainer/build-production.sh"
        echo "  🚀 Push:  ./.devcontainer/manual-push-to-ghcr.sh"
        return 0
    else
        echo -e "${RED}❌ Setup test failed${NC}"
        return 1
    fi
}

# Function to show usage examples
show_usage_examples() {
    echo -e "${BLUE}🚀 Usage Examples:${NC}"
    echo ""
    echo "Build and push manually:"
    echo "  ./.devcontainer/build-production.sh"
    echo "  ./.devcontainer/manual-push-to-ghcr.sh"
    echo ""
    echo "Automated build and push:"
    echo "  ./.devcontainer/build-and-push.sh"
    echo ""
    echo "Use in Codespaces:"
    echo "  Update .devcontainer/devcontainer.json:"
    echo '  "image": "ghcr.io/'${GITHUB_USERNAME}'/'${REPOSITORY_NAME}'/devcontainer:latest"'
    echo ""
}

# Main menu
main_menu() {
    echo -e "${BLUE}🎛️  What would you like to do?${NC}"
    echo ""
    echo "1. 🔧 Configure GitHub token"
    echo "2. 🧪 Test current setup"
    echo "3. 📖 Show token creation guide"
    echo "4. 🚀 Show usage examples"
    echo "5. 🚪 Exit"
    echo ""
    read -p "Choose option (1-5): " choice
    
    case $choice in
        1)
            configure_token
            ;;
        2)
            test_current_setup
            ;;
        3)
            show_token_instructions
            ;;
        4)
            show_usage_examples
            ;;
        5)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option${NC}"
            ;;
    esac
}

# Check prerequisites
echo -e "${YELLOW}🔍 Checking prerequisites...${NC}"

# Check if docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker not found${NC}"
    echo "Please install Docker first"
    exit 1
fi
echo -e "${GREEN}✅ Docker available${NC}"

# Check if .env exists
if [[ ! -f ".env" ]]; then
    echo -e "${YELLOW}⚠️  .env not found${NC}"
    echo "Running environment setup first..."
    if [[ -f ".devcontainer/setup-env.sh" ]]; then
        ./.devcontainer/setup-env.sh
        source .env
    else
        echo -e "${RED}❌ setup-env.sh not found${NC}"
        exit 1
    fi
fi

echo ""

# Main execution
while true; do
    main_menu
    echo ""
    read -p "🔄 Continue? (Y/n): " continue_response
    if [[ "$continue_response" =~ ^[Nn]$ ]]; then
        break
    fi
    echo ""
done

echo ""
echo -e "${GREEN}🎉 GitHub token setup completed!${NC}"
echo ""
echo "📝 Next steps:"
echo "1. Test with: ./.devcontainer/manual-push-to-ghcr.sh"
echo "2. Set up automatic builds with GitHub Actions"
echo "3. Use pre-built image in Codespaces"
