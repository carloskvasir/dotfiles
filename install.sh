#!/bin/bash
# Script to install essential tools in devcontainers/codespaces using GNU Stow
set -e

# Update system
sudo apt update && sudo apt upgrade -y

# Install basic tools including GNU Stow (without neovim and tmux)
sudo apt install -y git curl wget zsh stow


# Install mise (version manager)
if ! command -v mise &> /dev/null; then
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# Apply mise configurations before installing tools
if [ -d "mise" ]; then
  echo "Applying mise configurations with GNU Stow..."
  stow mise
fi

# Install all tools listed in mise config.toml via mise
if [ -f "$HOME/.config/mise/config.toml" ]; then
  echo "Installing all tools from mise config.toml via mise..."
  mise install
else
  echo "Warning: mise config.toml file not found, no tools installed via mise."
fi

# Use Stow to apply configurations
echo "Applying configurations with GNU Stow..."

# List of configuration directories
CONFIG_DIRS=(nvim zsh gitconfig tmux aliases)
EXISTING_DIRS=()

for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    EXISTING_DIRS+=("$dir")
  else
    echo "Warning: directory '$dir' not found, skipping."
  fi
done

if [ ${#EXISTING_DIRS[@]} -gt 0 ]; then
  stow "${EXISTING_DIRS[@]}"
  echo "Configurations applied successfully!"
else
  echo "No configuration directories found to apply with Stow."
fi
