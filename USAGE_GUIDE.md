# 🎮 Daily Usage Commands

Quick reference for your new supercharged development environment.

## 📁 File Navigation

```bash
# Modern directory listing (replaces ls)
eza              # Basic listing
eza -la          # Detailed listing with hidden files  
eza -T           # Tree view
eza -la --git    # Show git status

# Smart directory jumping (after visiting directories)
z dotfiles       # Jump to any directory containing "dotfiles"
z doc            # Jump to any directory containing "doc"
zi               # Interactive directory picker

# Find files and directories
fd "filename"    # Find files by name
fd -e js         # Find all JavaScript files
fd -t d config   # Find directories containing "config"
```

## 🔍 Search and Find

```bash
# Search in files (faster than grep)
rg "search term"                 # Basic search
rg "function" --type js         # Search only in JS files
rg "TODO" -A 3 -B 3            # Show 3 lines before/after
rg "error" -i                  # Case-insensitive search

# Interactive file finder
fzf                            # Opens interactive finder
vim $(fzf)                     # Open selected file in vim
cat $(fzf)                     # View selected file content

# History and process search
history | fzf                  # Search command history
ps aux | fzf                   # Search running processes
```

## 🛠️ Development Tools

```bash
# Version management with Mise
mise list                      # Show installed tools
mise install node@20.10.0     # Install specific version
mise use node@18.16.0         # Use version for current project
mise use --global python@3.12 # Set global default

# Language-specific commands
mise exec node -- npm install    # Run npm with specific Node version
mise exec python -- pip list     # Run pip with specific Python version
mise exec go -- go mod tidy      # Run go with specific Go version

# Development shortcuts
mise run test                  # Run project test task (if defined)
mise run dev                   # Run development server (if defined)
mise tasks                     # List available tasks
```

## 📝 Git Workflow (Enhanced Aliases)

```bash
# Status and information
gst              # git status (short)
glog             # git log with graph
gsh              # git show
gd               # git diff
gds              # git diff --staged

# Branch operations
gco main         # git checkout main
gcb feature      # git checkout -b feature
gb               # git branch
gba              # git branch -a (all branches)

# Staging and committing
ga .             # git add .
gaa              # git add --all
gc               # git commit
gcm "message"    # git commit -m "message"
gca              # git commit --amend

# Push/pull operations
gp               # git push
gpl              # git pull
gpf              # git push --force-with-lease
gup              # git pull --rebase

# Advanced operations
grb              # git rebase
grbc             # git rebase --continue
grba             # git rebase --abort
gsta             # git stash
gstp             # git stash pop

# Visual git interface
lazygit          # Opens beautiful git TUI
```

## 💻 System and Process Management

```bash
# System monitoring (better than htop)
btm              # bottom - modern system monitor
btm --basic      # bottom with basic theme

# Disk usage (better than du)
dust             # Show disk usage tree
dust -d 2        # Limit depth to 2 levels

# File viewing (better than cat)
bat filename.js  # View file with syntax highlighting
bat -n file.py   # View with line numbers
bat -A file.txt  # Show all characters (including whitespace)

# Process management
ps aux | rg firefox    # Find Firefox processes
kill $(ps aux | fzf | awk '{print $2}')  # Interactive process killer
```

## 🐚 Shell Features

```bash
# History
!!               # Repeat last command
!n               # Repeat command number n from history
!string          # Repeat last command starting with string
Ctrl+R           # Interactive history search with FZF

# Directory shortcuts
..               # cd ..
...              # cd ../..
....             # cd ../../..
-                # cd to previous directory

# Quick edits
alias            # Show all aliases
which command    # Show command location
type command     # Show command type and definition
```

## 🔧 Configuration Management

```bash
# Dotfiles management
cd ~/.dotfiles   # Go to dotfiles directory
gpl              # Pull latest changes
stow */          # Re-apply all configurations
stow zsh         # Apply only zsh configuration

# Update tools
mise upgrade     # Update all tools to latest
mise prune       # Remove unused tool versions
mise doctor      # Check mise installation

# Shell reload
exec zsh         # Reload shell completely
source ~/.zshrc  # Reload zsh configuration
```

## 🔍 Information and Help

```bash
# Tool information
command --version     # Check version of any tool
command --help       # Get help for any tool
man command          # Manual page (if available)
tldr command         # Simplified help (if tldr is installed)

# System information
uname -a            # System information
lsb_release -a      # Distribution information
df -h               # Disk space usage
free -h             # Memory usage
```

## 🎨 Customization

```bash
# Edit configurations
vim ~/.zshrc                           # Edit zsh config
vim ~/.dotfiles/aliases/.aliases      # Edit aliases
vim ~/.dotfiles/mise/.config/mise/config.toml  # Edit tool config

# Apply changes
source ~/.zshrc     # Reload zsh after editing
stow aliases        # Re-apply aliases after editing
mise install        # Install new tools after config change
```

## 💡 Pro Tips

```bash
# Combine tools for power
fd . | fzf | xargs bat              # Find file and view with syntax highlighting
rg "TODO" | fzf | cut -d: -f1 | xargs vim  # Find TODOs and edit file

# Use aliases for common patterns
alias ll='eza -la'
alias tree='eza -T'
alias grep='rg'
alias find='fd'

# Tab completion works with most commands
mise <TAB>          # Show available mise commands
git <TAB>           # Show available git commands
cd <TAB>            # Show available directories
```

---

💡 **Remember**: All these tools have excellent `--help` documentation and most support tab completion!
