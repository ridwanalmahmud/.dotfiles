#!/usr/bin/env bash

echo "pwndbg installation"
if ! command -v pwndbg &>/dev/null; then
    curl -qsL 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb
else
    echo "pwndbg is already installed"
fi

echo "Rust installation"
if ! command -v rustc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust already installed."
fi

echo "Yay aur installation"
if ! command -v yay &>/dev/null; then
    sudo pacman -Sy --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm && cd $HOME
else
    echo "yay already installed."
fi

echo "Wasm installation"
if ! command -v emcc &>/dev/null; then
    git clone https://github.com/emscripten-core/emsdk.git
    cd emsdk
    ./emsdk install latest
    ./emsdk activate latest --permanent
    cd $HOME
else
    echo "Emscripten already installed."
fi

echo "Raylib installation"
echo "Installing Raylib prerequisites"
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

echo "Build Raylib"
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
    echo "Raylib already installed."
fi
