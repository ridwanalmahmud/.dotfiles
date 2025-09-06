#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PKG_MANAGER="sudo yay -Sy --needed --noconfirm"

packages=(
    hyprland
    xorg-xwayland
    hyprpaper
    waybar
    rofi
    dolphin
    zen-browser-bin
)

echo "📦 Installing development packages..."
$PKG_MANAGER "${packages[@]}"

echo -e "\n🔍 Checking installation status..."
installed=$(pacman -Qq)

echo -e "\n🔍 Installation status:"
for pkg in "${packages[@]}"; do
    if rg -qw "^${pkg}$" <<< "$installed"; then
        printf "${GREEN}[✓]${NC} %-15s - Installed\n" "$pkg"
    else
        printf "${RED}[✗]${NC} %-15s - Failed\n" "$pkg"
    fi
done
