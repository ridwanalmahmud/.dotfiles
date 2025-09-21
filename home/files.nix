{ config, ... }:

let
    dotfiles = builtins.getEnv "HOME" + "/.dotfiles";
    scripts = "${dotfiles}/scripts";
    binDir = ".local/bin";
in {
    home.file = {
        ".tmux.conf".source = "${dotfiles}/tmux/tmux.conf";
        ".zshrc".source = "${dotfiles}/zsh/conf.zsh";
        ".radare2rc".source = "${dotfiles}/radare2/radare.conf"

        ".config/nix" = {
            source = "${dotfiles}/nix";
            recursive = true;
        };
        "home-nix" = {
            source = "${dotfiles}/home";
            recursive = true;
        };

        ".config/nvim" = {
            source = "${dotfiles}/nvim";
            recursive = true;
        };
        ".config/alacritty" = {
            source = "${dotfiles}/alacritty";
            recursive = true;
        };
        ".config/wezterm" = {
            source = "${dotfiles}/wezterm";
            recursive = true;
        };

        "${binDir}/sudouser" = {
            source = "${scripts}/setup/sudouser.sh";
            executable = true;
        };
        "${binDir}/build" = {
            source = "${scripts}/setup/build.sh";
                executable = true;
        };
        "${binDir}/tmux-sessionizer" = {
            source = "${scripts}/workflow/sessionizer.sh";
            executable = true;
        };
        "${binDir}/debug" = {
            source = "${scripts}/workflow/debug.sh";
            executable = true;
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
