# 🚀 Quick Setup Guide

Choose your preferred installation method:

## 🐳 DevContainer & CI/CD

O ambiente DevContainer pode ser usado no VS Code para configuração automática.
The container build is validated via GitHub Actions (`.github/workflows/devcontainer.yml`).

## 🥇 DevContainer (Recommended - Zero Config)

```bash
git clone https://github.com/carloskvasir/dotfiles.git
cd dotfiles
code .
# Click "Reopen in Container" when prompted
# Wait 3-5 minutes for automatic setup ✨
```

## 🥈 Automated Installation

```bash
curl -fsSL https://raw.githubusercontent.com/carloskvasir/dotfiles/main/install.sh | bash
```

## 🥉 Manual Installation

```bash
git clone https://github.com/carloskvasir/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

## ⚡ What You Get

- **Modern Shell**: Zsh + Starship + FZF + syntax highlighting
- **Development Tools**: Node.js, Python, Go, Rust, Java, and more via Mise
- **CLI Tools**: ripgrep, fd, bat, eza, delta, lazygit, and 20+ modern tools
- **Editor**: Neovim with LSP support
- **Git**: Enhanced workflow with aliases and better diff
- **Terminal**: tmux with optimized configuration

## 📖 Full Documentation

For complete documentation, customization options, and troubleshooting:
👉 **[Read the full README.md](README.md)**

---
Made with ❤️ by [Carlos Kvasir](https://kvasir.dev)
