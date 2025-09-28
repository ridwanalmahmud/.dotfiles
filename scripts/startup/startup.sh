#!/usr/bin/env bash

set -e

show_help() {
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "<username> <userpass> <gitname> <email> <ssh_keyname> <passphrase>"
    echo -e "<username> Create user with sudo previledge"
    echo -e "<userpass> Add password for created user"
    echo -e "<gitname> git config username"
    echo -e "<email> git config email, ssh key comment"
    echo -e "<ssh_keyname> Create ssh key for github"
    echo -e "<passphrase> Add passphrase to the corresponding ssh key"
    echo -e "\n***Warning! If arguments are not provided properly, setup will abort***\n"
}

if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

check_pass() {
    local prompt="$1"
    local var_name="$2"

    while true; do
        read -s -p "$prompt" password1 && echo ""
        read -s -p "Verify $prompt" password2 && echo ""

        if [ "$password1" = "$password2" ]; then
            eval "$var_name=\"$password1\""
            break
        else
            echo "Entries don't match. Please try again."
        fi
    done
}

read -p "Username: " USERNAME
check_pass "Userpass: " USERPASS
read -p "Fullname: " GITNAME
read -p "Email: " GITEMAIL
read -p "SSH key: " KEY_NAME
check_pass "SSH Passphrase: " PASSPHRASE

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
./sudouser.sh $USERNAME $USERPASS

echo "System Update..."
pacman -Syu --needed --noconfirm || {
    echo "Failed to update system and install packages"
    exit 1
}

echo "Execute the setup script as the $1 user"
su - $USERNAME -c "curl -fsSL 'https://raw.githubusercontent.com/ridwanalmahmud/.dotfiles/refs/heads/master/scripts/startup/setup.sh' | sh -s -- $USERNAME $GITNAME $GITEMAIL $KEY_NAME $PASSPHRASE"

echo "Add command to switch to $1 user"
echo "su - $USERNAME" >>~/.bash_profile
