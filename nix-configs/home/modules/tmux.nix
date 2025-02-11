{pkgs, ...}: {
  programs.tmux = {
    enable = false;
    shortcut = "s";
    terminal = "tmux-256color";
    historyLimit = 15000;
    shell = "${pkgs.nushell}/bin/nu";
    resizeAmount = 5;

    keyMode = "vi";

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.tmux-thumbs
      tmuxPlugins.tmux-fzf
      tmuxPlugins.yank
    ];
    extraConfig = ''
      # Options
      set-option -g default-command "nu -i"
      set-option -g status-position top
      set-option -g focus-events on

      # Reload config
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      set -g default-terminal "tmux-256color"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # Splits
      bind h split-window -c "#{pane_current_path}"
      bind H split-window -l '30%' -c "#{pane_current_path}"
      bind v split-window -hc "#{pane_current_path}"
      bind V split-window -l '33%' -hc "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

    '';
  };
}
