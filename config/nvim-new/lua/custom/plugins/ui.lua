return {

  -- Dressing
  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  -- Harpoon for file navigation
  {
    'ThePrimeagen/harpoon',
    opts = {},
  },

  -- Telescope Undo extension
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      require('telescope').setup {
        extensions = {
          undo = {
            side_by_side = true,
            layout_strategy = 'vertical',
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      }

      require('telescope').load_extension 'undo'
      vim.keymap.set('n', '<leader>su', '<cmd>Telescope undo<cr>', { desc = '[S]earch [U]ndo History' })
    end,
  },

  -- Highlight undo
  {
    'tzachar/highlight-undo.nvim',
    opts = {},
  },

  --- mini Surround
  { 'echasnovski/mini.surround', version = false },

  ---   NeoScroll
  { 'karb94/neoscroll.nvim' },
}
