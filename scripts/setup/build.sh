#!/usr/bin/env bash

set -e

source "$DOTFILES/scripts/setup/buildpkgs.sh"

if [ $# -eq 0 ]; then
    build_pwndbg
    build_rust
    build_yay
    build_wasm
    build_raylib
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case $1 in
    --all)
        build_pwndbg
        build_rust
        build_yay
        build_wasm
        build_raylib
        shift
        ;;
    --pwndbg)
        build_pwndbg
        shift
        ;;
    --rust)
        build_rust
        shift
        ;;
    --yay)
        build_yay
        shift
        ;;
    --wasm)
        build_wasm
        shift
        ;;
    --raylib)
        build_raylib
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        show_usage
        exit 1
        ;;
    esac
done
