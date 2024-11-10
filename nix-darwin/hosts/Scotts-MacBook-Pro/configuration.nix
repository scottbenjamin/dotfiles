{
  pkgs,
  userConfig,
  ...
}: {
  nix-homebrew = {
    enable = true; # Install Homebrew under the default prefix
    user = "${userConfig.name}";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [];
  };

  nix = {
    package = pkgs.nix;
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
    shell = pkgs.nushell;
  };

  # Homebrew settings / casks / taps /etc
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    casks = [
      "1password"
      "wezterm@nightly"
      "keymapp"
      "brave-browser"
      "docker"
      "slack"
      "aerospace"
      "raycast"
      "discord"
    ];
    brews = [
      "nushell"
    ];
    taps = [
      "nikitabobko/tap"
    ];
  };

  programs.zsh.enable = true;

  # Add ability to use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Fonts
  fonts.packages = [
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  # Nix installed packages
  environment.systemPackages = with pkgs; [
    _1password-cli
    alejandra
    awscli2
    bat
    colima
    delta
    direnv
    du-dust
    jq
    k3d
    kubectl
    lazydocker
    nushell
    pre-commit
    pyenv
    ripgrep
    rustup
    tenv
  ];

  services.nix-daemon.enable = true;
  services.aerospace.enable = true;

  system.stateVersion = 5;
}
