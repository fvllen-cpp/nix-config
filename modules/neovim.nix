{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      # Language servers
      clang-tools
      pyright

      # Linters
      ruff

      tree-sitter

      lua-language-server
    ];
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    lazygit
    nodejs
    gcc
  ];

  xdg.configFile."nvim".source = ./nvim;
}
