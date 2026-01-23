{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # C/C++
    clang-tools
    gcc
    cmake

    # Python
    pyright
    ruff

    # Nix
    nil
    alejandra
  ];
}
