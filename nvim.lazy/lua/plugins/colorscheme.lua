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

  -- {
  --   "echasnovski/mini.base16",
  --   version = false,
  --   opts = {
  --     palette = {
  --       scheme = "Gruvbox dark, soft",
  --       base00 = "#32302f", -- ----
  --       base01 = "#3c3836", -- ---
  --       base02 = "#504945", -- --
  --       base03 = "#665c54", -- -
  --       base04 = "#bdae93", -- +
  --       base05 = "#d5c4a1", -- ++
  --       base06 = "#ebdbb2", -- +++
  --       base07 = "#fbf1c7", -- ++++
  --       base08 = "#fb4934", -- red
  --       base09 = "#fe8019", -- orange
  --       base0A = "#fabd2f", -- yellow
  --       base0B = "#b8bb26", -- green
  --       base0C = "#8ec07c", -- aqua/cyan
  --       base0D = "#83a598", -- blue
  --       base0E = "#d3869b", -- purple
  --       base0F = "#d65d0e", -- brown
  --     },
  --   },
  -- },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "kanagawa-wave",
      colorscheme = "melange",
    },
  },
}
