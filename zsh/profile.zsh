source $HOME/.cargo/env

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export DOTFILES="$HOME/.dotfiles"
export LOCAL_BIN="$HOME/.local/bin"

export DISPLAY=:0
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export TYPST_FONT_PATHS="$HOME/.local/share/fonts/"

# SSH Agent Configuration
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent)" >/dev/null
fi

for pubkey in "$HOME/.ssh"/*.pub; do
    private_key="${pubkey%.pub}"
    if [ -f "$private_key" ] && [ ! -L "$private_key" ]; then
        ssh-add "$private_key" 2>/dev/null
    fi
done
