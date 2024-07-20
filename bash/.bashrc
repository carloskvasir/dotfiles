# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# -- aliases from .aliases --
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

. $HOME/.asdf/asdf.sh


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
