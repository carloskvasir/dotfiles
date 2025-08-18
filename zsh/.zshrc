# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# Zsh completion system configuration
autoload -Uz compinit
compinit

# Enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Improve completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'

# Rails-specific completion improvements
zstyle ':completion:*:*:rails:*' file-patterns '*.rb:ruby-files *(-/):directories'
zstyle ':completion:*:*:rake:*' file-patterns 'Rakefile:rakefiles *.rake:rake-tasks *(-/):directories'

# Custom Key Bindings for Zsh Interactive Features
bindkey '^R' fzf-history-widget  # Use fzf for interactive command history
bindkey '^[[Z' autosuggest-accept  # Accept suggestion using Shift + Tab (if desired)


# Make sure to use double quotes to prevent shell expansion
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/rails", from:oh-my-zsh
zplug "plugins/copypath", from:oh-my-zsh
zplug "plugins/copydir", from:oh-my-zsh
zplug "plugins/copybuffer", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "docker/compose", from:github
zplug "plugins/docker", from:oh-my-zsh
#zplug "plugins/podman", from:oh-my-zsh
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2


# spaceship-prompt config
SPACESHIP_PROMPT_ORDER=(
    venv          # virtualenv section
    user          # Username section
    dir           # Current directory section
    host          # Hostname section
    git           # Git section (git_branch + git_status)
    hg            # Mercurial section (hg_branch  + hg_status)
    node          # Node.js section
    ruby          # Ruby section
    elixir        # Elixir section
    swift         # Swift section
    golang        # Go section
    php           # PHP section
    rust          # Rust section
    haskell       # Haskell Stack section
    julia         # Julia section
    docker        # Docker section
    aws           # Amazon Web Services section
    gcloud        # Google Cloud Platform section
    dotnet        # .NET section
    exec_time     # Execution time
    line_sep      # Line break
    jobs          # Background jobs indicator
    exit_code     # Exit code section
    char          # Prompt character
)
SPACESHIP_USER_SHOW=false
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="->"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_DIR_TRUNC=8
SPACESHIP_DIR_TRUNC_PREFIX='.../'
SPACESHIP_PROMPT_DEFAULT_PREFIX="| "

##############################################################################
# History Configuration
##############################################################################
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

##############################################################################
# Enhanced Clipboard Configuration
##############################################################################

# Enhanced clipboard functionality with fallback options
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check if xclip is available, fallback to xsel
    if command -v xclip >/dev/null 2>&1; then
        export CLIPBOARD_COPY="xclip -selection clipboard"
        export CLIPBOARD_PASTE="xclip -selection clipboard -o"
    elif command -v xsel >/dev/null 2>&1; then
        export CLIPBOARD_COPY="xsel --clipboard --input"
        export CLIPBOARD_PASTE="xsel --clipboard --output"
    elif command -v wl-copy >/dev/null 2>&1; then
        export CLIPBOARD_COPY="wl-copy"
        export CLIPBOARD_PASTE="wl-paste"
    else
        echo "Warning: No clipboard utility found. Please install xclip, xsel, or wl-clipboard."
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export CLIPBOARD_COPY="pbcopy"
    export CLIPBOARD_PASTE="pbpaste"
fi

# Custom clipboard functions
copy() {
    if [[ $# -eq 0 ]]; then
        # Copy from stdin
        pbcopy
    else
        # Copy text from arguments
        echo -n "$*" | pbcopy
        echo "✓ Copied to clipboard: $*"
    fi
}

paste() {
    pbpaste
}

# Copy command output and result
copyout() {
    local last_command=$(fc -ln -1 | sed 's/^[[:space:]]*//')
    echo -n "$last_command" | pbcopy
    echo "✓ Last command copied to clipboard: $last_command"
}

# Copy current working directory
alias cpwd='pwd | pbcopy && echo "✓ Current directory copied to clipboard: $(pwd)"'

# Copy file contents
copycat() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: copycat <file>"
        return 1
    fi
    
    if [[ -f "$1" ]]; then
        cat "$1" | pbcopy
        echo "✓ Contents of $1 copied to clipboard"
    else
        echo "✗ File not found: $1"
        return 1
    fi
}

# Git-related copy functions
if command -v git >/dev/null 2>&1; then
    # Copy git commit hash
    cpcommit() {
        if git rev-parse --git-dir > /dev/null 2>&1; then
            local commit_hash=$(git rev-parse HEAD)
            echo -n "$commit_hash" | pbcopy
            echo "✓ Git commit hash copied to clipboard: $commit_hash"
        else
            echo "✗ Not in a git repository"
            return 1
        fi
    }
    
    # Copy git branch name
    cpbranch() {
        if git rev-parse --git-dir > /dev/null 2>&1; then
            local branch_name=$(git branch --show-current)
            if [[ -n "$branch_name" ]]; then
                echo -n "$branch_name" | pbcopy
                echo "✓ Git branch name copied to clipboard: $branch_name"
            else
                echo "✗ No current branch found"
                return 1
            fi
        else
            echo "✗ Not in a git repository"
            return 1
        fi
    }
    
    # Copy git remote URL
    cpremote() {
        if git rev-parse --git-dir > /dev/null 2>&1; then
            local remote_url=$(git config --get remote.origin.url)
            if [[ -n "$remote_url" ]]; then
                echo -n "$remote_url" | pbcopy
                echo "✓ Git remote URL copied to clipboard: $remote_url"
            else
                echo "✗ No remote origin found"
                return 1
            fi
        else
            echo "✗ Not in a git repository"
            return 1
        fi
    }
fi

# Network-related copy functions
if command -v curl >/dev/null 2>&1; then
    # Copy public IP address
    cpip() {
        local ip=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)
        if [[ -n "$ip" ]]; then
            echo -n "$ip" | pbcopy
            echo "✓ Public IP copied to clipboard: $ip"
        else
            echo "✗ Failed to get public IP address"
            return 1
        fi
    }
fi

# Copy SSH public key
cpssh() {
    local ssh_key_file="${1:-$HOME/.ssh/id_rsa.pub}"
    if [[ -f "$ssh_key_file" ]]; then
        cat "$ssh_key_file" | pbcopy
        echo "✓ SSH public key copied to clipboard from: $ssh_key_file"
    else
        echo "✗ SSH public key not found at: $ssh_key_file"
        echo "Available SSH keys:"
        ls -la ~/.ssh/*.pub 2>/dev/null || echo "No SSH public keys found"
        return 1
    fi
}

# Copy Rails-specific information
if command -v rails >/dev/null 2>&1; then
    # Copy Rails routes for current model/controller
    cproutes() {
        if [[ -f "config/routes.rb" ]]; then
            if [[ $# -eq 0 ]]; then
                rails routes | pbcopy
                echo "✓ All Rails routes copied to clipboard"
            else
                rails routes | grep -i "$1" | pbcopy
                echo "✓ Rails routes for '$1' copied to clipboard"
            fi
        else
            echo "✗ Not in a Rails application directory"
            return 1
        fi
    }
    
    # Copy Rails model schema
    cpschema() {
        if [[ $# -eq 0 ]]; then
            echo "Usage: cpschema <model_name>"
            return 1
        fi
        
        if [[ -f "db/schema.rb" ]]; then
            grep -A 20 "create_table.*$1" db/schema.rb | pbcopy
            echo "✓ Schema for '$1' copied to clipboard"
        else
            echo "✗ Schema file not found"
            return 1
        fi
    }
fi

# Copy system information
cpsysinfo() {
    local sysinfo="System: $(uname -a)\nHost: $(hostname)\nUser: $(whoami)\nShell: $SHELL\nPWD: $(pwd)"
    echo -e "$sysinfo" | pbcopy
    echo "✓ System information copied to clipboard"
}

# Smart copy function that detects content type
smartcopy() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: smartcopy <file_or_text>"
        return 1
    fi
    
    if [[ -f "$1" ]]; then
        # It's a file
        copycat "$1"
    elif [[ -d "$1" ]]; then
        # It's a directory
        echo -n "$1" | pbcopy
        echo "✓ Directory path copied to clipboard: $1"
    else
        # It's text
        copy "$*"
    fi
}

# Clipboard history (simple implementation)
clipboard_history=()
clipboard_max_history=10

_save_to_clipboard_history() {
    if [[ ${#clipboard_history[@]} -ge $clipboard_max_history ]]; then
        clipboard_history=("${clipboard_history[@]:1}")
    fi
    clipboard_history+=("$1")
}

# Enhanced copy with history
copyh() {
    if [[ $# -eq 0 ]]; then
        # Show clipboard history
        echo "Clipboard History:"
        for i in {1..${#clipboard_history[@]}}; do
            echo "$i: ${clipboard_history[$i]}"
        done
    else
        copy "$*"
        _save_to_clipboard_history "$*"
    fi
}

# Key bindings for clipboard operations
# Ctrl+X, Ctrl+C to copy current command line
bindkey -s '^X^C' 'echo -n $BUFFER | pbcopy\n'
# Ctrl+X, Ctrl+V to paste from clipboard  
bindkey -s '^X^V' '$(pbpaste)'

# Rails completion enhancements
# Enable Rails command completion
if command -v rails > /dev/null 2>&1; then
    # Add Rails generators to completion
    _rails_generators() {
        local generators
        generators=($(rails generate --help | grep -E '^\s+[a-z_]+:' | cut -d':' -f1 | tr -d ' '))
        _describe 'generators' generators
    }
    
    # Custom completion for rails generate
    compdef '_arguments "1:generator:_rails_generators" "*:file:_files"' rails
fi

# Enable Rake task completion
if command -v rake > /dev/null 2>&1; then
    # Cache rake tasks for faster completion
    _rake_refresh_cache() {
        if [[ -f Rakefile ]] && [[ ! -f .rake_tasks ]] || [[ Rakefile -nt .rake_tasks ]]; then
            rake --tasks --silent | cut -d' ' -f2 > .rake_tasks
        fi
    }
    
    _rake_tasks() {
        _rake_refresh_cache
        if [[ -f .rake_tasks ]]; then
            _describe 'rake tasks' $(cat .rake_tasks)
        fi
    }
    
    compdef _rake_tasks rake
fi

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# -- aliases from .aliases --
[ -f ~/.aliases ] && source ~/.aliases

# Fzf integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

##############################################################################
# FZF Configuration
##############################################################################

# FZF default options
export FZF_DEFAULT_OPTS="
    --height 80%
    --layout=reverse
    --border
    --margin=1
    --padding=1
    --info=inline
    --prompt='🔍 '
    --pointer='▶'
    --marker='✓'
    --bind='?:toggle-preview'
    --bind='ctrl-a:select-all'
    --bind='ctrl-space:deselect-all'
    --bind='ctrl-/:toggle-preview'
    --bind='ctrl-u:preview-up'
    --bind='ctrl-j:preview-down'
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
"

# History search specific options
export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --preview-window=down:3:wrap
    --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --bind='ctrl-x:execute(echo {2..} | pbcopy)'
    --header='📚 HISTORY | Ctrl+Y: Copy | Ctrl+X: Copy+Keep | Ctrl+R: Sort | ?: Preview'
"

# File search options
export FZF_CTRL_T_OPTS="
    --preview 'bat --style=numbers --color=always --line-range :500 {}'
    --bind='ctrl-/:change-preview-window(down|hidden|)'
    --header='📁 FILES | Ctrl+/: Toggle Preview | Enter: Select'
"

# Directory search options  
export FZF_ALT_C_OPTS="
    --preview 'eza --tree --level=2 --color=always {} 2>/dev/null || tree -C {} | head -200 2>/dev/null || ls -la {}'
    --bind='ctrl-/:change-preview-window(down|hidden|)'
    --bind='ctrl-h:reload(\$FZF_ALT_C_COMMAND --hidden)'
    --header='📂 DIRECTORIES | Alt+C: Select | Ctrl+/: Preview | Ctrl+H: Show Hidden'
"

# Use fd/fdfind for better file search if available
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --follow --exclude .git'
elif command -v fdfind >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix --follow --exclude .git'
else
    # Fallback para find (sem arquivos/diretórios ocultos por padrão)
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.*" 2>/dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='find . -type d -not -path "*/\.*" 2>/dev/null'
fi

# Git branch selector with FZF (melhor que o padrão)
fzf-git-branch() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    local branch
    branch=$(git branch --all --format='%(refname:short)' | 
             grep -v HEAD | 
             sed 's/origin\///' | 
             sort -u | 
             fzf --prompt='🌿 Git Branch: ' \
                 --preview='git log --oneline --graph --color=always --max-count=10 {}' \
                 --preview-window='right:60%' \
                 --header='Select branch to checkout')
    
    if [[ -n "$branch" ]]; then
        git checkout "$branch"
    fi
    zle reset-prompt
}
zle -N fzf-git-branch

# Process killer with FZF (útil para desenvolvimento)
fzf-kill() {
    local pid
    pid=$(ps -eo pid,ppid,user,comm --no-headers | 
          fzf -m --header='🔪 Select process to kill' \
              --preview='ps -p {1} -o pid,ppid,user,comm,cmd' \
              --preview-window='down:3' | 
          awk '{print $1}')
    
    if [[ -n "$pid" ]]; then
        echo "Killing process(es): $pid"
        echo $pid | xargs kill -${1:-15}  # SIGTERM por padrão, mais gentil que SIGKILL
    fi
}

# Enhanced key bindings
bindkey '^G^B' fzf-git-branch  # Ctrl+G, Ctrl+B for git branch selection
bindkey '^P' fzf-kill          # Ctrl+P for process killer

# Additional useful bindings for IDE compatibility
if [[ -n "$INSIDE_EMACS" ]] || [[ -n "$VSCODE_PID" ]] || [[ -n "$INTELLIJ_ENVIRONMENT_READER" ]]; then
    # IDE-specific optimizations
    unsetopt SHARE_HISTORY
    setopt INC_APPEND_HISTORY
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --height=40%"
fi

# Tmux integration improvements
if [[ -n "$TMUX" ]]; then
    # Tmux-specific FZF optimizations
    export FZF_TMUX=1
    export FZF_TMUX_HEIGHT=40%
    
    # Tmux session management
    tm() {
        if [[ $# -eq 0 ]]; then
            tmux list-sessions 2>/dev/null | fzf --prompt="📺 Tmux Sessions: " | cut -d: -f1 | xargs tmux attach-session -t
        else
            tmux attach-session -t "$1" 2>/dev/null || tmux new-session -s "$1"
        fi
    }
    
    # Tmux window navigation
    tw() {
        tmux list-windows -F "#{window_index}: #{window_name}" | fzf --prompt="🪟 Tmux Windows: " | cut -d: -f1 | xargs tmux select-window -t
    }
fi

# CONFIG MISE IN ZSH
eval "$(mise activate zsh)"

##############################################################################
# Modern CLI Tools Aliases (installed via mise)
##############################################################################

# # Modern replacements for traditional commands
# if command -v eza >/dev/null 2>&1; then
#     alias ls='eza --icons --group-directories-first'
#     alias ll='eza -l --icons --group-directories-first --time-style=relative'
#     alias la='eza -la --icons --group-directories-first --time-style=relative'
#     alias lt='eza --tree --level=2 --icons'
#     alias lta='eza --tree --level=3 --icons --all'
# fi

if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=plain --paging=never'
    alias ccat='bat --style=full'  # colored cat with line numbers
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

if command -v fd >/dev/null 2>&1; then
    alias find='fd'
fi

if command -v dust >/dev/null 2>&1; then
    alias du='dust'
fi

if command -v bottom >/dev/null 2>&1; then
    alias htop='btm'
    alias top='btm'
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

if command -v delta >/dev/null 2>&1; then
    export GIT_PAGER='delta'
fi

# FZF integration with modern tools
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
fi

# Rails-specific autocompletion improvements
# Function to get Rails commands dynamically
_rails_commands() {
    if [[ -f bin/rails ]] || [[ -f script/rails ]] || command -v rails > /dev/null 2>&1; then
        local commands
        commands=(
            'console:Start the Rails console'
            'server:Start the Rails server'
            'generate:Generate Rails code'
            'destroy:Destroy generated Rails code'
            'dbconsole:Start database console'
            'new:Create a new Rails application'
            'plugin:Rails plugin manager'
            'runner:Run Ruby code in Rails environment'
            'test:Run tests'
            'version:Show Rails version'
            'routes:Show all routes'
            'middleware:Show middleware stack'
            'stats:Show code statistics'
            'notes:Show code annotations'
            'about:Show Rails environment info'
        )
        _describe 'Rails commands' commands
    fi
}

# Enhanced Rails completion
compdef '_arguments "1:command:_rails_commands" "*:file:_files"' rails

# Bundle completion enhancement
if command -v bundle > /dev/null 2>&1; then
    compdef '_arguments "1:command:(install update exec check outdated show gem help version list add remove)" "*:gem:_files"' bundle
fi

# Git completion for Rails projects (common git commands in Rails workflow)
if command -v git > /dev/null 2>&1; then
    # Add common Rails git workflow aliases
    alias gpr='git pull --rebase'
    alias gpsup='git push --set-upstream origin $(git symbolic-ref --short HEAD)'
    alias gcmsg='git commit -m'
    alias gst='git status'
    alias gaa='git add --all'
fi

##############################################################################
# Rails Development Enhancements
##############################################################################

# Rails project detection and auto-setup
rails-setup() {
    if [[ -f "Gemfile" ]] && [[ -f "config/application.rb" ]]; then
        echo "🚀 Rails project detected!"
        
        # Auto-setup common directories
        mkdir -p tmp/cache tmp/pids tmp/sockets log
        
        # Show useful project info
        echo "📊 Project Info:"
        [[ -f "config/database.yml" ]] && echo "  Database: $(grep 'adapter:' config/database.yml | head -1 | cut -d':' -f2 | tr -d ' ')"
        [[ -f "Gemfile" ]] && echo "  Ruby: $(grep 'ruby ' Gemfile | cut -d"'" -f2)"
        [[ -f ".ruby-version" ]] && echo "  Ruby Version: $(cat .ruby-version)"
        
        # Quick commands reminder
        echo "🔧 Quick Commands:"
        echo "  rails s     - Start server"
        echo "  rails c     - Console"
        echo "  rails routes - Show routes"
        echo "  cproutes    - Copy routes to clipboard"
    else
        echo "❌ Not a Rails project directory"
    fi
}

# Rails log tail function
rails-logs() {
    local env="${1:-development}"
    if [[ -f "log/${env}.log" ]]; then
        tail -f "log/${env}.log"
    else
        echo "❌ Log file log/${env}.log not found"
        echo "Available logs:"
        ls -la log/*.log 2>/dev/null || echo "No log files found"
    fi
}

# Rails database shortcuts
alias rails-db-reset='rails db:drop db:create db:migrate db:seed'
alias rails-db-fresh='rails db:drop db:create db:schema:load db:seed'

# Rails testing shortcuts
alias rails-test='rails test'
alias rails-spec='rspec'
alias rails-test-models='rails test test/models'
alias rails-test-controllers='rails test test/controllers'

# Auto-cd to Rails root when in subdirectory
rails-root() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/config/application.rb" ]]; then
            cd "$dir"
            echo "📍 Moved to Rails root: $dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    echo "❌ Not in a Rails project"
    return 1
}

# Quick Rails server with auto-detection
rails-server() {
    if [[ -f "bin/rails" ]]; then
        echo "🚀 Starting Rails server..."
        bin/rails server "$@"
    elif [[ -f "script/rails" ]]; then
        echo "🚀 Starting Rails server (legacy)..."
        script/rails server "$@"
    elif command -v rails >/dev/null 2>&1; then
        echo "🚀 Starting Rails server (global)..."
        rails server "$@"
    else
        echo "❌ Rails not found"
        return 1
    fi
}

alias rs='rails-server'

# Quick help function to show available custom commands
zsh-help() {
    echo "🚀 CUSTOM ZSH COMMANDS AVAILABLE:"
    echo ""
    echo "📋 CLIPBOARD:"
    echo "  copy 'text'         - Copy text to clipboard"
    echo "  copyout             - Copy last command"
    echo "  cpwd                - Copy current directory"
    echo "  copycat file        - Copy file contents"
    echo "  cpcommit            - Copy git commit hash"
    echo "  cpbranch            - Copy git branch name"
    echo "  cpremote            - Copy git remote URL"
    echo "  cpip                - Copy public IP"
    echo "  cpssh [file]        - Copy SSH public key"
    echo ""
    echo "🔍 SEARCH & NAVIGATION:"
    echo "  Ctrl+R              - FZF history search"
    echo "  Ctrl+T              - FZF file search"
    echo "  Alt+C               - FZF directory search"
    echo "  Ctrl+G,Ctrl+B       - FZF git branch selector"
    echo ""
    echo "📺 TMUX (when in tmux):"
    echo "  tm [session]        - Tmux session manager"
    echo "  tw                  - Tmux window selector"
    echo ""
    echo "🌿 GIT:"
    echo "  gst, gaa, gcmsg     - Git status, add all, commit"
    echo "  gpr, gpsup          - Git pull rebase, push upstream"
    echo ""
    echo "🚀 RAILS:"
    echo "  cproutes [filter]   - Copy Rails routes"
    echo "  cpschema model      - Copy model schema"
    echo ""
    echo "🔧 SYSTEM:"
    echo "  Ctrl+P              - Process killer with FZF"
    echo "  smartcopy item      - Smart copy (auto-detect type)"
    echo ""
    echo "📚 For full documentation: cat ~/.dotfiles/zsh/BEST_ZSH_COMMANDS.md"
}
