{ config, pkgs, ... }:

let
    dotfiles = builtins.getEnv "HOME" + "/.dotfiles";
    scripts = "${dotfiles}/scripts";
in {
    home.username = "robin";
    home.homeDirectory = "/home/robin";

    home.stateVersion = "25.05";

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

    programs.home-manager.enable = true;

    programs.git = {
        enable = true;
        userName = "ridwanalmahmud";
        userEmail = "ridwanalmahmud107@gmail.com";
        extraConfig = {
            init.defaultBranch = "master";
        };
    };
    home.file = {
        ".local/bin/sudouser" = {
            source = "${scripts}/setup/sudouser.sh";
            executable = true;
        };
        ".local/bin/build" = {
            source = "${scripts}/setup/build.sh";
                executable = true;
        };
        ".local/bin/tmux-sessionizer" = {
            source = "${scripts}/workflow/sessionizer.sh";
            executable = true;
        };
        ".local/bin/debug" = {
            source = "${scripts}/workflow/debug.sh";
            executable = true;
        };
        ".local/bin/culers" = {
            source = "${scripts}/dashboard/culers.sh";
            executable = true;
        };
        ".local/bin/stark" = {
            source = "${scripts}/dashboard/stark.sh";
            executable = true;
        };
        ".local/bin/marauders" = {
            source = "${scripts}/dashboard/marauders.sh";
            executable = true;
        };
        ".tmux.conf".source = "${dotfiles}/tmux/tmux.conf";
        ".zshrc".source = "${dotfiles}/zsh/conf.zsh";
        ".config/alacritty" = {
            source = "${dotfiles}/alacritty";
            recursive = true;
        };
        ".local/share/fonts" = {
            source = "${dotfiles}/fonts";
            recursive = true;
        };
        ".config/nix" = {
            source = "${dotfiles}/nix";
            recursive = true;
        };
        ".config/nvim" = {
            source = "${dotfiles}/nvim";
            recursive = true;
        };
        "home-nix" = {
            source = "${dotfiles}/home";
            recursive = true;
        };
        ".config/hypr" = {
            source = "${dotfiles}/hyprland/hypr";
            recursive = true;
        };
        ".config/waybar" = {
            source = "${dotfiles}/hyprland/waybar";
            recursive = true;
        };
        ".config/rofi" = {
            source = "${dotfiles}/hyprland/rofi";
            recursive = true;
        };
    };
}
