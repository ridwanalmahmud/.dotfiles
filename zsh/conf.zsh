export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

unsetopt AUTO_CD

export DISPLAY=:0
export PATH="$HOME/.local/bin:$PATH"
export TYPST_FONT_PATHS="$HOME/.local/share/fonts/"

set -o vi
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

alias la="ls -lAvh --group-directories-first"
alias glog="git --no-pager log --oneline --decorate --graph --parents"
alias bat="bat --style=numbers --theme=gruvbox-dark --no-pager"
alias autoremove="sudo pacman -Rns \$(pacman -Qdtq)"

bindkey -s "^r" "source ~/.zshrc\n"
bindkey -s "^f" "~/.local/bin/tmux-sessionizer\n"
bindkey -s "^p" "nvim \$(rg --files --hidden --glob '!.git' | fzf --preview='bat --theme=gruvbox-dark --style=numbers --color=always {} || cat {}' --preview-window 'right:65%')\n"

# SSH Agent Configuration
if [ -z "$SSH_AUTH_SOCK" ] && [ -f "$HOME/.ssh/github_key" ]; then
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add "$HOME/.ssh/github_key" 2>/dev/null
fi
