{pkgs, ...}: {
  # Install alacritty via home-manager module
  programs.alacritty = {
    enable = true;
    # catppuccin.enable = true;
    settings = {
      terminal.shell.program = "/run/current-system/sw/bin/nu";
      terminal.shell.args = ["-i"];

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
          columns = 200;
          lines = 70;
        };
        blur = true;
        padding = {
          x = 5;
          y = 1;
        };
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      };
    };
  };
}
