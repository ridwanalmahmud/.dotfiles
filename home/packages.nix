{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        # hyprland
        # xwayland
        # hyprpaper
        # waybar
        # rofi
        # kdePackages.dolphin
        # alacritty
        man-db
        man-pages
        wget
        websocat
        linuxPackages.perf
        bat
        fzf
        tree
        ripgrep
        tmux
        zsh
        nasm
        llvm
        clang
        gdb
        gnumake
        cmake
        ninja
        neovim
        git
        nodejs
        nmap
        netcat-gnu
        # ffmpeg
        # typst
        # docker
        # mesa
    ];
}
