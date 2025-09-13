#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

section() {
    echo -e "\n${BLUE}===${NC} ${GREEN}$1${NC} ${BLUE}===${NC}"
}

status() {
    echo -e "${YELLOW}➔${NC} $1"
}

section "pwndbg installation"
if ! command -v yay &>/dev/null; then
    curl -qsL 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb
else
    status "pwndbg is already installed"
fi

section "Rust installation"
if ! command -v rustc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    status "Rust already installed."
fi

section "Yay aur installation"
if ! command -v yay &>/dev/null; then
    sudo pacman -Sy --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm && cd
else
    status "yay already installed."
fi

section "Wasm installation"
if ! command -v emcc &>/dev/null; then
    git clone https://github.com/emscripten-core/emsdk.git
    cd emsdk
    ./emsdk install latest
    ./emsdk activate latest --permanent
    cd
else
    status "Emscripten already installed."
fi

section "Raylib installation"
status "Installing Raylib prerequisites"
packages=(
    mesa
    libx11
    libxrandr
    libxi
    libxinerama
    libxcursor
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
sudo pacman -Sy --needed --noconfirm "${packages_to_install[@]}"

status "Build Raylib"
if ! pkg-config --exists raylib; then
    git clone https://github.com/raysan5/raylib.git raylib
    cd raylib

    # native installation
    mkdir -p build
    cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=Release
    ninja -C build
    sudo ninja -C build install

    # wasm installation
    cd src
    make PLATFORM=PLATFORM_WEB -B
else
    status "Raylib already installed."
fi
