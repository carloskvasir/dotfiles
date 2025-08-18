#!/bin/bash
# Comprehensive test script to verify zsh + mise integration

set -e

echo "🧪 Testing ZSH + Mise integration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Test function
test_tool() {
    local tool=$1
    local description=$2
    
    if command -v "$tool" >/dev/null 2>&1; then
        local version=$(eval "$tool --version 2>/dev/null | head -1" || echo "unknown")
        echo -e "${GREEN}✅ $description${NC}: $version"
        return 0
    else
        echo -e "${RED}❌ $description${NC}: not found"
        return 1
    fi
}

echo "📋 Shell Information:"
echo "   ZSH Version: $(zsh --version)"
echo "   Current Shell: $SHELL"
echo "   PATH: $PATH"

echo ""
echo "🔧 Testing Mise activation..."
if command -v mise &> /dev/null; then
    echo -e "${GREEN}✅ Mise is available${NC}"
    eval "$(mise activate zsh)"
    echo -e "${GREEN}✅ Mise activated for zsh${NC}"
    
    echo ""
    echo "🗂️  Mise Status:"
    mise --version
    mise list --installed 2>/dev/null || echo "No tools installed yet"
    
else
    echo -e "${RED}❌ Mise not found${NC}"
    exit 1
fi

echo ""
echo "💻 Testing Programming Languages:"
test_tool "node" "Node.js"
test_tool "python3" "Python"
test_tool "nvim" "Neovim"

echo ""
echo "🛠️  Testing CLI Tools:"
test_tool "rg" "Ripgrep"
test_tool "fzf" "FZF"
test_tool "lazygit" "LazyGit"
test_tool "yarn" "Yarn"

echo ""
echo "🎯 ZSH + Mise integration test completed!"
echo -e "${GREEN}Ready for development! 🚀${NC}"
