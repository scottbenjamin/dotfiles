{...}: {
  programs = {
    nushell = {
      enable = true;

      environmentVariables = {
        PAGER = "bat";
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      configFile.source = ../../files/nushell/config.nu;
      envFile.source = ../../files/nushell/env.nu;

      # Extra things to add to the env.nu file
      shellAliases = {
      };
    };
    # Completions
    carapace.enable = true;
    carapace.enableNushellIntegration = true;
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
