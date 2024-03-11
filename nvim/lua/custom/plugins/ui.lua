return {
  -- Neotree for when we need file manipulation
  -- https://github.com/nvim-tree/nvim-tree.lua
  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   opts = {},
  --
  --   config = function()
  --     require('nvim-tree').setup {
  --       sort = {
  --         sorter = 'case_sensitive',
  --       },
  --       view = {
  --         width = 30,
  --       },
  --       renderer = {
  --         group_empty = true,
  --       },
  --       filters = {
  --         dotfiles = true,
  --       },
  --
  --       vim.keymap.set('n', '<leader>E', ':NvimTreeToggle<cr>', { desc = 'Toggle NVimTree' }),
  --     }
  --   end,
  -- },

  -- Zenmode  - distraction free coding
  -- https://github.com/folke/zen-mode.nvim
  {
    'folke/zen-mode.nvim',
    opts = {},
  },

  -- Undotree
  -- https://github.com/jiaoshijie/undotree
  {
    'jiaoshijie/undotree',
    dependencies = 'nvim-lua/plenary.nvim',
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>", desc = '[u]ndotree Toggle' },
    },
  },

  -- diffview
  -- https://github.com/sindrets/diffview.nvim
  {
    'sindrets/diffview.nvim',
    opts = {},
  },

  -- dressing - better UI-ish
  -- https://github.com/stevearc/dressing.nvim
  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  -- Lualine
  -- yet another status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    enabled = false,
    opts = {},
  },

  -- Oil.nvim
  -- https://github.com/stevearc/oil.nvim
  -- buffer based file explorer

  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function()
      local oil = require 'oil'
      require('oil').setup()
      vim.keymap.set('n', '<leader>e', oil.toggle_float, { desc = 'Toggle file [e]xplorer' })
    end,
  },

  -- Harpoon
  -- https://github.com/ThePrimeagen/harpoon
  -- Managing buffers you want to  see
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}
