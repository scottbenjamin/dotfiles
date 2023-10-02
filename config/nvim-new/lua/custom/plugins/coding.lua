return {
  -- Conform, to replace null-ls
  {
    'stevearc/conform.nvim',
    opts = {
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'ruff_fix', 'ruff_format', 'isort', 'black' },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' } },
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },
    },
  },

  {
    'IndianBoy42/tree-sitter-just',
    opts = {},
  },
}
