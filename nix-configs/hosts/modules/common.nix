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
    "docker-buildx"
    "eza"
    "fx"
    "fish"
    "gettext"
    "glab"
    "jj"
    "jq"
    "k3d"
    "k9s"
    "kubectl"
    "gator"
    "mise"
    "neovide"
    "ninja"
    "npm"
    "oci-cli"
    "pdsh"
    "podman"
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
    "font-commit-mono-nerd-font"
    "font-hack-nerd-font"
    "font-sf-pro"
    "ghostty"
    "keymapp"
    "raycast"
    "slack"
  ];

  commonTaps = [
    "nikitabobko/tap"
    "hashicorp/tap"
  ];
}
