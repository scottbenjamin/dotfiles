{userConfig, ...}: {
  imports = [
    ../modules/common.nix
    ../modules/tenv.nix
  ];

  # Enable Home Manager
  programs.home-manager.enable = true;

  home.sessionPath = [
    "/usr/local/bin"
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  home.file = {
    ".config/nix".source = ../../../nix;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
