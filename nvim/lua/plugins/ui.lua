return {

  -- tokyonight
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },

  -- oil
  -- file manager
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
  -- Syntax Formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        hcl = { "terragrunt_hclfmt" },
        tofu = { "tofu_fmt" },
        nix = { "alejandra" },
      },
    },
  },

  -- Quicker.nvim
  -- https://github.com/stevearc/quicker.nvim
  -- Better quickfix
  {
    "stevearc/quicker.nvim",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },

  -- Arrow
  -- https://github.com/otavioschwanck/arrow.nvim
  -- like harbpoon
  {
    "otavioschwanck/arrow.nvim",
    opts = {
      show_icons = true,
      leader_key = ";", -- Recommended to be a single key
      buffer_leader_key = "m", -- Per Buffer Mappings
    },
  },
}
