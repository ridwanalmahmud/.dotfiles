#!/usr/bin/env bash

set -e

show_help() {
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "$0 <username> <gitname> <email> <ssh_keyname> <passphrase>"
    echo -e "<username> Create user with sudo previledge"
    echo -e "<gitname> git config username"
    echo -e "<email> git config email, ssh key comment"
    echo -e "<ssh_keyname> Create ssh key"
    echo -e "<passphrase> Add passphrase to the corresponding ssh key"
    echo -e "\n***Warning! If arguments are not provided properly, setup will abort***\n"
}

if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [ $# -ne 5 ]; then
    echo "Error: All 5 arguments need to be provided"
    show_help
    exit 1
fi

if ! command -v sudo &>/dev/null; then
    pacman -Sy sudo --noconfirm || {
            exit 1
    }
else
    echo "sudo already exists"
fi

echo "Download and execute the sudouser script"
curl -fLO "https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/startup/sudouser.sh"
chmod 700 sudouser.sh
./sudouser.sh $1

echo "System Update..."
sudo pacman -Syu --needed --noconfirm || {
    echo "Failed to update system and install packages"
    exit 1
}

echo "Execute the setup script as the $1 user"
su - $1 -c "curl -fsSL 'https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/startup/setup.sh' | sh -s -- $1 $2 $3 $4 $5"

echo "Add command to switch to $1 user"
echo "su - $1" >> ~/.bash_profile
