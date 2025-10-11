export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions fzf-tab)

source $ZSH/oh-my-zsh.sh
source $DOTFILES/zsh/keybinds.zsh
source $HOME/.cargo/env
source <(fzf --zsh)

set -o vi

HISTDUP=erase
HISTSIZE=5000
HISTFILE=$HOME/.zsh_history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt globdots
unsetopt AUTO_CD

bindkey -s "^r" "source $DOTFILES/zsh/keybinds.zsh\n"
