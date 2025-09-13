{
    description = "Home Manager configuration of robin";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
    { nixpkgs, home-manager, ... }:
    let
        system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        homeConfigurations."home-nix" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [ ./home.nix ];
        };
    };
}
