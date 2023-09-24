return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {}
  end,
  keys = {
    {
      '<leader>fc',
      function()
        require('neo-tree.command').execute { toggle = true, dir = '~/.config/nvim' }
      end,
      desc = 'Explorer Neotree (nvim config dir)',
    },
    {
      '<leader>fe',
      function()
        require('neo-tree.command').execute { toggle = true, dir = require('lazyvim.util').get_root() }
      end,
      desc = 'Explorer NeoTree (root dir)',
    },
    {
      '<leader>fE',
      function()
        require('neo-tree.command').execute { toggle = true, dir = vim.loop.cwd() }
      end,
      desc = 'Explorer NeoTree (cwd)',
    },
    { '<leader>e', '<leader>fe', desc = 'Explorer NeoTree (root dir)', remap = true },
    { '<leader>E', '<leader>fE', desc = 'Explorer NeoTree (cwd)', remap = true },
  },
}
