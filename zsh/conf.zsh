export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions fzf-tab)

source $ZSH/oh-my-zsh.sh
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

fzf_nvim() {
    if [[ $# -gt 0 ]]; then
        nvim "$@"
        return
    fi

    local selected=$(fzf --multi --style minimal --preview="bat --color=always {} || cat {}" --preview-window "right:65%")
    if [[ -z "$selected" ]]; then
        return
    fi

    local files=()
    while IFS= read -r line; do
        files+=("$line")
    done <<< "$selected"

    nvim "${files[@]}"
}

fzf_cd() {
    local search_dir="${1:-$HOME/loom}"
    if [[ ! -d "$search_dir" ]]; then
        return 1
    fi

    selected=$(find "$search_dir" -type d -not -path "*git*" | fzf --height=50% --layout=reverse)
    cd "$selected" || return 1
}

alias z=fzf_cd
alias o='cd $(git rev-parse --show-toplevel)'
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
