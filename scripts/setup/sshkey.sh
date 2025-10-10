#!/usr/bin/env bash

set -e

prog=$(basename "$0")

usage() {
    echo "Usage: $prog [-a HOST_ALIAS] -m USERNAME -H HOSTNAME -f KEYNAME [-N PASSPHRASE] [-C COMMENT]"
    echo -e "Usage: $prog -h|--help [print this msg]"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

while getopts "a:m:H:f:N:C:" opt; do
    case $opt in
    a) HOSTALIAS="$OPTARG" ;;
    m) USERNAME="$OPTARG" ;;
    H) HOSTNAME="$OPTARG" ;;
    f) KEYNAME="$OPTARG" ;;
    N) PASSPHRASE="$OPTARG" ;;
    C) COMMENT="$OPTARG" ;;
    *)
        usage
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

if [[ -z "$USERNAME" || -z "$HOSTNAME" || -z "$KEYNAME" ]]; then
    usage
fi

: "${HOSTALIAS:=$HOSTNAME}"
: "${PASSPHRASE:=}"
: "${COMMENT:=}"

SSH_DIR=$HOME/.ssh
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [[ -f "$SSH_DIR/$KEYNAME" ]]; then
    echo "SSH key already exists at $SSH_DIR/$KEYNAME"
    exit 1
fi

ssh-keygen -t ed25519 -f "$SSH_DIR/$KEYNAME" -N "$PASSPHRASE" -C "$COMMENT" || {
    echo "Failed to generate SSH key"
    exit 1
}

cat >>"$SSH_DIR/config" <<EOL
Host $HOSTALIAS
    User $USERNAME
    HostName $HOSTNAME
    IdentityFile $SSH_DIR/$KEYNAME
    IdentitiesOnly yes
    AddKeysToAgent yes

EOL
