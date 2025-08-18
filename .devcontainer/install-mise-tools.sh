#!/bin/bash
# Install mise tools with retry logic for rate limiting

set -e

echo "🔧 Installing mise tools with retry logic..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Retry configuration
MAX_RETRIES=3
RETRY_DELAY=5

# Function to retry commands with exponential backoff
retry_command() {
    local cmd="$1"
    local attempt=1
    
    while [ $attempt -le $MAX_RETRIES ]; do
        echo -e "${YELLOW}Attempt $attempt/$MAX_RETRIES: $cmd${NC}"
        
        if eval "$cmd"; then
            echo -e "${GREEN}✅ Success on attempt $attempt${NC}"
            return 0
        else
            echo -e "${RED}❌ Failed attempt $attempt${NC}"
            if [ $attempt -lt $MAX_RETRIES ]; then
                local delay=$((RETRY_DELAY * attempt))
                echo -e "${YELLOW}⏳ Waiting ${delay}s before retry...${NC}"
                sleep $delay
            fi
            ((attempt++))
        fi
    done
    
    echo -e "${RED}❌ Failed after $MAX_RETRIES attempts${NC}"
    return 1
}

# Ensure mise is available
export PATH="$HOME/.local/bin:$PATH"

# Verify mise installation
if ! command -v mise &> /dev/null; then
    echo -e "${RED}❌ Mise not found in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Mise found: $(mise --version)${NC}"

# Install essential tools with retry logic
echo "📦 Installing essential development tools..."

# Node.js
echo "Installing Node.js..."
retry_command "mise install nodejs@22" || {
    echo -e "${YELLOW}⚠️  Node.js installation failed, trying LTS version...${NC}"
    retry_command "mise install nodejs@lts" || {
        echo -e "${RED}❌ Failed to install Node.js${NC}"
        exit 1
    }
}

# Python
echo "Installing Python..."
retry_command "mise install python@3.12" || {
    echo -e "${YELLOW}⚠️  Python 3.12 installation failed, trying 3.11...${NC}"
    retry_command "mise install python@3.11" || {
        echo -e "${RED}❌ Failed to install Python${NC}"
        exit 1
    }
}

# Set global versions
echo "Setting global tool versions..."
mise global nodejs@22 2>/dev/null || mise global nodejs@lts
mise global python@3.12 2>/dev/null || mise global python@3.11

# Install additional tools that are commonly needed
echo "Installing additional development tools..."

# Try to install other useful tools, but don't fail if they don't work
install_optional_tool() {
    local tool="$1"
    echo "Installing $tool..."
    if retry_command "mise install $tool"; then
        echo -e "${GREEN}✅ $tool installed successfully${NC}"
    else
        echo -e "${YELLOW}⚠️  $tool installation failed (optional)${NC}"
    fi
}

# Optional tools (don't fail build if these fail)
install_optional_tool "neovim"
install_optional_tool "ripgrep"
install_optional_tool "fzf"
install_optional_tool "lazygit"
install_optional_tool "yarn"

# Verify installations
echo ""
echo "🔍 Verifying installations..."
mise list --installed

# Test that tools are working
echo ""
echo "🧪 Testing tool functionality..."

# Test Node.js
if command -v node &> /dev/null; then
    echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"
else
    echo -e "${RED}❌ Node.js not working${NC}"
fi

# Test Python
if command -v python &> /dev/null; then
    echo -e "${GREEN}✅ Python: $(python --version)${NC}"
else
    echo -e "${RED}❌ Python not working${NC}"
fi

# Test npm
if command -v npm &> /dev/null; then
    echo -e "${GREEN}✅ npm: $(npm --version)${NC}"
else
    echo -e "${YELLOW}⚠️  npm not available${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Mise tools installation completed!${NC}"

# Generate a simple tool report
echo ""
echo "📋 Installed Tools Report:"
echo "=========================="
mise list --installed 2>/dev/null || echo "No tools reported by mise list"

# Refresh mise shims
echo ""
echo "🔄 Refreshing mise shims..."
mise reshim 2>/dev/null || echo "Reshim completed"

echo -e "${GREEN}✅ All done!${NC}"
