#!/usr/bin/env bash

NAME=$1
PASS=$2

useradd -m $NAME || {
    echo "Failed create user"
    exit 1
}
echo "Succesfully created user -- $NAME"
echo "${NAME}:${PASS}" | chpasswd || {
    echo "Failed to change password for $NAME"
    exit 1
}
echo "Successfully changed password for $NAME"

cat >> "/etc/sudoers" <<EOL

# Sudo previledges to $NAME
$NAME ALL=(ALL:ALL) NOPASSWD: ALL
EOL
