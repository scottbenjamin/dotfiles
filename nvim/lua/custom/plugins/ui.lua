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
  --       -- FIX: Figure out how to detect root dir
  --       -- vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>', { desc = 'NVimTree cwd' }),
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

  -- heirline - statusline
  -- https://github.com/rebelot/heirline.nvim
  -- Check out the cookboook: https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md
  -- https://github.com/Zeioth/heirline-components.nvim
  -- {
  --   'rebelot/heirline.nvim',
  --   dependencies = { 'Zeioth/heirline-components.nvim' },
  --   opts = {},
  --   config = function(_, opts)
  --     local heirline = require 'heirline'
  --     local heirline_components = require 'heirline-components.all'
  --
  --     -- Setup
  --     heirline_components.init.subscribe_to_events()
  --     heirline.load_colors(heirline_components.hl.get_colors())
  --     heirline.setup(opts)
  --   end,
  -- },

  -- Lualine
  --
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    enabled = false,
    opts = {},
  },

  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function()
      local oil = require 'oil'
      require('oil').setup()
      vim.keymap.set('n', '<leader>e', oil.toggle_float, { desc = 'Toggle file [E]xplorer' })
    end,
  },
}
