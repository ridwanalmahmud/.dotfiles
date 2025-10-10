#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

set -e

section() {
    echo -e " ${BLUE}===${NC} ${GREEN}$1${NC} ${BLUE}===${NC} "
}

status() {
    echo -e "${YELLOW}➔ $1${NC}"
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

error() {
    echo -e "${RED}✗ $1${NC}" >&2
}

USER=$1
GITNAME=$2
GITEMAIL=$3
KEY_NAME="$4"
PASSPHRASE="$5"

export XDG_CONFIG_HOME=$HOME/.config
export DOTFILES="$HOME/.dotfiles"
export LOCAL_BIN="$HOME/.local/bin"

section "=== System Environment Setup ==="
section "Package Installation"
status "Yay installation..."
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/setup/build.sh" | sh -s -- --yay || {
    error "Yay installation failed"
    exit 1
}
status "Installing packages..."
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/setup/install.sh" | sh || {
    error "Failed to run dotfiles install script"
    exit 1
}
success "Packages installed"

section "Dotfiles Setup"
status "Cloning dotfiles repository..."
git clone https://github.com/ridwanalmahmud/.dotfiles.git $DOTFILES || {
    error "Failed to clone dotfiles repository"
    exit 1
}
status "Installing fonts..."
"$DOTFILES/scripts/setup/fonts.sh" || {
    error "Failed to install fonts"
    exit 1
}
status "Creating symlinks..."
"$DOTFILES/scripts/setup/symlinks.sh" --overwrite-all || {
    error "Failed to create symlinks"
    exit 1
}
success "Dotfiles installation complete"

section "ZSH Configuration"
status "Changing default shell..."
ZSH_PATH=$(which zsh)
if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi
if [ "$SHELL" != "$ZSH_PATH" ]; then
    sudo chsh -s "$ZSH_PATH" $USER || {
        error "Failed to change default shell to zsh"
        exit 1
    }
fi
status "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
    error "Failed to install Oh My Zsh"
    exit 1
}
status "Installing zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions || {
    error "Failed to clone zsh-autosuggestions"
    exit 1
}
git clone https://github.com/Aloxaf/fzf-tab.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/fzf-tab || {
    error "Failed to clone fzf-tab"
    exit 1
}
status "Renaming .zshrc"
rm $HOME/.zshrc
mv $HOME/zshrc.pre-oh-my-zsh $HOME/.zshrc
success "Zsh configurations updated..."

section "Git Configuration"
status "Setting up git..."
git config --global user.name "$GITNAME"
git config --global user.email "$GITEMAIL"
git config --global init.defaultBranch master
success "Git configured successfully"

section "SSH Key Setup"
SSH_DIR=$HOME/.ssh
status "Creating SSH directory..."
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
if [[ -f "$SSH_DIR/$KEY_NAME" ]]; then
    error "SSH key already exists at $SSH_DIR/$KEY_NAME"
    exit 1
fi
status "Generating new SSH key..."
$DOTFILES/scripts/setup/sshkey.sh -a "github*" -m "git" -H "github.com" -f "$KEY_NAME" -N "$PASSPHRASE" -C "$GITEMAIL" || {
    error "Failed to generate SSH key"
    exit 1
}
success "SSH key setup completed"
success " === System Environment setup successfully completed! === "

"$DOTFILES/scripts/dashboard/culers.sh"
