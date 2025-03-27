return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    event = "VeryLazy",
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  { "j-hui/fidget.nvim", opts = {} },

  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "RubixDev/mason-update-all",
    },
    config = function()
      local ensure_installed = {
        "stylua",
        "lua-language-server",
        "terraform-ls",
        "tflint",
      }
      require("mason").setup()
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      require("mason-update-all").setup()
    end,
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
}
--   {
--     "neovim/nvim-lspconfig",
--     enabled = false,
--     event = "VeryLazy",
--     dependencies = {
--       { "williamboman/mason.nvim", opts = {} },
--       "williamboman/mason-lspconfig.nvim",
--       "WhoIsSethDaniel/mason-tool-installer.nvim",
--       "saghen/blink.cmp",
--
--       -- Useful status updates for LSP.
--       { "j-hui/fidget.nvim", opts = {} },
--     },
--     config = function(_, opts)
--       vim.api.nvim_create_autocmd("LspAttach", {
--         group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
--         callback = function(event)
--           -- NOTE: Remember that Lua is a real programming language, and as such it is possible
--           -- to define small helper and utility functions so you don't have to repeat yourself.
--           --
--           -- In this case, we create a function that lets us more easily define mappings specific
--           -- for LSP related items. It sets the mode, buffer and description for us each time.
--           local map = function(keys, func, desc, mode)
--             mode = mode or "n"
--             vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
--           end
--
--           -- The following two autocommands are used to highlight references of the
--           -- word under your cursor when your cursor rests there for a little while.
--           --    See `:help CursorHold` for information about when this is executed
--           --
--           -- When you move your cursor, the highlights will be cleared (the second autocommand).
--           local client = vim.lsp.get_client_by_id(event.data.client_id)
--           if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
--             local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
--             vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--               buffer = event.buf,
--               group = highlight_augroup,
--               callback = vim.lsp.buf.document_highlight,
--             })
--
--             vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--               buffer = event.buf,
--               group = highlight_augroup,
--               callback = vim.lsp.buf.clear_references,
--             })
--
--             vim.api.nvim_create_autocmd("LspDetach", {
--               group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
--               callback = function(event2)
--                 vim.lsp.buf.clear_references()
--                 vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
--               end,
--             })
--           end
--
--
--           -- The following code creates a keymap to toggle inlay hints in your
--           -- code, if the language server you are using supports them
--           --
--           -- This may be unwanted, since they displace some of your code
--           if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
--             Snacks.toggle.inlay_hints():map("<leader>th")
--           end
--         end,
--       })
--
--       -- LSP servers and clients are able to communicate to each other what features they support.
--       --  By default, Neovim doesn't support everything that is in the LSP specification.
--       --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--       --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
--       local capabilities = vim.lsp.protocol.make_client_capabilities()
--
--       -- TODO: Add Blink capabilities
--       capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(capabilities))
--
--       -- Setup Mason
--       local ensure_installed = {
--         "stylua",
--         "yamlls",
--         "pyright",
--         "terraform-ls",
--       }
--
--       local servers = {
--         lua_ls = {
--           settings = {
--             Lua = {
--               completion = {
--                 callSnippet = "Replace",
--               },
--             },
--           },
--         },
--       }
--       require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
--       require("mason-lspconfig").setup()
--       require("mason-lspconfig").setup_handlers({
--         function(server_name)
--           local server = servers[server_name] or {}
--           -- This handles overriding only values explicitly passed
--           -- by the server configuration above. Useful when disabling
--           -- certain features of an LSP (for example, turning off formatting for ts_ls)
--           server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
--           require("lspconfig")[server_name].setup(server)
--         end,
--       })
--     end,
--   },
