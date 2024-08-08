return {
  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },
  -- oil
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- undotree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },

  { "AckslD/swenv.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        hcl = { "terragrunt_hclfmt" },
        tofu = { "tofu_fmt" },
      },
    },
  },

  -- Quicker.nvim
  -- https://github.com/stevearc/quicker.nvim
  {
    "stevearc/quicker.nvim",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}
