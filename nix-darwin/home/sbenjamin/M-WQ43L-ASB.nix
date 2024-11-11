{
  userConfig,
  outputs,
  ...
}: {
  imports = [
    ../modules/common.nix
  ];

  # Enable Home Manager
  programs.home-manager.enable = true;
  home.username = "${userConfig.name}";
  home.homeDirectory = "/Users/${userConfig.name}";

  home.file = {
    ".config/wezterm".source = ../../../wezterm;
    ".config/starship.toml".source = ../../files/starship.toml;
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
