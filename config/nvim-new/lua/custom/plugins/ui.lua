return {
  -- Neotree for when we need file manipulation
  -- https://github.com/nvim-tree/nvim-tree.lua
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},

    config = function()
      require('nvim-tree').setup {
        sort = {
          sorter = 'case_sensitive',
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },

        -- FIX: Figure out how to detect root dir
        -- vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>', { desc = 'NVimTree cwd' }),
        vim.keymap.set('n', '<leader>E', ':NvimTreeToggle<cr>', { desc = 'Toggle NVimTree' }),
      }
    end,
  },

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
      { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>", desc = 'Undotree Toggle' },
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
}
