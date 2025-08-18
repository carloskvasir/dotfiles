#!/bin/bash
# Post-creation setup script for multi-stage dotfiles DevContainer
set -e

echo "🚀 Setting up dotfiles development environment (multi-stage optimized)..."

# Ensure we're in the right directory
cd /workspaces/dotfiles

# Make sure mise is in PATH and activated
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"

# Check if mise tools are already cached from build
if mise list | grep -q "node\|python"; then
    echo "✅ Found pre-installed tools from build cache"
else
    echo "📦 Installing development tools via mise..."
fi

# Apply dotfiles configurations first
echo "🔗 Applying dotfiles configurations with GNU Stow..."

# Apply mise configuration
if [ -d "mise" ]; then
    echo "  📦 Applying mise configurations..."
    stow mise || echo "⚠️  Mise config already applied or failed"
fi

# Apply other configurations
CONFIG_DIRS=(zsh gitconfig tmux aliases nvim)
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  🔧 Applying $dir configuration..."
        stow "$dir" || echo "⚠️  $dir config already applied or failed"
    fi
done

# Install any missing tools from .tool-versions or config.toml
if [ -f "$HOME/.config/mise/config.toml" ]; then
    echo "�️  Installing/updating tools via mise..."
    # Install tools (cached ones will be fast)
    mise install --quiet || echo "⚠️  Some tools may have failed to install"
    
    # Install Python packages
    if [ -f "$HOME/.default-python-packages" ]; then
        echo "🐍 Installing default Python packages..."
        while IFS= read -r pkg; do
            [ -z "$pkg" ] && continue
            [[ "$pkg" =~ ^# ]] && continue
            mise exec python@3.12 -- pip install -q "$pkg"
        done < "$HOME/.default-python-packages"
    fi
        # Safely install npm packages, handling spaces/special characters
        grep -v "^#" "$HOME/.default-npm-packages" | xargs -r -d '\n' mise exec node@22.16.0 -- npm install -g
    # Install npm packages
    if [ -f "$HOME/.default-npm-packages" ]; then
        echo "📦 Installing default npm packages..."
        mise exec node@22.16.0 -- npm install -g $(cat "$HOME/.default-npm-packages" | grep -v "^#" | xargs)
    fi
fi

# Final shell setup
echo "🐚 Configuring shell environment..."
# Ensure mise is activated in zsh
if [ -f "$HOME/.zshrc" ] && ! grep -q "mise activate" "$HOME/.zshrc"; then
    echo 'eval "$(mise activate zsh)"' >> "$HOME/.zshrc"
fi

# Show final status
echo ""
echo "✅ DevContainer setup complete!"
echo "📋 Installed tools:"
mise list 2>/dev/null || echo "  Run 'mise list' to see available tools"
echo ""
echo "💡 Quick tips:"
echo "  • Run 'mise use <tool>@<version>' to set project-specific versions"
echo "  • Use 'stow <package>' to apply more configurations"
echo "  • Check 'mise --help' for more commands"
