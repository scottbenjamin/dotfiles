{
  pkgs,
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
    config.allowUnfree = true;
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
    casks =
      [
        "discord"
      ]
      ++ common.commonCasks;
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
  environment.systemPackages = with pkgs;
    [
      spacebar
    ]
    ++ common.commonPackages;

  services.nix-daemon.enable = true;
  # services.aerospace.enable = true;

  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
    config = {
      background_color = "0xff202020";
      battery_icon_color = "0xffd75f5f";
      clock = "on";
      clock_format = ''"%d/%m/%y %R"'';
      clock_icon = "";
      clock_icon_color = "0xffa8a8a8";
      debug_output = "on";
      display = "main";
      display_separator = "on";
      display_separator_icon = "";
      dnd_icon = "";
      dnd_icon_color = "0xffa8a8a8";
      foreground_color = "0xffa8a8a8";
      height = 26;
      icon_font = ''"Font Awesome 5 Free:Solid:12.0"'';
      padding_left = 20;
      padding_right = 20;
      position = "top";
      power = "on";
      power_icon_color = "0xffcd950c";
      power_icon_strip = " ";
      right_shell = "on";
      right_shell_command = "whoami";
      right_shell_icon = "";
      space_icon = "•";
      space_icon_color = "0xff458588";
      space_icon_color_secondary = "0xff78c4d4";
      space_icon_color_tertiary = "0xfffff9b0";
      space_icon_strip = "1 2 3 4 5 6 7 8 9 10";
      spaces = "on";
      spaces_for_all_displays = "on";
      spacing_left = 25;
      spacing_right = 15;
      text_font = ''"Menlo:Regular:12.0"'';
      title = "on";
    };
  };

  launchd.user.agents.spacebar.serviceConfig.StandardErrorPath = "/tmp/spacebar.err.log";
  launchd.user.agents.spacebar.serviceConfig.StandardOutPath = "/tmp/spacebar.out.log";

  system.stateVersion = 5;
}
