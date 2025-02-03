return {
  {
    "echasnovski/mini.ai",
    version = false,
    config = function()
      require("mini.ai").setup()
    end,
  },

  {
    "echasnovski/mini.bracketed",
    version = false,
    config = function()
      require("mini.bracketed").setup()
    end,
  },

  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup()
    end,
  },

  {
    "echasnovski/mini.files",
    version = false,
    config = function()
      require("mini.files").setup()
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

  {
    "echasnovski/mini.move",
    version = false,
    config = function()
      require("mini.move").setup()
    end,
  },

  {
    "echasnovski/mini.pairs",
    version = false,
    config = function()
      require("mini.pairs").setup()
    end,
  },
}
