{
  userConfig,
  hostname,
  pkgs,
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
    ".config/nushell/config.nu".source = ../../files/nushell/config.nu;
    ".config/nushell/custom.nu".source = ../../files/nushell/custom.nu;
    ".config/nushell/env.nu".source = ../../files/nushell/env.nu;
    ".config/nushell/local.nu".source = ../../files/nushell/${hostname}.nu;
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  home.packages = with pkgs; [
    coder
    pyenv
    kubernetes-helm
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
