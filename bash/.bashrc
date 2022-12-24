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
source < (k completion bash)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/carlos/.google-cloud-sdk/path.bash.inc' ]; then . '/home/carlos/.google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/carlos/.google-cloud-sdk/completion.bash.inc' ]; then . '/home/carlos/.google-cloud-sdk/completion.bash.inc'; fi
#‘export PATH=”/home/carlos/.krew/bin:/home/carlos/.google-cloud-sdk/bin:/home/carlos/.asdf/installs/rust/1.46.0/bin:/home/carlos/.google-cloud-sdk/bin:/home/carlos/.yarn/bin:/home/carlos/.config/yarn/global/node_modules/.bin:/home/carlos/.asdf/shims:/home/carlos/.asdf/bin:/home/carlos/.krew/bin:/home/carlos/.zplug/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/bin”‘

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
