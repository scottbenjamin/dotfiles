-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- melange colorscheme
  { 'savq/melange-nvim' },

  -- kanagawa colorscheme
  {
    'rebelot/kanagawa.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 999, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here.
      vim.cmd.colorscheme 'kanagawa'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Schema store
  { 'b0o/SchemaStore.nvim' },

  -- copilot
  -- https://github.com/github/copilot.vim
  -- {
  --   'github/copilot.vim',
  --   cmd = 'Copilot',
  --   build = ':Copilot auth',
  --   config = true,
  --   opts = {},
  -- },
}
