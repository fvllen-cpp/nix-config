{ config, pkgs, ... }:

{
    programs = {
        zsh.enable = true;
        git.enable = true;
        neovim.enable = true;
    };

    imports = [
#        ../modules/shell.nix
        ../modules/git.nix
        ../modules/neovim.nix
        ../modules/devtools.nix
    ];

    home.packages = with pkgs; [
      tree
    ];

    home.stateVersion = "24.05";
}
