{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        hyprland
        xwayland
        hyprpaper
        waybar
        rofi
        kdePackages.dolphin

        man-db
        man-pages
        tldr
        wget
        websocat
        bat
        fzf
        tree
        ripgrep

        linuxPackages.perf
        strace
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
        gdb
        gnumake
        cmake
        ninja
        nodejs
        pkg-config
        docker
        typst

        nmap
        netcat-gnu
    ];
}
