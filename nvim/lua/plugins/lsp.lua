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
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "RubixDev/mason-update-all",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local ensure_installed = {
        "basedpyright",
        "lua_ls",
        "terraformls",
        "tflint",
      }
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_enable = true,
      })

      -- require("mason-lspconfig").setup_handlers({
      --   function(server_name)
      --     local capabilities = require("blink.cmp").get_lsp_capabilities()
      --     require("lspconfig")[server_name].setup({ capabilities = capabilities })
      --   end,
      -- })
    end,
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
}
