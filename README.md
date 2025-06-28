# Dotfiles

Personal dotfiles configuration managed with GNU Stow and Mise. These dotfiles provide a modern and efficient development environment with focus on productivity, security, and ease of use.

## functions
  - Syntax highlighting and autosuggestions
  - Starship prompt theme
  - FZF integration for fuzzy finding
  - Modern shell tools integration
  
- **Development Tools via Mise**
  - **Languages**: Node.js 22.16, Python 3.12, Ruby 3, Go, Rust, Java 24, Lua
  - **Editors**: Neovim (latest)
  - **Build Tools**: Terraform, Maven, Yarn, Just
  - **Modern CLI Tools**: ripgrep, fzf, fd, bat, eza, delta, dust, bottom, zoxide
  - **Git Tools**: lazygit, gh, glab, pre-commit, git-cliff
  - **Web Development**: Deno, Bun, TypeScript tools
  - **DevOps**: gcloud, aws-cli, kubectl
  
- **Package Management**
  - **Python**: aider, black, flake8, mypy, pytest, httpie, rich, typer
  - **Node.js**: TypeScript, ESLint, Prettier, nodemon
  - **Ruby**: bundler, pry, rubocop, solargraph
  
- **Security Features**
  - Templates for sensitive configurations
  - Comprehensive .gitignore protection
  - Security audit capabilities

## Prerequisites

### System packages (managed by package manager)

```bash
# Basic requirements - install via package manager
sudo apt install -y \
  git \
  zsh \
  stow \
  curl \
  wget \
  xsel \
  xclip \
  build-essential \
  rsync

# Additional dependencies for mise
gcc autoconf make unixodbc unzip
```

### Development tools (managed by Mise)
All development tools and language runtimes are automatically managed by [Mise](https://mise.jdx.dev/):

- **Languages**: Node.js, Python, Ruby, Go, Rust, Java, Lua
- **CLI Tools**: ripgrep, fzf, fd, bat, eza, delta, bottom, zoxide, starship
- **Git Tools**: lazygit, gh, glab, pre-commit, git-cliff  
- **Build Tools**: terraform, maven, yarn, just
- **Development**: neovim, deno, bun, kubectl

**Note**: No need to install these manually - Mise will handle everything!

## Installation

1. **Clone the repository:**
```bash
git clone git@github.com:carloskvasir/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. **Install configurations using stow:**
```bash
# Install everything
stow */

# Or install specific configurations
stow zsh        # Install only zsh config
stow mise       # Install mise config
stow aliases    # Install aliases
stow tmux       # Install tmux config
stow nvim       # Install neovim config
```

3. **Install development tools with mise:**
```bash
# Install Mise first
curl https://mise.jdx.dev/install.sh | sh

# Reload shell to activate mise
exec zsh

# Install all tools defined in mise config
mise install

# All languages and tools are now available!
# Check installation
mise list
```

4. **Setup personal configurations (IMPORTANT):**
```bash
# Copy SSH template for personal use
cp ssh/.ssh/config.template ssh/.ssh/config
# Edit with your real SSH configurations
vim ssh/.ssh/config

# Copy Git template for personal use  
cp gitconfig/.gitconfig.template gitconfig/.gitconfig
# Edit with your real name and email
vim gitconfig/.gitconfig
```

## Security

This dotfiles repository includes security features to protect sensitive information:

- **Templates**: Sensitive files (SSH config, Git config) use `.template` versions
- **Protection**: Comprehensive `.gitignore` prevents committing sensitive data
- **Audit**: Security audit script available (when created)

**Important**: Never commit real SSH configurations, API keys, or personal information!

## Updating

To update your dotfiles and tools:

```bash
cd ~/.dotfiles

# Update dotfiles configurations
git pull

# Re-stow all configurations
stow */

# Update all mise tools to latest versions
mise upgrade

# Update specific language packages
mise exec python -- pip install --upgrade pip
mise exec node -- npm update -g
mise exec ruby -- bundle update
```

## Customization

### Adding New Tools
1. **Languages/CLI Tools**: Edit `mise/.config/mise/config.toml`
2. **Python Packages**: Edit `mise/.default-python-packages`  
3. **Node.js Packages**: Edit `mise/.default-npm-packages`
4. **Ruby Gems**: Edit `mise/.default-gems`
5. **Shell Aliases**: Edit `aliases/.aliases`
6. **Zsh Configuration**: Edit `zsh/.zshrc`

### Personal Configurations
- **SSH**: Edit `ssh/.ssh/config` (your personal copy)
- **Git**: Edit `gitconfig/.gitconfig` (your personal copy)
- **Local overrides**: Create `.local` versions of any config file

### Example: Adding a new tool
```bash
# Add to mise config
echo 'hugo = "latest"' >> mise/.config/mise/config.toml

# Install the new tool
mise install hugo

# Use it
hugo version
```

## Directory Structure

```
~/.dotfiles/
├── aliases/           # Shell aliases and functions
├── gitconfig/         # Git configuration (template)
├── mise/              # Development tools and version management
│   ├── .config/mise/config.toml    # Tool definitions
│   ├── .default-python-packages    # Python packages
│   ├── .default-npm-packages       # Node.js packages
│   └── .default-gems              # Ruby gems
├── nvim/              # Neovim configuration
├── ssh/               # SSH configuration (template)
├── tmux/              # Terminal multiplexer config
├── zsh/               # Zsh shell configuration
├── kitty/             # Kitty terminal config
├── i3/                # i3 window manager config
└── xmodmap/           # Keyboard mapping config
```

## What You Get

After installation, you'll have access to:

### Modern CLI Tools
- `rg` - ripgrep (faster grep)
- `fd` - modern find
- `bat` - cat with syntax highlighting  
- `eza` - modern ls
- `fzf` - fuzzy finder
- `zoxide` - smart cd (z command)
- `delta` - better git diff
- `bottom` - modern htop
- `lazygit` - git TUI

### Development Environment
- **Multi-language support**: Node.js, Python, Ruby, Go, Rust, Java
- **Package managers**: npm, pip, bundler, go mod
- **Modern editors**: Neovim with LSP support
- **Version management**: Seamless switching between language versions

### Productivity Features  
- **Smart shell**: Auto-completion, syntax highlighting
- **Git integration**: Enhanced diff, aliases, workflows
- **Terminal multiplexing**: tmux with custom config
- **Modern prompt**: Starship with git status and language info

## Troubleshooting

### Common Issues

**Mise not found after installation:**
```bash
# Add to your shell profile
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
exec zsh
```

**Tool installation fails:**
```bash
# Check mise status
mise doctor

# Install dependencies
sudo apt install -y build-essential

# Retry installation
mise install
```

**Stow conflicts:**
```bash
# Remove existing configs first
rm ~/.zshrc ~/.gitconfig

# Then stow
stow zsh gitconfig
```

**SSH/Git templates not working:**
```bash
# Make sure you copied templates to real files
cp ssh/.ssh/config.template ssh/.ssh/config
cp gitconfig/.gitconfig.template gitconfig/.gitconfig

# Edit with your real information
```

## Author

**Carlos Kvasir**

- 🌐 Website: [kvasir.dev](https://kvasir.dev)
- 💼 LinkedIn: [carloskvasir](https://linkedin.com/in/carloskvasir)

## 📝 License

This project is licensed under the Mozilla Public License Version 2.0 - see the [LICENSE](LICENSE) file for details.
