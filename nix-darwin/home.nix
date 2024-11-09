# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "sbenjamin";
  home.homeDirectory = "/Users/sbenjamin";
  home.stateVersion = "24.11"; 
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
    pkgs.nodejs_22
    pkgs.gimme-aws-creds
    pkgs.rustup
    pkgs.lazygit
    pkgs.awscli2
  ];

  # Home Manager is pretty good at managing code/dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshenv".source = ../zsh/.zshenv;
    ".config/wezterm".source = ../wezterm;
    ".config/starship".source = ../starship;
    ".config/zellij".source = ../zellij;
    ".config/nix".source = ../nix;
    ".config/nix-darwin".source = ../nix-darwin;
    ".config/tmux".source = ../tmux;
    ".config/nushell".source = ../nushell;
    ".config/carapace".source = ../carapace;
    # ".config/ghostty".source = ~/code/dotfiles/ghostty;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/nvim";
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
