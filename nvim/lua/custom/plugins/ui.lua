return {

  -- melange colorscheme
  { 'savq/melange-nvim', enabled = false },

  --  https://github.com/catppuccin/nvim
  { 'catppuccin/nvim', name = 'catppuccin', enabled = false, priority = 1000, lazy = false },

  {
    'folke/tokyonight.nvim',
    enabled = true,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Onedark colorscheme
  {
    'navarasu/onedark.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    enabled = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here.
      local theme = require 'onedark'
      theme.load()
      theme.setup {
        style = 'deep',
      }
    end,
  },

  -- Material colorscheme
  -- https://github.com/marko-cerovac/material.nvim
  {
    'marko-cerovac/material.nvim',
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      vim.g.material_style = 'darker'
      vim.cmd.colorscheme 'material'
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
    enabled = true,
    opts = { theme = 'tokyonight' },
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
    enabled = false,
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Grapple
  -- https://github.com/cbochs/grapple.nvim
  {
    'cbochs/grapple.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    event = { 'BufRead', 'BufNewFile' },
    cmd = 'Grapple',
    opts = {
      scope = 'git', -- also try out "git_branch"
    },
    config = function()
      vim.keymap.set('n', '<leader>m', '<cmd>Grapple toggle<cr>', { desc = 'Grapple toggle tag' })
      vim.keymap.set('n', '<leader>k', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple toggle tags' })
      vim.keymap.set('n', '<leader>K', '<cmd>Grapple toggle_scopes<cr>', { desc = 'Grapple toggle scopes' })
      vim.keymap.set('n', '<leader>j', '<cmd>Grapple cycle forward<cr>', { desc = 'Grapple cycle forward' })
      vim.keymap.set('n', '<leader>J', '<cmd>Grapple cycle backward<cr>', { desc = 'Grapple cycle backward' })
      vim.keymap.set('n', '<leader>1', '<cmd>Grapple select index=1<cr>', { desc = 'Grapple select 1' })
      vim.keymap.set('n', '<leader>2', '<cmd>Grapple select index=2<cr>', { desc = 'Grapple select 2' })
      vim.keymap.set('n', '<leader>3', '<cmd>Grapple select index=3<cr>', { desc = 'Grapple select 3' })
      vim.keymap.set('n', '<leader>4', '<cmd>Grapple select index=3<cr>', { desc = 'Grapple select 4' })
    end,
  },

  -- Smart Splits
  -- https://github.com/mrjones2014/smart-splits.nvim
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      -- recommended mappings from the github repo
      --
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set('n', '<C-A-h>', require('smart-splits').resize_left, { desc = 'Resize Split Left' })
      vim.keymap.set('n', '<C-A-j>', require('smart-splits').resize_down, { desc = 'Resize Split Down' })
      vim.keymap.set('n', '<C-A-k>', require('smart-splits').resize_up, { desc = 'Resize Split Up' })
      vim.keymap.set('n', '<C-A-l>', require('smart-splits').resize_right, { desc = 'Resize Split Right' })

      -- moving between splits
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = 'Move Split Left' })
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = 'Move Split Down' })
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = 'Move Split Up' })
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = 'Move Split Right' })
      vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous, { desc = 'Move Previous Split' })

      -- swapping buffers between windows
      vim.keymap.set('n', '<leader>Sh', require('smart-splits').swap_buf_left, { desc = 'Swap split left' })
      vim.keymap.set('n', '<leader>Sj', require('smart-splits').swap_buf_down, { desc = 'Swap split down' })
      vim.keymap.set('n', '<leader>Sk', require('smart-splits').swap_buf_up, { desc = 'Swap split up' })
      vim.keymap.set('n', '<leader>Sl', require('smart-splits').swap_buf_right, { desc = 'Swap split right' })
    end,
  },

  -- Indent blankline
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- Colorizer
  -- https://github.com/norcalli/nvim-colorizer.lua
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('colorizer').setup()
    end,
  },
}
