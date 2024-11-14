{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shortcut = "s";
    terminal = "tmux-256color";
    historyLimit = 10000;
    shell = "${pkgs.nushell}/bin/nu";

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.tmux-thumbs
      tmuxPlugins.tmux-fzf
    ];
    extraConfig = ''
      set-option -g default-command "nu -i"
      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      set -g default-terminal "tmux-256color"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      set-option -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}
