return {
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()
      require("mini.bracketed").setup()
      require("mini.surround").setup()
      require("mini.files").setup()
      require("mini.move").setup()
      require("mini.pairs").setup()
      require("mini.operators").setup()
      require("mini.icons").setup()
    end,
    keys = {
      {
        "<leader>-",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "File Finder",
      },
    },
  },
}
