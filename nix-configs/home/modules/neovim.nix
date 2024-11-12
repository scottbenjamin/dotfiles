{pkgs, ...}: let
  neovim_config = ../../../nvim;
in {
  # Neovim text editor configuration
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

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

  # source lua config from this repo
  xdg.configFile = {
    "nvim" = {
      source = "${neovim_config}";
      recursive = true;
    };
  };
}
