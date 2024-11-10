{pkgs, ...}: let
  fastfetch_config = ./../../files/fastfetch;
in {
  # Install fastfetch via home-manager package
  home.packages = with pkgs; [
    fastfetch
  ];

  # Source fastfetch config from the home-manager store
  xdg.configFile = {
    "fastfetch" = {
      recursive = true;
      source = "${fastfetch_config}";
    };
  };
}
