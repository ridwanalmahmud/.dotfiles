#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "usage: $0 <username>"
    exit 1
fi

NAME=$1

useradd -m $NAME || {
    echo "Failed create user"
    exit 1
}
echo "Succesfully created user -- $NAME"

read -sp "Enter password for $NAME: " password
echo
echo "$NAME:$password" | chpasswd || {
    echo "Failed set password"
    exit 1
}

if ! command -v sudo &>/dev/null; then
    pacman -Sy sudo --noconfirm || {
	    exit 1
    }
else
    echo "sudo already exists"
fi

TEMP_SUDOERS=$(mktemp)
cp /etc/sudoers "$TEMP_SUDOERS.backup"

if ! grep -q "^$NAME ALL=(ALL:ALL) NOPASSWD: ALL" "$TEMP_SUDOERS"; then
    echo "$NAME ALL=(ALL:ALL) NOPASSWD: ALL" >> "$TEMP_SUDOERS" || {
        echo "Failed to update user previledges"
        exit 1
   }
fi

if visudo -c -f "$TEMP_SUDOERS"; then
    cp "$TEMP_SUDOERS" /etc/sudoers
    echo "Sudoers file updated successfully"
else
    echo "Error: Invalid sudoers syntax. Changes not applied."
    cp "$TEMP_SUDOERS.backup" /etc/sudoers
    rm -f "$TEMP_SUDOERS" "$TEMP_SUDOERS.backup"
    exit 1
fi

rm -f "$TEMP_SUDOERS" "$TEMP_SUDOERS.backup"

echo "su - $NAME" >> $HOME/.bash_profile
su - $NAME
