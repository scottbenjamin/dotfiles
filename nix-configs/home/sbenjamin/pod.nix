{userConfig, 
pkgs,
...}: {
  imports = [
    ../modules/common.nix
  ];

  # Enable Home Manager
  programs.home-manager.enable = true;
  home.username = "${userConfig.name}";

  home.sessionPath = [
    "/usr/local/bin"
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  home.file = {
    ".config/nix".source = ../../../nix;
  };

  home.packages = with pkgs;
    [
      pyenv
    ] 

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
