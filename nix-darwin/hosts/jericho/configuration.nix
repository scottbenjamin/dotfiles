{
  pkgs,
  outputs,
  userConfig,
  ...
}: let
  common = import ../modules/common.nix {inherit pkgs;};
in {
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
    enable = false;
  };

  programs.zsh.enable = true;

  # Fonts
  fonts.packages = [
    (pkgs.nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
  ];

  # Nix installed packages
  environment.systemPackages = with pkgs;
    [
      pyenv
    ]
    ++ common.commonPackages;

  services.nix-daemon.enable = true;

  system.stateVersion = 5;
}
