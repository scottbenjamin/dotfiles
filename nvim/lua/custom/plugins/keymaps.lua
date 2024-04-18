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

-- conform format on save toggle
vim.keymap.set('n', '<leader>tf', function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.g.disable_autoformat = not vim.g.disable_autoformat
end, { desc = 'Toggle [F]ormat on save' })

-- Inlay hints toggle
vim.keymap.set('n', '<leader>ch', function()
  vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay [H]ints' })

-- Lazygit
vim.keymap.set('n', '<leader>cg', function()
  Lazygit_toggle()
end, { noremap = true, silent = true, desc = 'Open Lazy[g]it' })

--  Glab CLI
vim.keymap.set('n', '<leader>cM', '<cmd>!glab mr create -fw<CR>', { desc = 'Create new [M]R in browser', silent = true })
vim.keymap.set('n', '<leader>cm', '<cmd>!glab mr view -w<CR>', { desc = 'Open [m]R in browser', silent = true })

-- LSP Info
vim.keymap.set('n', '<leader>li', '<cmd>:LspInfo<CR>', { desc = '[l]sp [i]nfo' })

vim.keymap.set('n', '<leader>w', '<cmd>:w<CR>', { desc = 'write file' })
vim.keymap.set('n', '<leader>q', '<cmd>:q<CR>', { desc = 'Quit nvim' })

return {}
