{pkgs}: {
  commonPackages = with pkgs; [
    _1password-cli
    awscli2
    btop
    colima
    delta
    devenv
    du-dust
    glab
    jq
    k3d
    kubectl
    lazydocker
    neovim
    nh
    nodejs
    nushell
    pre-commit
    pyenv
    ripgrep
    rustup
    stow
    tree
  ];

  commonBrews = [
    "nushell"
    "oci-cli"
    "cosign"
    "tenv"
  ];

  commonCasks = [
    "1password"
    "aerospace"
    "alacritty"
    "brave-browser"
    "docker"
    "ghostty"
    "keymapp"
    "raycast"
    "slack"
    "wezterm@nightly"
  ];
}
