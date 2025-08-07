return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
  },

  { "neanias/everforest-nvim" },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = { style = "mocha" },
    lazy = true,
    priority = 1000,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-mocha",
      -- colorscheme = "duskfox",
      -- colorscheme = "nightfox",
      -- colorscheme = "tokyonight-moon",
      colorscheme = "kanagawa-wave",
      -- colorscheme = "everforest",
      -- background = "hard",
    },
  },
}
