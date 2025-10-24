#!/usr/bin/env bash

set -e

prog=$(basename "$0")

usage() {
    echo "Usage: $prog [-a HOST_ALIAS] -m username -H hostname -f keyname [-N passphrase] [-C comment]"
    echo -e "Usage: $prog -h | --help [print this msg]"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

while getopts "a:m:H:f:N:C:" opt; do
    case $opt in
    a) hostalias="$OPTARG" ;;
    m) username="$OPTARG" ;;
    H) hostname="$OPTARG" ;;
    f) keyname="$OPTARG" ;;
    N) passphrase="$OPTARG" ;;
    C) comment="$OPTARG" ;;
    *)
        usage
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

if [[ -z "$username" || -z "$hostname" || -z "$keyname" ]]; then
    usage
fi

: "${hostalias:=$hostname}"
: "${passphrase:=}"
: "${comment:=}"

ssh_dir=$HOME/.ssh
mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"

if [[ -f "$ssh_dir/$keyname" ]]; then
    echo "SSH key already exists at $ssh_dir/$keyname"
    exit 1
fi

ssh-keygen -t ed25519 -f "$ssh_dir/$keyname" -N "$passphrase" -C "$comment" || {
    echo "Failed to generate SSH key"
    exit 1
}

cat >>"$ssh_dir/config" <<EOL
Host $hostalias
    User $username
    HostName $hostname
    IdentityFile $ssh_dir/$keyname
    IdentitiesOnly yes
    AddKeysToAgent yes

EOL
