return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file" },
          { "<leader>g", group = "git" },
          { "<leader>s", group = "search" },
          { "<leader>t", group = "toggle" },
          { "<leader>u", group = "ui" },
          { "gs", group = "surround" },
        },
      },
    },

    keys = {},
  },
}
