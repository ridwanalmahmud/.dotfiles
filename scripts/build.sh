#!/usr/bin/env bash

# Rust installation
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
cargo install cargo-nextest

# Yay aur installation
# sudo pacman -Sy --needed git base-devel --noconfirm
# git clone https://aur.archlinux.org/yay.git
# cd yay
# makepkg -si
