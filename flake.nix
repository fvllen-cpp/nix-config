{
    description = "Cross-platform dev environment";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };
 
    outputs = { self, nixpkgs, home-manager, ... }:
    {
        homeConfigurations = {
            darwin = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "aarch64-darwin"; };
                modules = [
                    ./home/common.nix
                    ./home/darwin.nix
                ];
            };

            linux = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [
                    ./home/common.nix
                    ./home/linux.nix
                ];
            };

            wsl = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [
                    ./home/common.nix
                    ./home/wsl.nix
                ];
            };
        };
    };
}
