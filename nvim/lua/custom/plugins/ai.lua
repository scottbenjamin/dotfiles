local function copilot_enabled()
  -- check hostname to see if we're on my personal machine
  if vim.fn.system('hostname'):match 'Scott-PC.local' then
    return false
  else
    return true
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
