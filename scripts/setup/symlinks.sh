#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles
set -e

OVERWRITE_ALL=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
    --overwrite-all) OVERWRITE_ALL=true ;;
    *)
        echo "Unknown parameter: $1"
        exit 1
        ;;
    esac
    shift
done

link_file() {
    local src=$1 dst=$2
    local overwrite=false backup=false skip=false

    if [[ -e "$dst" ]]; then
        local currentSrc=$(readlink "$dst" 2>/dev/null || true)

        if [ "$currentSrc" = "$src" ]; then
            echo "SKIP: $dst (already linked)"
            return
        fi

        if [ "$OVERWRITE_ALL" = "true" ]; then
            rm -rf "$dst"
            echo "REMOVED: $dst (overwrite all)"
        else
            echo "File exists: $dst"
            echo "  [s]kip, [o]verwrite, [b]ackup?"
            read -n 1 action </dev/tty
            echo

            case "$action" in
            o)
                rm -rf "$dst"
                echo "REMOVED: $dst"
                ;;
            b)
                mv "$dst" "${dst}.bak"
                echo "BACKUP: $dst -> ${dst}.bak"
                ;;
            s | *)
                echo "SKIP: $dst"
                return
                ;;
            esac
        fi
    fi

    ln -s "$src" "$dst"
    echo "LINKED: $src -> $dst"
}

install_dotfiles() {
    echo "Installing dotfiles..."

    find "$DOTFILES" -maxdepth 2 -name 'links.sh' -not -path '*.git*' | while read linkfile; do
        while IFS='=' read -r src dst; do
            [[ -z "$src" ]] && continue
            src=$(eval echo "$src")
            dst=$(eval echo "$dst")
            dir=$(dirname "$dst")

            mkdir -p "$dir"
            link_file "$src" "$dst"
        done <"$linkfile"
    done
}

install_dotfiles
