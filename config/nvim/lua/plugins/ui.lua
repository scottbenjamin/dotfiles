return {
  -- Telescope FZF
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  -- Telescope Undo extension
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      })

      require("telescope").load_extension("undo")
      vim.keymap.set("n", "<leader>su", "<cmd>Telescope undo<cr>", { desc = "Search Undo History" })
    end,
  },
  -- Highlight undo
  {
    "tzachar/highlight-undo.nvim",
    opts = {},
  },
  {
    "folke/twilight.nvim",
    opts = {},
  },
}
