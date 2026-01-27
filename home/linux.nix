{...}: {
  imports = [
    ./common.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";

  targets.genericLinux.enable = true;
}
