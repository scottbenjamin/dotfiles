{outputs, ...}: {
  imports = [
    ../modules/atuin.nix
    ../modules/darwin-aerospace.nix
    ../modules/fzf.nix
    ../modules/home.nix
    ../modules/nushell.nix
    ../modules/zoxide.nix
    ../modules/neovim.nix
    # ../modules/alacritty.nix
    # ../modules/bat.nix
    # ../modules/bottom.nix
    # ../modules/fastfetch.nix
    # ../modules/fzf.nix
    # ../modules/git.nix
    # ../modules/go.nix
    # ../modules/gpg.nix
    # ../modules/home.nix
    # ../modules/krew.nix
    # ../modules/lazygit.nix
    # ../modules/neovim.nix
    # ../modules/saml2aws.nix
    # ../modules/scripts.nix
    # ../modules/spicetify.nix
    # ../modules/tmux.nix
    # ../modules/zsh.nix
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
