local function copilot_enabled()
  -- check hostname to see if we're on my work machine
  if vim.fn.hostname() == 'M-WQ43L-ASB' then
    return true
  else
    return false
  end
end

return {
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    enabled = not copilot_enabled(),
    lazy = false,
    config = function()
      require('codeium').setup {}
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    enabled = copilot_enabled(),
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = 'copilot.lua',
    enabled = copilot_enabled(),
    opts = {},
    config = function()
      require('copilot_cmp').setup()
    end,
  },
}
