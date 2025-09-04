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
    "fish"
    "fx"
    "gator"
    "gettext"
    "git"
    "git-lfs"
    "glab"
    "jj"
    "jq"
    "k3d"
    "k9s"
    "kubectl"
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
    "cursor-cli"
    "font-commit-mono-nerd-font"
    "font-hack-nerd-font"
    "font-sf-pro"
    "ghostty"
    "raycast"
    "slack"
  ];

  commonTaps = [
   "FelixKratz/formulae"
    "nikitabobko/tap"
    "hashicorp/tap"
  ];
}
