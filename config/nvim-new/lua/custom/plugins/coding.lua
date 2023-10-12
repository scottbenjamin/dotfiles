return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        '<leader>xx',
        function()
          require('trouble').open()
        end,
        desc = 'Open Trouble',
      },
      {
        '<leader>xw',
        function()
          require('trouble').open 'workspace_diagnostics'
        end,
        desc = 'Open Trouble [ Workspace ]',
      },
      {
        '<leader>xd',
        function()
          require('trouble').open 'document_diagnostics'
        end,
        desc = 'Open Trouble [ Document ]',
      },
      {
        '<leader>xq',
        function()
          require('trouble').open 'quickfix'
        end,
        desc = 'Open Trouble [ Quickfix ]',
      },
      {
        '<leader>xl',
        function()
          require('trouble').open 'loclist'
        end,
        desc = 'Open Trouble [ Loclist ]',
      },
    },
  },
  -- Conform, to replace null-ls
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'ruff_fix', 'ruff_format', 'black' },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' } },
        -- shell
        shell = { 'shellcheck', 'shfmt' },
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },
    },
  },

  -- Commenting
  { 'echasnovski/mini.comment', version = false, opts = {} },
}
