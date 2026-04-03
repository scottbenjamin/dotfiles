return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      setup = {
        terraformls = function()
          -- Disable semantic tokens: terraform-ls returns invalid deltaStart
          -- values for heredoc interpolations, causing an infinite loop in
          -- nvim 0.12's semantic_tokens handler (neovim/neovim#36257)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "terraformls" then
                client.server_capabilities.semanticTokensProvider = nil
              end
            end,
          })
          return false -- let LazyVim continue normal server setup
        end,
      },
      servers = {
        nil_ls = {
          mason = false,
          enabled = false,
        },
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
