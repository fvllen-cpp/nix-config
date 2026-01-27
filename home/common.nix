{pkgs, ...}: {
  imports = [
    #        ../modules/shell.nix
    ../modules/git.nix
    ../modules/neovim.nix
    ../modules/devtools.nix
  ];

  programs = {
    zsh.enable = true;
    git.enable = true;
    neovim.enable = true;
  };

  home.packages = with pkgs; [
    docker

    tree
  ];

  home.stateVersion = "24.05";
}
