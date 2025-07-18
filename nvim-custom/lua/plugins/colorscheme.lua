return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = { style = "night" },
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme kanagawa-wave]])
    end,
  },
}
