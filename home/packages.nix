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
        gnumake
        cmake
        ninja
        nodejs
        pkg-config
        docker

        nmap
        netcat-gnu
        radare2
    ];
}
