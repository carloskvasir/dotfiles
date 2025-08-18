# Dotfiles with GNU Stow

This repository contains my personal configurations organized for use with GNU Stow.

## Tools Installed

- **Via APT**: git, curl, wget, zsh, stow
- **Via Mise**: neovim, tmux (latest versions)
- **Optional**: Oh My Zsh

## Quick Installation

```bash
git clone https://github.com/carloskvasir/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

## Available Commands

- `make install` - Install GNU Stow and apply all configurations
- `make update` - Update repository
- `make stow-all` - Apply all configurations with Stow
- `make stow-nvim` - Apply only Neovim configuration
- `make stow-zsh` - Apply only Zsh configuration
- `make unstow-all` - Remove all configurations
- `make clean` - Remove all configurations (alias for unstow-all)

## Structure

The repository is organized to work with GNU Stow:

```
dotfiles/
├── nvim/           # Neovim configurations
├── zsh/            # Zsh configurations
├── gitconfig/      # Git configurations
├── tmux/           # Tmux configurations
├── aliases/        # Custom aliases
└── Makefile        # Installation automation
```

## DevContainer/Codespaces

For use with DevContainer or GitHub Codespaces, the repository already includes automatic configuration that:

1. Installs GNU Stow and dependencies
2. Clones this repository
3. Runs `make install` automatically

## How Stow Works

GNU Stow creates symlinks automatically. For example:
- `nvim/.config/nvim/` → `~/.config/nvim/`
- `zsh/.zshrc` → `~/.zshrc`
- `gitconfig/.gitconfig` → `~/.gitconfig`

This allows you to keep your configurations synchronized between different machines.
