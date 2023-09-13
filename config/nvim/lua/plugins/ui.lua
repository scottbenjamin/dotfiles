local vsize = 160
local hsize = 42

return {
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

  -- toggleterm
  -- {
  --   "akinsho/toggleterm.nvim",
  --   config = true,
  --
  --   cmd = "ToggleTerm",
  --
  --   keys = {
  --     { "<leader>fT", false },
  --     { "<leader>ft", desc = "Terminal" },
  --     {
  --       "<leader>ftt",
  --       "<cmd>ToggleTerm size=" .. hsize .. 'dir="git_dir"<cr>',
  --       desc = "Toggle terminal horizontially [git root dir]",
  --     },
  --     { "<leader>ftT", "<cmd>ToggleTerm size=" .. hsize .. "<cr>", desc = "Toggle terminal horizontally in cwd" },
  --     {
  --       "<leader>fts",
  --       "<cmd>ToggleTerm size=" .. vsize .. ' direction=vertical dir="git_dir" <cr>',
  --       desc = "Toggle terminal vertically [git root dir]",
  --     },
  --
  --     {
  --       "<leader>ftS",
  --       "<cmd>ToggleTerm size=" .. vsize .. " direction=vertical<cr>",
  --       desc = "Toggle terminal vertically in cwd",
  --     },
  --   },
  --
  --   opts = {
  --     hide_numbers = true,
  --     open_mapping = [[<c-\>]],
  --     insert_mappings = true,
  --     terminal_mappings = true,
  --     start_in_insert = true,
  --     close_on_exit = true,
  --   },
  -- },

  { "mbbill/undotree" },
  { "mrjones2014/smart-splits.nvim" },
}
