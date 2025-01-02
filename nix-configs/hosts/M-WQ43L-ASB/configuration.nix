{
  pkgs,
  outputs,
  inputs,
  userConfig,
  ...
}: let
  common = import ../modules/common.nix {inherit pkgs;};
in {
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
      trusted-users = ["root" "@staff"];
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
    casks =
      [
        "utm"
      ]
      ++ common.commonCasks;

    brews =
      [
      ]
      ++ common.commonBrews;

    taps = [
      "nikitabobko/tap"
    ];
  };

  programs.zsh.enable = true;

  # Add ability to use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Stylix configuration
  stylix = {
    image = "/tmp/blah";
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sizes = {
        applications = 12;
        terminal = 13;
        desktop = 10;
        popups = 10;
      };
    };

    opacity = {
      applications = 0.8;
      terminal = 0.8;
      desktop = 1.0;
      popups = 1.0;
    };

    polarity = "dark"; # "light" or "either"
  };

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
  # fonts.packages = [
  #   (pkgs.nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
  # ];

  # Nix installed packages
  environment.systemPackages = with pkgs;
    [
      pyenv
      gimme-aws-creds
    ]
    ++ common.commonPackages;

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  services.nix-daemon.enable = true;

  system.stateVersion = 5;
}
