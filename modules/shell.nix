{lib, pkgs, ...}: {
  programs.bash = {
    enable = true;
    initExtra = ''
      # Disable SIGQUIT on Ctrl+\ so it passes through to apps like Neovim
      stty quit undef
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Machine-local environment and secrets. This file is intentionally
    # outside Home Manager and the public configuration repository.
    envExtra = ''
      if [[ -r "$HOME/.zshenv.local" ]]; then
        source "$HOME/.zshenv.local"
      fi
    '';

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 1000 ''
        # Run fastfetch on interactive shell startup
        if [[ "''${ZSH_ENABLE_FASTFETCH:-1}" != "0" ]] && command -v fastfetch &> /dev/null; then
          fastfetch
        fi

        # Disable SIGQUIT on Ctrl+\ so it passes through to apps like Neovim
        stty quit undef

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
      '')

      # Load machine-local additions and overrides after every managed zsh
      # integration so aliases, options, functions, and keybindings can win.
      (lib.mkOrder 2000 ''
        if [[ -r "$HOME/.zshrc.local" ]]; then
          source "$HOME/.zshrc.local"
        fi
      '')
    ];
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

      python = {
        format = "via [$symbol$virtualenv]($style) ";
        symbol = "🐍 ";
        style = "bold yellow";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "bold yellow";
      };
    };
  };

  home.packages = with pkgs; [
    fastfetch
    starship
  ];
}
