{pkgs}: {
  commonPackages = with pkgs; [
    _1password-cli
    awscli2
    bat
    colima
    delta
    direnv
    du-dust
    jq
    k3d
    nodejs
    kubectl
    lazydocker
    nushell
    pre-commit
    pyenv
    ripgrep
    rustup
    tenv
  ];

  commonCasks = [
    "1password"
    "aerospace"
    "brave-browser"
    "docker"
    "keymapp"
    "raycast"
    "wezterm@nightly"
    ""
  ];
}
