{ config, pkgs, ... }:

{
    imports = [
        ./packages.nix
        ./programs.nix
        ./files.nix
    ];

    home.username = "robin";
    home.homeDirectory = "/home/robin";
    home.stateVersion = "25.05";

    programs.home-manager.enable = true;
}
