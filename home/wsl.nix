{ ... }:

{
    home.username = "andher";
    home.homeDirectory = "/home/andher";

    imports = [
        ./common.nix
    ];

    targets.genericLinux.enable = true;
}
