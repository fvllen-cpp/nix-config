{...}: {
  home.username = "user";
  home.homeDirectory = "/home/user";

  imports = [
    ./common.nix
  ];

  targets.genericLinux.enable = true;
}
