{...}: {
  imports = [
    ./common.nix
  ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  targets.genericLinux.enable = true;
}
