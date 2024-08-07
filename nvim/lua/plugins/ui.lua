return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    -- undotree
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
}
