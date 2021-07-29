# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansion
zplug "Tarrasch/zsh-bd", from:github
zplug "aperezdc/zsh-fzy"
zplug "buonomo/yarn-completion"
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "plugins/asdf", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "plugins/rails",   from:oh-my-zsh
zplug "agkozak/zsh-z"

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
    xcode         # Xcode section
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
    vi_mode       # Vi-mode indicator
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
setopt INC_APPEND_HISTORY
HISTFILE=~/.history_zsh
HISTSIZE=10000

# -- aliases from .aliases --
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

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

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# ALT-C: cd into the selected directory
# CTRL-T: Place the selected file path in the command line
# CTRL-R: Place the selected command from history in the command line
# CTRL-P: Place the selected process ID in the command line
bindkey '\ec' fzy-cd-widget
bindkey '^T'  fzy-file-widget
bindkey '^R'  fzy-history-widget
bindkey '^P'  fzy-proc-widget

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
source /home/carlos/.asdf/installs/rust/1.46.0/env
export PATH="$PATH:${GOPATH//://bin:}/bin"
