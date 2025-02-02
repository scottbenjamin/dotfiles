return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
    },
    keys = {
      {
        "<leader>b",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer",
      },
      {
        "<leader>c",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Code",
      },
      {
        "<leader>f",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "File",
      },
      {
        "<leader>g",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Git",
      },
      {
        "<leader>s",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Search",
      },
      {
        "<leader>u",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Ui",
      },
    },
  },
}
