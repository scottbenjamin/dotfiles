{
  pkgs,
  outputs,
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
    overlays = [
	    outputs.overlays.unstable-packages
    ];
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
      "aerospace"
      "brave-browser"
      "docker"
      "keymapp"
      "raycast"
      "wezterm@nightly"
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

  # Mac OS settings
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "Login";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 10;
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
    };
  };

  # Fonts
  fonts.packages = [
    (pkgs.nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
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

  system.stateVersion = 5;
}
