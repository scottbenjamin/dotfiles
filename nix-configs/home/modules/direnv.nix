{...}: {
  programs.direnv = {
    enable = false;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
