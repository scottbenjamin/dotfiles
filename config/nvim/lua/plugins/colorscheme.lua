return {
  { "arturgoms/moonbow.nvim" },
  {
    "eddyekofo94/gruvbox-flat.nvim",
  },
  { "ellisonleao/gruvbox.nvim" },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },

  -- https://github.com/savq/melange-nvim
  { "savq/melange-nvim" },
  { "marko-cerovac/material.nvim" },
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "dark",
    },
  },
  { "rebelot/kanagawa.nvim" },
  { "shaunsingh/moonlight.nvim" },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = { style = "storm" },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
