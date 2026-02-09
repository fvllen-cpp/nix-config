{pkgs, ...}: {
  imports = [
    ./common.nix
    ../modules/kitty.nix
  ];

  home.username = "andresah21";
  home.homeDirectory = "/Users/andresah21";

  programs.kitty.keybindings = {
    # macOS-friendly shortcuts (Cmd)
    "cmd+t" = "new_tab";
    "cmd+w" = "close_tab";
    "cmd+shift+]" = "next_tab";
    "cmd+shift+[" = "previous_tab";
    "cmd+plus" = "change_font_size all +2.0";
    "cmd+minus" = "change_font_size all -2.0";
    "cmd+0" = "change_font_size all 0";
  };

  home.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
  ];
}
