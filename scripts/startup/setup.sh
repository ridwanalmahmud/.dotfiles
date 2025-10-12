#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

set -e

section() {
    echo -e "\n${BLUE}===${NC} ${GREEN}$1${NC} ${BLUE}===${NC}"
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
section "Setup Nix & Dotfiles"
status "Installing nix..."
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon || {
    error "Failed to install nix"
    exit 1
}

status "Setup home manager..."
  . $HOME/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
sudo pacman -S git --needed --noconfirm

status "Cloning dotfiles repository..."
git clone -b nix https://github.com/ridwanalmahmud/.dotfiles.git $DOTFILES || {
    error "Failed to clone dotfiles repository"
    exit 1
}
sudo pacman -Rns git --noconfirm

status "Home manager installation..."
home-manager --extra-experimental-features nix-command --extra-experimental-features flakes --impure switch --flake $DOTFILES/home#home-nix || {
    error "Failed to install packages"
    exit 1
}
success "Nix setup complete and packages installed"

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

status "Installing fonts..."
"$DOTFILES/scripts/setup/fonts.sh" || {
    error "Failed to install fonts"
    exit 1
}

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
