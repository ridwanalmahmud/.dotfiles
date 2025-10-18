export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export DOTFILES="$HOME/.dotfiles"
export LOCAL_BIN="$HOME/.local/bin"
export PERSONAL="$HOME/loom"

export DISPLAY=:0
export EDITOR="nvim"
export FZFM_PDF_READER="zathura"
export PAGER="bat"
export BAT_THEME="gruvbox-dark"
export BAT_STYLE="numbers"
export MANPAGER="nvim +Man!"

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export TYPST_FONT_PATHS="$HOME/.local/share/fonts/"

# SSH Agent Configuration
if [ -z "$SSH_AUTH_SOCK" ]; then
    if [ -S "$HOME/.ssh/ssh_auth_sock" ]; then
        export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
    else
        eval "$(ssh-agent -s -a ~/.ssh/ssh_auth_sock)" >/dev/null
    fi
fi
