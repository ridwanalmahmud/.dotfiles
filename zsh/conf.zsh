export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions)

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
alias bat="bat --style=numbers --theme=gruvbox-dark --no-pager"
alias fh='history | fzf --height=50% --layout=reverse | sed -e "s/^[[:space:]]*[0-9]*[[:space:]]*//" -e "s/\\\\/\\\\\\\\/g" | xargs -I{} zsh -c "{}"'

bindkey -s "^r" "source ~/.zshrc\n"
bindkey -s "^f" "~/.local/bin/tmux-sessionizer\n"
bindkey -s "^p" "nvim \$(rg --files --hidden --glob '!.git' | fzf --preview='bat --theme=gruvbox-dark --style=numbers --color=always {} || cat {}' --preview-window 'right:65%')\n"

# SSH Agent Configuration
if [ -z "$SSH_AUTH_SOCK" ] && [ -f "$HOME/.ssh/github_key" ]; then
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add "$HOME/.ssh/github_key" 2>/dev/null
fi
