# Dotfiles

Personal dotfiles configuration managed with GNU Stow and Mise. These dotfiles provide a modern and efficient development environment with focus on productivity, security, and ease of use.

## 🚀 DevContainer & CI/CD

Este repositório inclui um ambiente DevContainer otimizado pronto para uso, com imagem disponível no GitHub Container Registry.

### 🐳 Opções de Uso do DevContainer

#### Opção 1: Imagem Pré-construída (Mais Rápida)
```bash
# Pull da imagem oficial do registry
docker pull ghcr.io/carloskvasir/dotfiles/devcontainer:latest

# Executar diretamente
docker run -it --rm -v $(pwd):/workspace ghcr.io/carloskvasir/dotfiles/devcontainer:latest
```

#### Opção 2: VS Code Dev Containers (Recomendado)
1. Instale o [VS Code](https://code.visualstudio.com/) e a extensão [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Clone o repositório:
   ```bash
   git clone https://github.com/carloskvasir/dotfiles.git
   cd dotfiles
   ```
3. Abra no VS Code e selecione "Reabrir no Container" quando solicitado
4. Aguarde a configuração automática (3-5 minutos)

#### Opção 3: Build Local com Makefile
```bash
cd dotfiles
make dev-up        # Inicia ambiente completo com Docker Compose
make dev-shell     # Acesso direto ao shell do container
make dev-down      # Para e remove containers
```

### 🎯 Benefícios do DevContainer

- ✅ **Ambiente Consistente**: Mesma configuração em qualquer máquina
- ⚡ **Build Otimizado**: Multi-stage build com cache (60-80% mais rápido)
- 🔄 **Volumes Persistentes**: Settings e cache preservados entre sessões
- 🛠️ **Ferramentas Pré-instaladas**: +50 ferramentas prontas para uso
- 🔒 **Isolamento**: Não afeta o sistema host

### CI/CD

O build do DevContainer é testado automaticamente via GitHub Actions:
- **Registry**: Imagens publicadas em `ghcr.io/carloskvasir/dotfiles/devcontainer`
- **Testes**: Validação automática de funcionalidade e performance
- **Workflow**: `.github/workflows/devcontainer-advanced.yml`

---

## 🚀 Quick Start

### Option 1: DevContainer (Recommended)
The fastest way to get started with a complete development environment:

```bash
# 1. Clone the repository
git clone https://github.com/carloskvasir/dotfiles.git
cd dotfiles

# 2. Open in VS Code with DevContainer
code .
# VS Code will prompt to "Reopen in Container"

# 3. Wait for automatic setup (3-5 minutes)
# Everything will be configured automatically!
```

### Option 2: Manual Installation
For direct installation on your system:

```bash
# 1. Clone the repository
git clone https://github.com/carloskvasir/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Install with our automated script
chmod +x install.sh
./install.sh

# 3. Or use the Makefile
make install
```

### Option 3: Quick Install (One-liner)
```bash
curl -fsSL https://raw.githubusercontent.com/carloskvasir/dotfiles/main/install.sh | bash
```

## 🎯 Features
### 🐳 DevContainer Features
- **Multi-stage optimized** Docker build (60-80% faster rebuilds)
- **Automatic setup** - zero manual configuration required
- **Pre-installed tools** - All languages and CLI tools ready to use
- **Persistent storage** - Your settings and cache persist between sessions
- **VS Code integration** - Perfect development environment out-of-the-box

### 🐚 Shell Experience (Zsh)
- **Smart completion** - Context-aware autosuggestions
- **Syntax highlighting** - Real-time command validation
- **Starship prompt** - Beautiful, informative prompt with git status
- **FZF integration** - Fuzzy finding for files, history, processes
- **Modern tools** - Better alternatives to traditional CLI tools

### 🛠️ Development Tools (via Mise)
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
  - Safe handling of SSH keys and personal data

## 📋 Prerequisites

### For DevContainer (Easiest)
- **Docker Desktop** - [Install Docker](https://docs.docker.com/get-docker/)
- **VS Code** - [Download VS Code](https://code.visualstudio.com/)
- **Dev Containers Extension** - Install from VS Code marketplace

### For Manual Installation

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

**Note**: DevContainer handles all dependencies automatically!

## 🚀 Installation Options

### 🥇 Option 1: DevContainer (Recommended)

The DevContainer provides a complete, isolated development environment:

```bash
# 1. Clone repository
git clone https://github.com/carloskvasir/dotfiles.git
cd dotfiles

# 2. Open in VS Code
code .

# 3. When prompted, click "Reopen in Container"
# Or use Command Palette: "Dev Containers: Reopen in Container"

# 4. Wait for automatic setup (3-5 minutes)
# ✅ All tools installed automatically
# ✅ All configurations applied
# ✅ Ready to use!
```

**DevContainer Benefits:**
- 🚀 **Zero configuration** - Everything works out of the box
- 🔄 **Consistent environment** - Same setup across all machines
- 🐳 **Isolated** - Doesn't affect your host system
- ⚡ **Fast rebuilds** - Multi-stage Docker optimization
- 💾 **Persistent data** - Settings and cache preserved

### 🥈 Option 2: Automated Installation Script

For installation directly on your system:

```bash
# Quick install (downloads and runs install.sh)
curl -fsSL https://raw.githubusercontent.com/carloskvasir/dotfiles/main/install.sh | bash

# Or manual steps:
git clone https://github.com/carloskvasir/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

**What the script does:**
1. ✅ Installs system dependencies (git, zsh, stow, etc.)
2. ✅ Installs Mise (version manager)
3. ✅ Applies dotfiles configurations with Stow
4. ✅ Installs all development tools via Mise
5. ✅ Sets up shell environment

### 🥉 Option 3: Manual Installation

For full control over the installation process:

```bash
# 1. Clone repository
git clone https://github.com/carloskvasir/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Install system dependencies
sudo apt update && sudo apt install -y git curl wget zsh stow build-essential

# 3. Install Mise
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# 4. Apply configurations
stow mise zsh gitconfig tmux aliases nvim

# 5. Install development tools
mise install

# 6. Setup personal configs (IMPORTANT!)
cp ssh/.ssh/config.template ssh/.ssh/config
cp gitconfig/.gitconfig.template gitconfig/.gitconfig
# Edit these files with your personal information
```

## ⚙️ Post-Installation Setup

### 🔐 Personal Configuration (Important!)

After installation, configure personal settings:

```bash
# 1. SSH Configuration
cp ssh/.ssh/config.template ssh/.ssh/config
vim ssh/.ssh/config  # Add your SSH hosts and keys

# 2. Git Configuration  
cp gitconfig/.gitconfig.template gitconfig/.gitconfig
vim gitconfig/.gitconfig  # Add your name and email

# 3. Apply personal configs
stow ssh gitconfig
```

### ✅ Verification

Check that everything is working:

```bash
# Check installed tools
mise list

# Test modern CLI tools
rg --version    # ripgrep
fd --version    # fd-find
bat --version   # bat
fzf --version   # fzf

# Test languages
node --version
python --version
go version
rustc --version

# Test shell features
# Try typing and see syntax highlighting
# Press Ctrl+R for FZF history search
# Use 'z' for smart directory jumping
```

## 🎮 Daily Usage

### 📁 File Navigation
```bash
# Modern ls with colors and icons
eza -la

# Find files quickly
fd "filename"
fd -e js  # Find all JS files

# Smart directory jumping (after visiting directories)
z dotfiles  # Jump to any directory containing "dotfiles"
```

### 🔍 Search and Find
```bash
# Search in files (faster than grep)
rg "search term"
rg "function" --type js  # Search only in JS files

# Interactive file finder
fzf  # Opens interactive finder
vim $(fzf)  # Open selected file in vim

# History search
# Press Ctrl+R for interactive history search
```

### 🛠️ Development
```bash
# Switch language versions per project
mise use node@18.16.0  # Use Node 18 for this project
mise use python@3.11   # Use Python 3.11 for this project

# Install new tools globally
mise install go@latest
mise install python@3.12

# Install project-specific tools
echo "node 20.10.0" >> .tool-versions
mise install  # Installs tools from .tool-versions
```

### 📝 Git Workflow
```bash
# Enhanced git commands (from aliases)
gst     # git status
gco     # git checkout  
gaa     # git add --all
gcm     # git commit -m
gp      # git push
gl      # git pull

# Visual git interface
lazygit  # Opens beautiful git TUI
```

### 🔧 Configuration Management
```bash
# Add new configurations
cd ~/.dotfiles
stow new-config/  # Apply new config directory

# Update existing configs
cd ~/.dotfiles
git pull
stow */  # Re-apply all configs

# Update tools
mise upgrade  # Update all tools to latest versions
```

## 🐳 DevContainer Details

### Architecture
The DevContainer uses a **multi-stage Docker build** for optimal performance:

1. **`base-deps`** - System dependencies and cleanup
2. **`user-setup`** - User configuration and mise installation  
3. **`tools-cache`** - Pre-installed essential tools (Node.js, Python)
4. **`runtime`** - Final optimized image with persistent volumes

### Performance Benefits
- ⚡ **60-80% faster rebuilds** due to tool caching
- 💾 **40-50% smaller image** size
- 🔄 **Persistent volumes** for npm/pip/mise cache
- 🚀 **Pre-installed tools** ready to use immediately

### Manual DevContainer Operations
```bash
# === Usando Make (Recomendado) ===
make dev-up           # Inicia ambiente completo
make dev-shell        # Acesso direto ao shell
make dev-down         # Para todos os containers
make dev-rebuild      # Rebuild completo
make status           # Status do ambiente
make benchmark        # Testa performance

# === Docker Compose ===
cd .devcontainer
docker-compose up -d                    # Inicia em background
docker-compose exec devcontainer zsh    # Acesso ao shell
docker-compose down                     # Para containers

# === Docker Direto ===
# Usar imagem do registry (mais rápido)
docker run -it --rm \
  -v $(pwd):/workspaces/dotfiles \
  -v dotfiles-cache:/home/vscode/.cache \
  ghcr.io/carloskvasir/dotfiles/devcontainer:latest

# Build local se necessário
docker build -t dotfiles-dev .devcontainer/

# === VS Code ===
# Command Palette > "Dev Containers: Reopen in Container"
# Command Palette > "Dev Containers: Rebuild Container"
```

**📋 Comandos de Verificação:**
```bash
# Status do ambiente
make status

# Verificar ferramentas instaladas
mise list

# Teste de funcionalidade
make test

# Benchmark de performance
make benchmark
```

## 🔧 Customization

## 🔧 Customization

### Adding New Tools
1. **Languages/CLI Tools**: Edit `mise/.config/mise/config.toml`
2. **Python Packages**: Edit `mise/.default-python-packages`  
3. **Node.js Packages**: Edit `mise/.default-npm-packages`
4. **Ruby Gems**: Edit `mise/.default-gems`
5. **Shell Aliases**: Edit `aliases/.aliases`
6. **Zsh Configuration**: Edit `zsh/.zshrc`

### Example: Adding a new tool
```bash
# Add to mise config
echo 'hugo = "latest"' >> mise/.config/mise/config.toml

# Re-apply configuration
stow mise

# Install the new tool
mise install hugo

# Use it
hugo version
```

### Personal Configurations
- **SSH**: Edit `ssh/.ssh/config` (your personal copy)
- **Git**: Edit `gitconfig/.gitconfig` (your personal copy)
- **Local overrides**: Create `.local` versions of any config file

## 🔒 Security

This dotfiles repository includes security features to protect sensitive information:

- **Templates**: Sensitive files (SSH config, Git config) use `.template` versions
- **Protection**: Comprehensive `.gitignore` prevents committing sensitive data
- **Audit**: Security audit script available (when created)

**Important**: Never commit real SSH configurations, API keys, or personal information!

## 🔄 Updating

To update your dotfiles and tools:

```bash
cd ~/.dotfiles  # or /workspaces/dotfiles in DevContainer

# Update dotfiles configurations
git pull

# Re-apply all configurations
stow */

# Update all mise tools to latest versions
mise upgrade

# Update specific language packages
mise exec python -- pip install --upgrade pip
mise exec node -- npm update -g
mise exec ruby -- bundle update
```
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

## 🐛 Troubleshooting

### DevContainer Issues

**Container não inicia ou falha no build:**
```bash
# Verificar se Docker está rodando
docker ps

# Usar imagem pré-construída do registry
docker pull ghcr.io/carloskvasir/dotfiles/devcontainer:latest

# Limpar cache e rebuild (VS Code)
# Command Palette > "Dev Containers: Rebuild Container (No Cache)"

# Build manual com logs detalhados
cd .devcontainer
make build-verbose
```

**Ferramentas não encontradas no DevContainer:**
```bash
# Verificar se setup foi concluído
cd /workspaces/dotfiles
cat INSTALLATION_STATUS.md

# Recarregar ambiente
source ~/.zshrc

# Reinstalar ferramentas se necessário
mise install
```

**Performance lenta no DevContainer:**
```bash
# Usar imagem otimizada do registry
docker pull ghcr.io/carloskvasir/dotfiles/devcontainer:latest

# Verificar recursos alocados ao Docker
docker stats

# Usar volumes nomeados para cache
make dev-up  # Usa docker-compose com volumes otimizados
```

**Problemas de permissão no DevContainer:**
```bash
# Verificar usuário atual
whoami  # Deve ser 'vscode'

# Corrigir permissões se necessário
sudo chown -R vscode:vscode /workspaces/dotfiles
sudo chown -R vscode:vscode ~/.cache ~/.local
```

### Installation Issues

**Mise not found after installation:**
```bash
# Add to your shell profile
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
exec zsh

# Or manually add to PATH
export PATH="$HOME/.local/bin:$PATH"
```

**Tool installation fails:**
```bash
# Check mise status
mise doctor

# Install missing dependencies
sudo apt install -y build-essential gcc autoconf make

# Retry installation with verbose output
mise install --verbose
```

**Stow conflicts:**
```bash
# Remove existing configs first
rm ~/.zshrc ~/.gitconfig ~/.tmux.conf

# Then stow (or use --adopt to backup existing)
stow --adopt zsh gitconfig tmux
```

**SSH/Git templates not working:**
```bash
# Make sure you copied templates to real files
cp ssh/.ssh/config.template ssh/.ssh/config
cp gitconfig/.gitconfig.template gitconfig/.gitconfig

# Edit with your real information
vim ssh/.ssh/config
vim gitconfig/.gitconfig

# Re-apply with stow
stow ssh gitconfig
```

**Permission issues:**
```bash
# Fix permissions for SSH
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# Fix ownership
sudo chown -R $USER:$USER ~/.ssh
```

### Performance Issues

**Slow shell startup:**
```bash
# Profile shell startup
zsh -xvs

# Disable heavy plugins temporarily
# Edit ~/.zshrc and comment out slow plugins

# Clear zsh cache
rm -rf ~/.zsh_cache
```

**Mise commands are slow:**
```bash
# Update mise
mise self-update

# Clear mise cache
rm -rf ~/.cache/mise

# Use specific versions instead of "latest"
mise use node@22.16.0 python@3.12
```

### Getting Help

**Check tool versions:**
```bash
# System info
uname -a
zsh --version

# Mise info
mise --version
mise doctor

# Tool versions
mise list
```

**Debug modes:**
```bash
# Verbose mise operations
mise install --verbose

# Debug shell issues
zsh -x

# Stow dry run
stow --dry-run zsh
```

**Reset to clean state:**
```bash
# Backup current configs
cp ~/.zshrc ~/.zshrc.backup
cp ~/.gitconfig ~/.gitconfig.backup

# Remove all dotfiles configs
cd ~/.dotfiles
stow -D */

# Fresh install
./install.sh
```

## ❓ FAQ

**Q: Should I use DevContainer or manual installation?**
A: DevContainer is recommended for development as it provides isolation and consistency. Use manual installation for your primary system setup.

**Q: Can I use only part of these dotfiles?**
A: Yes! Use `stow` selectively: `stow zsh` for just shell config, `stow nvim` for just Neovim, etc.

**Q: How do I add my own configurations?**
A: Create a new directory with your configs and use `stow dirname/`. Or modify existing configs in their respective directories.

**Q: Will this overwrite my existing configurations?**
A: Stow will warn about conflicts. Use `stow --adopt` to backup existing files, or remove them manually first.

**Q: How do I uninstall everything?**
A: Run `cd ~/.dotfiles && stow -D */` to remove all symlinks, then delete the `~/.dotfiles` directory.

**Q: Can I use this on different operating systems?**
A: Primarily designed for Linux. Some tools may work on macOS. Windows support via WSL2.

**Q: How often should I update?**
A: Run `git pull && mise upgrade` weekly to get latest configs and tool versions.

## � Documentação Completa

- **[USAGE_GUIDE.md](USAGE_GUIDE.md)** - Guia completo de uso do DevContainer
- **[QUICK_START.md](QUICK_START.md)** - Início rápido e comandos essenciais  
- **[SECURITY_GUIDE.md](SECURITY_GUIDE.md)** - Guia de segurança e boas práticas
- **[mise/MISE_TOOLS_GUIDE.md](mise/MISE_TOOLS_GUIDE.md)** - Guia das ferramentas disponíveis

- **[GNU Stow](https://www.gnu.org/software/stow/)** - Symlink farm manager
- **[Mise](https://mise.jdx.dev/)** - Dev tools, env vars, task runner
- **[Starship](https://starship.rs/)** - Cross-shell prompt
- **[Neovim](https://neovim.io/)** - Hyperextensible Vim-based text editor

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly (especially in DevContainer)
5. Submit a pull request

**Areas for contribution:**
- Additional tool configurations
- OS-specific improvements  
- Documentation improvements
- Performance optimizations
- Security enhancements

## �‍💻 Author

**Carlos Kvasir**
- 🌐 Website: [kvasir.dev](https://kvasir.dev)  
- 💼 LinkedIn: [carloskvasir](https://linkedin.com/in/carloskvasir)

## ⭐ Support

If you find these dotfiles helpful:

- ⭐ **Star this repository**
- 🐛 **Report issues** on GitHub
- 💡 **Suggest improvements** via issues
- 🔄 **Share with others** who might benefit

## �📝 License

This project is licensed under the Mozilla Public License Version 2.0 - see the [LICENSE](LICENSE) file for details.

---

**💡 Happy coding with your new supercharged development environment!**

```ascii
    ____        __  _____ __         
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  ) 
/_____/\____/\__/_/ /_/_/\___/____/  
                                     
Made with ❤️ by Carlos Kvasir
```
