return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      require("gitsigns").setup({})

      Snacks.toggle({
        name = "Git Signs",
        get = function()
          return require("gitsigns.config").config.signcolumn
        end,
        set = function(state)
          require("gitsigns").toggle_signs(state)
        end,
      }):map("<leader>tG")
    end,

    keys = {
      -- stylua: ignore start
      -- { "<leader>gD", function() require("gitsigns").diffthis("~") end, desc = "Git Diff ~", },
      -- { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "Git Diff", },
      -- { "<leader>gb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Blame", },
      -- stylua: ignore end
    },
  },
}
