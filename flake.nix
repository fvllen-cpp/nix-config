{
  description = "Cross-platform dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    claude-code,
    ...
  }: let
    mkHome = system: modules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          claude-code-pkg = claude-code.packages.${system}.default;
        };
        inherit modules;
      };
  in {
    homeConfigurations = {
      darwin = mkHome "aarch64-darwin" [
        ./home/common.nix
        ./home/darwin.nix
      ];

      linux = mkHome "x86_64-linux" [
        ./home/common.nix
        ./home/linux.nix
      ];

      wsl = mkHome "x86_64-linux" [
        ./home/common.nix
        ./home/wsl.nix
      ];
    };
  };
}
