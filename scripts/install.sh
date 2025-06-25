#!/usr/bin/bash

PKG_MANAGER="sudo pacman -Sy --needed --noconfirm"

declare -A tools=(
    ["man"]="man --version"
    ["bat"]="bat --version"
    ["fzf"]="fzf --version"
    ["ripgrep"]="rg --version"
    ["tmux"]="tmux -V"
    ["zsh"]="zsh --version"
    ["llvm"]="llvm-config --version"
    ["clang"]="clang --version"
    ["gdb"]="gdb --version"
    ["make"]="make --version"
    ["cmake"]="cmake --version"
    ["neovim"]="nvim --version"
    ["git"]="git --version"
    ["docker"]="docker --version"
    ["doxygen"]="doxygen --version"
    ["nmap"]="nmap --version"
    ["netcat"]="nc --version"
)

echo "📦 Setting up development environment"
$PKG_MANAGER "${!tools[@]}"

echo -e "\n🔍 Installed versions:"
for tool in "${!tools[@]}"; do
    cmd="${tools[$tool]} | head -n1"
    if command -v $(echo "${tools[$tool]}" | awk '{print $1}') &>/dev/null; then
        printf "[%-12s] => %s\n" "$tool" "$(eval "$cmd")"
    else
        printf "[%-12s] => %s\n" "$tool" "Not installed"
    fi
done
