{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  home.username = "andresah21";
  home.homeDirectory = "/Users/andresah21";

  programs.kitty = {
    enable = true;

    themeFile = "tokyo_night_night";

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    settings = {
      term = "xterm-256color";
      background_opacity = "0.95";
      enable_audio_bell = false;
      window_padding_width = 4;
      tab_bar_style = "powerline";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      scrollback_lines = 1000;
      copy_on_select = true;
    };

    keybindings = {
      # macOS-friendly shortcuts
      "cmd+t" = "new_tab";
      "cmd+w" = "close_tab";
      "cmd+shift+]" = "next_tab";
      "cmd+shift+[" = "previous_tab";
      "cmd+plus" = "change_font_size all +2.0";
      "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";
    };

    extraConfig = ''
      mouse_map right press ungrapped copy_to_clipboard
    '';
  };

  home.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
  ];
}
