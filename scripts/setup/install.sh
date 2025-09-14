#!/usr/bin/env bash

PKG_MANAGER="sudo pacman -Sy --needed --noconfirm"

packages=(
    man-db
    man-pages
    wget
    websocat
    bat
    fzf
    tree
    ripgrep
    perf
    strace

    # alacritty
    zsh
    tmux
    git
    neovim

    nasm
    lld
    llvm
    clang
    typst
    gdb
    make
    cmake
    ninja
    npm
    pkg-config

    # docker
    # ffmpeg

    nmap
    gnu-netcat
)

installed_packages=$(pacman -Qq)

packages_to_install=()
for pkg in "${packages[@]}"; do
    if ! echo "$installed_packages" | grep -q "^$pkg$"; then
        packages_to_install+=("$pkg")
    else
        echo "$pkg is already installed"
    fi
done

if [ ${#packages_to_install[@]} -eq 0 ]; then
    echo -e "All packages are already installed!"
    exit 0
fi

$PKG_MANAGER "${packages_to_install[@]}"
