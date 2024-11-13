{pkgs}: {
  commonPackages = with pkgs; [
    _1password-cli
    awscli2
    btop
    colima
    delta
    direnv
    du-dust
    glab
    jq
    k3d
    kubectl
    lazydocker
    nodejs
    nushell
    oci-cli
    pre-commit
    pyenv
    ripgrep
    rustup
    tenv
  ];

  commonCasks = [
    "1password"
    # "aerospace"
    "alacritty"
    "brave-browser"
    "docker"
    "keymapp"
    "raycast"
    "wezterm@nightly"
  ];
}
