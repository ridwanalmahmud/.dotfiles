#!/usr/bin/env bash

PKG_MANAGER="sudo pacman -Sy --needed --noconfirm"

packages=(
    man-db
    man-pages
    tldr
    wget
    websocat
    bat
    fzf
    tree
    ripgrep

    perf
    strace
    ltrace
    ffmpeg

    wezterm
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
    pkgconf
    docker

    nmap
    gnu-netcat
    radare2
    r2ghidra
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

$PKG_MANAGER "${packages_to_install[@]}"
