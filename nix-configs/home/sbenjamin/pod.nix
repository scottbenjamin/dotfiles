{userConfig, ...}: {
  imports = [
    ../modules/common.nix
  ];

  # Enable Home Manager
  programs.home-manager.enable = true;
  home.username = "${userConfig.name}";
  home.homeDirectory = "/Users/${userConfig.name}";

  home.sessionPath = [
    "/usr/local/bin"
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  home.file = {
    ".config/starship.toml".source = ../../files/starship.toml;
    ".config/nix".source = ../../../nix;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
