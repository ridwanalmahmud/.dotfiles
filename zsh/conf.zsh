export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions fzf-tab)

unsetopt AUTO_CD

source $ZSH/oh-my-zsh.sh
source $HOME/.cargo/env

export DISPLAY=:0
export DOTFILES="$HOME/.dotfiles"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export TYPST_FONT_PATHS="$HOME/.local/share/fonts/"

set -o vi
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

alias la="ls -lAvh --group-directories-first"
alias glog="git --no-pager log --oneline --decorate --graph --parents"
alias bat="bat --style=numbers --theme=gruvbox-dark --color=always"
alias fh='eval $(history | fzf --height=50% --layout=reverse --tac | sed "s/^[[:space:]]*[0-9]*[[:space:]]*//")'
alias vi="nvim \$(fzf --preview='bat --theme=gruvbox-dark --style=numbers --color=always {} || cat {}' --preview-window 'right:65%')"
alias vistall="nvim $DOTFILES/scripts/setup/install.sh"
alias vbuild="nvim $DOTFILES/scripts/setup/build.sh"

bindkey -s "^r" "source ~/.zshrc\n"
bindkey -s "^f" "~/.local/bin/tmux-sessionizer\n"
