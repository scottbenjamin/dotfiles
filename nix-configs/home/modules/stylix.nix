# Nix home-manager stylix configuration
{pkgs, ...}: {
  programs.stylix = {
    enable = true;
    theme = "dark";

    stylix.base16scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
  };
}
