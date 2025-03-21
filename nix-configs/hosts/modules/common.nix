{pkgs}: {
  commonPackages = with pkgs; [
    btop
    cargo
    colima
    delta
    devenv
    du-dust
    eza
    go
    ipcalc
    isort
    lazydocker
    lua5_1
    luarocks
    nh
    nix-btm
    nixd
    nodejs
    python3
    ripgrep
    rustup
    sipcalc
    stow
    tree
  ];

  commonBrews = [
    "ansible"
    "awscli"
    "ccache"
    "cmake"
    "cosign"
    "curl"
    "direnv"
    "fx"
    "gettext"
    "glab"
    "jq"
    "k3d"
    "k9s"
    "kubectl"
    "ninja"
    "oci-cli"
    "pre-commit"
    "pyenv"
    "pyenv-virtualenv"
    "rustup"
    "starship"
    "tenv"
    "tmux"
    "tree-sitter"
    "yq"
    "zig"
  ];

  commonCasks = [
    "1password"
    "1password-cli"
    "aerospace"
    "alacritty"
    "brave-browser"
    "docker"
    "font-commit-mono-nerd-font"
    "font-hack-nerd-font"
    "font-sf-pro"
    "ghostty"
    "keymapp"
    "raycast"
    "slack"
    "zen-browser"
  ];

  commonTaps = [
    "nikitabobko/tap"
    "hashicorp/tap"
  ];
}
