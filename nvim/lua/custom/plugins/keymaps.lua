require 'custom.util'
local Util = require 'custom.util'

local function NewTerminal(path, cmd, direction)
  local Terminal = require('toggleterm.terminal').Terminal
  local term = Terminal:new {
    cmd = cmd,
    hidden = true,
    direction = direction,
    dir = path,
  }

  return term
end
-- Toggle  Lazygit on and off based on current buffers cwd
function Lazygit_toggle()
  local lazygit = NewTerminal(Util.get_buf_cwd(), 'lazygit', 'float')
  lazygit:toggle()
end

-- Inlay hints toggle
vim.keymap.set('n', '<leader>ch', function()
  vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay [H]ints' })

-- Lazygit
vim.keymap.set('n', '<leader>cg', function()
  Lazygit_toggle()
end, { noremap = true, silent = true, desc = 'Open Lazy[g]it' })

--  Glab CLI
vim.keymap.set('n', '<leader>cM', '<cmd>glab mr create -w<CR>', { desc = 'Create new [M]R in browser', silent = true })
vim.keymap.set('n', '<leader>cm', '<cmd>glab mr view -w<CR>', { desc = 'Open [m]R in browser', silent = true })

return {}
