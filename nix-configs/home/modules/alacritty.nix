{pkgs, ...}: {
  # Install alacritty via home-manager module
  programs.alacritty = {
    enable = true;
    # catppuccin.enable = true;
    settings = {
      terminal.shell.program = "nu";
      # shell.args = [
      #   "-l"
      #   "-c"
      #   "tmux attach || tmux "
      # ];

      env = {
        TERM = "xterm-256color";
      };

      window = {
        decorations =
          if pkgs.stdenv.isDarwin
          then "buttonless"
          else "none";
        dynamic_title = false;
        dynamic_padding = true;
        dimensions = {
          columns = 140;
          lines = 70;
        };
        blur = true;
        padding = {
          x = 5;
          y = 1;
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      general = {
        # import = [
        # "~/.config/alacritty/themes/kangawa_wave.toml"
        # ];
        live_config_reload = true;
      };

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      };
    };
  };
}
