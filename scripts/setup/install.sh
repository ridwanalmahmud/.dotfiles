#!/usr/bin/env bash

set -e

PKG_MANAGER="yay -Syu --needed --noconfirm"

packages=(
    sudo
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
    hurl
    # xclip
    # ffmpeg

    # wezterm
    zsh
    tmux
    git
    base-devel # for yay
    neovim

    # hyprland
    # xorg-xwayland
    # hyprpaper
    # waybar
    # rofi
    # dolphin
    # zen-browser-bin

    nasm
    # lld
    llvm
    clang
    typst
    gdb
    make
    cmake
    ninja
    npm
    pkgconf
    # docker

    nmap
    gnu-netcat
    python-pygments
    # radare2
    # r2ghidra
)

installed_packages=$(yay -Qq)

packages_to_install=()

for pkg in "${packages[@]}"; do
    if ! echo "$installed_packages" | grep -q "^$pkg$"; then
        packages_to_install+=("$pkg")
    else
        echo "$pkg is already installed"
    fi
done

$PKG_MANAGER "${packages_to_install[@]}"
