return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function()
    require('trouble').setup {

      vim.keymap.set('n', ']d', function()
        require('trouble').next { skip_groups = true, jump = true }
      end, { desc = 'Go to next [D]iagnostic message' }),

      vim.keymap.set('n', '[d', function()
        require('trouble').previous { skip_groups = true, jump = true }
      end, { desc = 'Go to next [D]iagnostic message' }),

      vim.keymap.set('n', '<leader>de', function()
        require('trouble').toggle 'document_diagnostics'
      end, { desc = 'Open [D]ocument diagnostic [E]rror list' }),

      vim.keymap.set('n', '<leader>q', function()
        require('trouble').toggle 'quickfix'
      end, { desc = 'Open diagnostic to [q]uickfix list' }),

      vim.keymap.set('n', '<leader>wd', function()
        require('trouble').toggle 'workspace_diagnostics'
      end, { desc = 'Go to next [w]orkspace [d]iagnostics' }),
    }
    -- FIXME add more keybinds
  end,
}
