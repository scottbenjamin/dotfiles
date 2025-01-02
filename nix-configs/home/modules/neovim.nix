{pkgs, ...}: let
  neovim_config = ../../../nvim;
in {
  # Neovim text editor configuration
  programs.neovim = {
    enable = false;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      alejandra
      black
      docker-compose-language-service
      docker-ls
      gitlab-ci-ls
      hclfmt
      isort
      lua-language-server
      markdownlint-cli
      nixd
      nixpkgs-fmt
      nodePackages.bash-language-server
      nodePackages.prettier
      prettierd
      pyright
      ruff
      ruff-lsp
      shellcheck
      shfmt
      sonarlint-ls
      stylua
      terraform-ls
      tflint
      vscode-langservers-extracted
      yaml-language-server
    ];
  };

  xdg.configFile = {
    "nvim" = {
      enable = false;
    };
  };

  # # source lua config from this repo
  # xdg.configFile = {
  #   "nvim" = {
  #     source = "~/.nvim";
  #     recursive = true;
  #   };
  # };
}
