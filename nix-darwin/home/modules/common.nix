{outputs, ...}: {
  imports = [
    # ../modules/bat.nix
    # ../modules/bottom.nix
    # ../modules/go.nix
    # ../modules/gpg.nix
    # ../modules/saml2aws.nix
    # ../modules/scripts.nix
    # ../modules/spicetify.nix
    # ../modules/tmux.nix
    # ../modules/zsh.nix
    ../modules/alacritty.nix
    ../modules/atuin.nix
    ../modules/darwin-aerospace.nix
    ../modules/fastfetch.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/home.nix
    ../modules/k9s.nix
    ../modules/krew.nix
    ../modules/lazygit.nix
    ../modules/neovim.nix
    ../modules/nushell.nix
    ../modules/zoxide.nix
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };
}
