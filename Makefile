.PHONY: all install update stow-nvim stow-zsh stow-git stow-all unstow-all

all: install

install: install-stow stow-all
	@echo "Installation complete with GNU Stow!"

install-stow:
	@echo "Installing GNU Stow..."
	@if ! command -v stow >/dev/null 2>&1; then \
		sudo apt update && sudo apt install -y stow; \
	fi

update:
	git pull origin main
	@echo "Configurations updated!"

stow-all: stow-nvim stow-zsh stow-git stow-tmux stow-aliases
	@echo "All configurations applied with Stow!"

stow-nvim:
	@echo "Applying Neovim configuration..."
	stow nvim

stow-zsh:
	@echo "Applying Zsh configuration..."
	stow zsh

stow-git:
	@echo "Applying Git configuration..."
	stow gitconfig

stow-tmux:
	@echo "Applying Tmux configuration..."
	stow tmux

stow-aliases:
	@echo "Applying aliases..."
	stow aliases

unstow-all:
	@echo "Removing all configurations..."
	@if [ -d nvim ]; then stow -D nvim; fi
	@if [ -d zsh ]; then stow -D zsh; fi
	@if [ -d gitconfig ]; then stow -D gitconfig; fi
	@if [ -d tmux ]; then stow -D tmux; fi
	@if [ -d aliases ]; then stow -D aliases; fi

clean: unstow-all
