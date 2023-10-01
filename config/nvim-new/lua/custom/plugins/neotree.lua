return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
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
        require('neo-tree.command').execute { toggle = true, dir = vim.loop.cwd() }
      end,
      desc = 'Explorer NeoTree (cwd)',
    },
  },
}
