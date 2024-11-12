return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          nixpkgs = {
            -- For flake.
            -- This expression will be interpreted as "nixpkgs" toplevel
            -- Nixd provides package, lib completion/information from it.
            -- Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
            -- Package documentation, versions, are evaluated by-need.
            expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }",
          },
          formatting = {
            command = { "alejandra" },
          },
        },
      },
    },
  },
}
