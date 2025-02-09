return {
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        views = {
          cmdline_popup = {
            position = {
              row = "20%",
              col = "50%",
            },
          },
        },
      })
    end,
  },
}
