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
    python3
    pyright
    ruff

    # Devicetree
    dtc

    # Nix
    nil
    alejandra

    # JSON
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server

    # Claude Code
    claude-code

    # Codex for OpenAI
    codex

    # Useful CLI tools
    wget
    file
    ccache
  ];
}
