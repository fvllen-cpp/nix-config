{...}: {
  imports = [
    ./common.nix
  ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  targets.genericLinux.enable = true;

  # Exec into zsh from bash
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(ps --no-header --pid=$PPID --format=comm) != "zsh" && -z "$ZSH_VERSION" && -z "$VSCODE_RESOLVING_ENVIRONMENT" && -t 0 ]]; then
        exec zsh
      fi
    '';
  };
}
