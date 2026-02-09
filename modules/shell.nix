{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    initContent = ''
      # Run neofetch on interactive shell startup
      if command -v neofetch &> /dev/null; then
        neofetch
      fi

      # Standard emacs-style keybindings (consistent across platforms)
      bindkey -e

      # Navigation
      bindkey '^[[H'    beginning-of-line       # Home
      bindkey '^[[F'    end-of-line             # End
      bindkey '^[[3~'   delete-char             # Delete
      bindkey '^[[1;5C' forward-word            # Ctrl+Right
      bindkey '^[[1;5D' backward-word           # Ctrl+Left

      # History search with Up/Down
      bindkey '^[[A' history-search-backward    # Up
      bindkey '^[[B' history-search-forward     # Down
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      git_branch = {
        format = "on [$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
      };

      nix_shell = {
        format = "via [$symbol$state]($style) ";
        symbol = "❄️ ";
        style = "bold blue";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "bold yellow";
      };
    };
  };

  home.packages = with pkgs; [
    neofetch
    starship
  ];
}
