export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

export PERSONAL="$HOME/loom"
export DOTFILES="$HOME/.dotfiles"
export LOCAL_BIN="$HOME/.local/bin"
export LOCAL_LIB="/usr/local/lib"
export LOCAL_INC="/usr/local/include"

export PATH="$LOCAL_BIN:$PATH"
export PATH="$XDG_DATA_HOME/nvim/mason/bin:$PATH"
export PKG_CONFIG_PATH="$LOCAL_LIB/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export TYPST_FONT_PATHS="$XDG_DATA_HOME/fonts/"

export DISPLAY=:0
export EDITOR="nvim"
export FZFM_EDITOR=$EDITOR
export FZFM_PDF_READER="zathura"
export PAGER="bat"
export BAT_THEME="gruvbox-dark"
export BAT_STYLE="numbers"
export MANPAGER="nvim +Man!"

# SSH Agent Configuration
if [ -z "$SSH_AUTH_SOCK" ]; then
    if [ -S "$HOME/.ssh/ssh_auth_sock" ]; then
        export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
    else
        eval "$(ssh-agent -s -a ~/.ssh/ssh_auth_sock)" >/dev/null
    fi
fi
