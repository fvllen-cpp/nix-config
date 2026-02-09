{pkgs, ...}: {
  imports = [
    ./common.nix
    ../modules/kitty.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";

  targets.genericLinux.enable = true;

  # Exec into zsh from bash (default login shell on Linux)
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(ps --no-header --pid=$PPID --format=comm) != "zsh" && -z "$ZSH_VERSION" ]]; then
        exec zsh
      fi
    '';
  };

  programs.kitty.keybindings = {
    # Linux shortcuts (Ctrl)
    "ctrl+t" = "new_tab";
    "ctrl+w" = "close_tab";
    "ctrl+shift+]" = "next_tab";
    "ctrl+shift+[" = "previous_tab";
    "ctrl+plus" = "change_font_size all +2.0";
    "ctrl+minus" = "change_font_size all -2.0";
    "ctrl+0" = "change_font_size all 0";
  };

  home.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
  ];
}
