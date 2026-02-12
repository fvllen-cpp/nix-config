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

    # JSON
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server

    # Claude Code
    claude-code

    # Codex for OpenAI
    codex
  ];
}
