#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

set -e

section() {
    echo -e "${BLUE}===${NC} ${GREEN}$1${NC} ${BLUE}===${NC}"
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
EMAIL=$3
KEY_NAME="$4"
PASSPHRASE="$5"

section "Development Environment Setup"

section "Package Installation"
status "Installing packages..."
status "Installing necessary packages..."
curl -fsSL "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/setup/install.sh" | sh || {
    error "Failed to run dotfiles install script"
    exit 1
}
success "Packages installed"

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
echo "" >"$HOME/.zshrc"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions || {
    error "Failed to clone zsh-autosuggestions"
    exit 1
}
git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/fzf-tab || {
    error "Failed to clone fzf-tab"
    exit 1
}
success "Zsh configurations updated..."

section "Dotfiles Setup"
status "Cloning dotfiles repository..."
git clone https://github.com/ridwanalmahmud/.dotfiles.git || {
    error "Failed to clone dotfiles repository"
    exit 1
}

status "Installing fonts..."
"$HOME/.dotfiles/scripts/setup/fonts.sh" || {
    error "Failed to install fonts"
    exit 1
}

status "Creating symlinks..."
"$HOME/.dotfiles/scripts/setup/symlinks.sh" --overwrite-all || {
    error "Failed to create symlinks"
    exit 1
}

status "Running build script..."
"$HOME/.dotfiles/scripts/setup/build.sh --yay" || {
    error "Build script failed"
    exit 1
}
success "Setup complete"

section "Git Configuration"
status "Setting up git..."
git config --global user.name "$GITNAME" || {
    error "Failed to set git user.name"
    exit 1
}
git config --global user.email "$EMAIL" || {
    error "Failed to set git user.email"
    exit 1
}
git config --global init.defaultBranch master || {
    error "Failed to set git default branch"
    exit 1
}
success "Git configured successfully"

section "SSH Key Setup"
status "Creating SSH directory..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ -f "$HOME/.ssh/$KEY_NAME" ]; then
    error "SSH key already exists at $HOME/.ssh/$KEY_NAME"
    exit 1
fi

# generate key
status "Generating new SSH key..."
ssh-keygen -t ed25519 -f "$HOME/.ssh/$KEY_NAME" -C "$EMAIL" -N "$PASSPHRASE" || {
    error "Failed to generate SSH key"
    exit 1
}

# ensure ssh-agent is running and configured in shell startup
status "Configuring SSH agent persistence..."
cat >> "$HOME/.zprofile" <<EOL

# SSH Agent Configuration
if [ -z "\$SSH_AUTH_SOCK" ]; then
    eval "\$(ssh-agent)" >/dev/null
    if [ -f "\$HOME/.ssh/${KEY_NAME}" ]; then
        ssh-add "\$HOME/.ssh/${KEY_NAME}" 2>/dev/null
    fi
fi
EOL
success "SSH key setup completed"

success "Development environment setup successfully completed!"

"$HOME/.dotfiles/scripts/dashboard/culers.sh"
