return {

  -- Telesope Undo Tree
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
            use_delta = true,
            side_by_side = true,
            layout_strategy = 'vertical',
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      }
      require('telescope').load_extension 'undo'
      vim.keymap.set('n', '<leader>u', '<cmd>Telescope undo<cr>')
    end,
  },
}