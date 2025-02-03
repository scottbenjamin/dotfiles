return {
  "lewis6991/gitsigns.nvim",
  -- event = "LazyFile",
  config = function()
    require("gitsigns").setup({
      current_line_blame_opts = {
        delay = 0,
      },
    })
  end,
  keys = {
    -- stylua: ignore start
    { "<leader>gD", function() require("gitsigns").diffthis("~") end, desc = "Git Diff ~", },
    { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "Git Diff", },
    { "<leader>gb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Blame", },
    -- stylua: ignore end
  },
}
