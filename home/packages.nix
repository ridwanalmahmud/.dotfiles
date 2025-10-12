{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        hyprland
        xwayland
        hyprpaper
        waybar
        rofi
        yazi

        man-db
        man-pages
        tldr
        wget
        zip
        websocat
        bat
        fzf
        tree
        ripgrep

        rsync
        linuxPackages.perf
        strace
        ltrace
        hurl
        ffmpeg
        xclip
        zathura

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
        python313Packages.pygments
        netcat-gnu
        radare2
    ];
}
