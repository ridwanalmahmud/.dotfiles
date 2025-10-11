#!/usr/bin/env bash

set -e

# === define packages ===
build_yay() {
    if ! command -v yay &>/dev/null; then
        echo "Yay aur installation"
        sudo pacman -Sy --needed git base-devel --noconfirm
        git clone https://aur.archlinux.org/yay-bin.git $HOME/yay
        cd $HOME/yay && makepkg -si --noconfirm && cd $HOME
    else
        echo "yay already installed."
    fi
}

build_rust() {
    if ! command -v rustc &>/dev/null; then
        echo "Rust installation"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        echo "Rust already installed."
    fi
}

build_pwndbg() {
    if ! command -v pwndbg &>/dev/null; then
        echo "pwndbg installation"
        curl -qsL 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb
    else
        echo "pwndbg is already installed"
    fi
}

build_raylib() {
    echo "Installing Raylib prerequisites"
    packages=(
        mesa
        libx11
        libxrandr
        libxi
        libxinerama
        libxcursor
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
    yay -Sy --needed --noconfirm "${packages_to_install[@]}"

    echo "Build Raylib"
    if ! pkg-config --exists raylib; then
        echo "Raylib installation"
        git clone https://github.com/raysan5/raylib.git $HOME/raylib
        cd $HOME/raylib

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
}

build_wasm() {
    if ! command -v emcc &>/dev/null; then
        echo "Wasm installation"
        git clone https://github.com/emscripten-core/emsdk.git $HOME/emsdk
        cd $HOME/emsdk
        ./emsdk install latest
        ./emsdk activate latest --permanent
        cd $HOME
    else
        echo "Emscripten already installed."
    fi
}

clean() {
    rm -rf $HOME/yay
    rm -rf $HOME/raylib
    rm -rf $HOME/emsdk
}

# === build packages ===
if [[ $# -eq 0 ]]; then
    build_yay
    build_rust
    build_pwndbg
    build_raylib
    build_wasm
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
    --yay)
        build_yay
        shift
        ;;
    --rust)
        build_rust
        shift
        ;;
    --pwndbg)
        build_pwndbg
        shift
        ;;
    --raylib)
        build_raylib
        shift
        ;;
    --wasm)
        build_wasm
        shift
        ;;
    --clean)
        clean
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        show_usage
        exit 1
        ;;
    esac
done
