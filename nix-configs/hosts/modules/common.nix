{pkgs}: {
  commonPackages = with pkgs; [
    alejandra
    black
    btop
    nix-btm
    cargo
    colima
    delta
    devenv
    du-dust
    eza
    go
    hclfmt
    isort
    lazydocker
    lua5_1
    luarocks
    markdownlint-cli
    nh
    nixd
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.prettier
    nodejs
    prettierd
    pyenv
    pyright
    python3
    ripgrep
    rustup
    shellcheck
    shfmt
    stow
    stylua
    tree
 ];

  commonBrews = [
    "awscli"
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
    # "neovim"
    "ninja"
    "oci-cli"
    "pre-commit"
    "starship"
    "tenv"
    "tflint"
    "tmux"
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
}
