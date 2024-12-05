# 🏠 Dotfiles

Personal dotfiles configuration managed with GNU Stow. These dotfiles provide a modern and efficient development environment with focus on productivity and ease of use.

## ✨ What's Included

- 🐚 **Zsh Configuration**
  - Custom aliases and functions
  - Syntax highlighting and autosuggestions
  - Spaceship prompt theme
  - FZF integration for fuzzy finding
  
- 🛠️ **Development Tools**
  - Mise (formerly asdf) for version management
  - Node.js, Python, Ruby, Go, and more
  - Neovim configuration
  - Git aliases and configurations
  
- 📋 **System Utilities**
  - Advanced clipboard management
  - Modern command-line tools (ripgrep, fzf, etc.)
  - Container tools (Podman/Docker)

## 🚀 Prerequisites

### Required packages

```bash
sudo apt install -y \
  git \
  zsh \
  stow \
  curl \
  wget \
  xsel \
  xclip \
  batcat \
  ripgrep \
  fzf \
  podman \
  build-essential \
  rsync
```

### Development tools
- Git
- Zsh
- [GNU Stow](https://www.gnu.org/software/stow/)
- [Mise](https://mise.jdx.dev/) (for version management)

## 📥 Installation

1. Clone the repository:
```zsh
git clone git@github.com:carloskvasir/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Install configurations using stow:
```zsh
# Install everything
stow */

# Or install specific configurations
stow zsh        # Install only zsh config
stow mise       # Install mise config
stow aliases    # Install aliases
```

3. Install development tools with mise:
```zsh
# Install all tools defined in mise config
mise install

# Install Python packages
mise use python
```

## 🔄 Updating

To update your dotfiles:

```zsh
cd ~/.dotfiles
git pull
stow */  # Re-stow all configurations
```

## 🎨 Customization

You can customize these dotfiles by:

1. Editing the respective configuration files
2. Adding new tools in `mise/.config/mise/config.toml`
3. Creating new aliases in `aliases/.aliases`
4. Modifying Zsh plugins in `zsh/.zshrc`

## 👤 Author

**Carlos Kvasir**

- 🌐 Website: [carloskvasir.dev](https://carloskvasir.dev)
- 💼 LinkedIn: [carloskvasir](https://linkedin.com/in/carloskvasir)
- 💻 Github: [@carloskvasir](https://github.com/carloskvasir)

## 📝 License

This project is licensed under the Mozilla Public License Version 2.0 - see the [LICENSE](LICENSE) file for details.
