{
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ../modules/alacritty.nix
    ../modules/atuin.nix
    ../modules/bat.nix
    ../modules/fastfetch.nix
    ../modules/fd.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/gitui.nix
    ../modules/home.nix
    ../modules/k9s.nix
    ../modules/lazygit.nix
    ../modules/neovim.nix
    ../modules/nushell.nix
    ../modules/tmux.nix
    # ../modules/stylix.nix
    # ../modules/tmux.nix
    ../modules/zoxide.nix
  ];

  # Nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
