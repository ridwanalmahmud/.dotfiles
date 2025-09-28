export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions fzf-tab)

source $ZSH/oh-my-zsh.sh

set -o vi
source <(fzf --zsh)

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

fzf_nvim() {
    selected=$(fzf --multi --style minimal --preview='bat --theme=gruvbox-dark --style=numbers --color=always {} || cat {}' --preview-window 'right:65%')
    if [ -z $selected ]; then
        return
    else
        nvim $selected
    fi
}

alias la="ls --color -lAvh --group-directories-first"
alias bat="bat --style=numbers --theme=gruvbox-dark --color=always"
alias fh='eval $(history | fzf --height=50% --layout=reverse --tac | sed "s/^[[:space:]]*[0-9]*[[:space:]]*//")'
alias xsc="xclip -selection clipboard"
alias glog="git --no-pager log --oneline --decorate --graph --parents"
alias vi=fzf_nvim
alias vinstall="nvim $DOTFILES/scripts/setup/install.sh"
alias vbuild="nvim $DOTFILES/scripts/setup/buildpkgs.sh"
alias src="source ~/.zshrc"
alias python="python3"

bindkey -v
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^Xe" edit-command-line
bindkey "^r" fzf-history-widget
bindkey -s "^f" "~/.local/bin/tmux-sessionizer\n"
