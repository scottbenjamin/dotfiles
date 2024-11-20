{...}: {
  # Install atuin via home-manager module
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      inline_height = 25;
      invert = false;
      records = true;
      search_mode = "skim";
      secrets_filter = true;
      style = "compact";
      auto_sync = false;
    };
    flags = ["--disable-up-arrow"];
  };
}
