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
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },

    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },

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
        "basedpyright",
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
