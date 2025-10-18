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
    done <<<"$selected"

    nvim "${files[@]}"
}

bat_strace() {
    stdbuf -o0 strace "$@" 2>&1 | bat --no-pager -l c
}

bat_ltrace() {
    stdbuf -o0 ltrace "$@" 2>&1 | bat --no-pager -l c
}

alias o='cd $(git rev-parse --show-toplevel)'
alias la="ls --color -lAvh --group-directories-first"
alias z="$DOTFILES/scripts/fzfm/fzfm.sh"
alias fh='eval $(history | fzf --height=50% --layout=reverse --tac | sed "s/^[[:space:]]*[0-9]*[[:space:]]*//")'
alias xsc="xclip -selection clipboard"
alias glog="git --no-pager log --oneline --decorate --graph --parents"
alias vi=fzf_nvim
alias vinstall="nvim $DOTFILES/scripts/setup/install.sh"
alias vbuild="nvim $DOTFILES/scripts/setup/buildpkgs.sh"
alias python="python3"
alias strace=bat_strace
alias ltrace=bat_ltrace

bindkey -v
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^g" fzf-history-widget
bindkey "^Xe" edit-command-line
bindkey -s "^p" "$DOTFILES/scripts/workflow/tmux-cht.sh\n"
bindkey -s "^f" "$DOTFILES/scripts/workflow/tmux-sessionizer.sh\n"
bindkey -s "^y" "yazi\n"
