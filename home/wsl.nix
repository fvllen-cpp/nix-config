{...}: {
  imports = [
    ./common.nix
  ];

  home.username = "andher";
  home.homeDirectory = "/home/andher";

  targets.genericLinux.enable = true;
}
