{...}: {
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

    extraConfig = ''
      mouse_map right press ungrabbed copy_to_clipboard
    '';
  };
}
