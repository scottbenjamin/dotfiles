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
    nh
    nodejs
    nushell
    oci-cli
    pre-commit
    pyenv
    ripgrep
    rustup
    tenv
    tree
  ];

  commonBrews = [
    "nushell"
  ];

  commonCasks = [
    "1password"
    "aerospace"
    "alacritty"
    "brave-browser"
    "docker"
    "keymapp"
    "raycast"
    "slack"
    "wezterm@nightly"
  ];
}
