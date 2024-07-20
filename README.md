# :spiral_notepad: dotfiles - configuration files

## :arrow_right: How use
```zsh
cd ~
git clone git@github.com:carloskvasir/dotfiles.git .dotfiles

cd .dotfiles
stow nvim
```

Install all asdf plugins and versions
```zsh
awk '{print $1}' ~/.tool-versions | xargs -I @@ asdf plugin add @@
```
```zsh
awk '{print $1}' ~/.tool-versions | xargs -I @@ asdf install @@
```

Stow create symlinks using same path of .dotfiles

Uses GNU Stow – https://www.gnu.org/software/stow/

Configs from Carlos Kvasir

