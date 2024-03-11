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

local function getPath(str, sep)
  sep = sep or '/'
  return str:match('(.*' .. sep .. ')')
end

local function get_buf_cwd()
  return getPath(vim.api.nvim_buf_get_name(0))
end

function Lazygit_toggle()
  local lazygit = NewTerminal(get_buf_cwd(), 'lazygit', 'float')
  lazygit:toggle()
end

-- Inlay hints toggle
vim.keymap.set('n', '<leader>ch', function()
  vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay [H]ints' })

-- Lazygit
vim.api.nvim_set_keymap('n', '<leader>cg', '<cmd>lua Lazygit_toggle()<CR>', { noremap = true, silent = true, desc = 'Open Lazygit' })

--  Glab CLI
vim.api.nvim_set_keymap('n', '<leader>cM', '<cmd>glab mr create -w<CR>', { desc = 'Create new MR in browser', silent = true })
vim.api.nvim_set_keymap('n', '<leader>cm', '<cmd>glab mr view -w<CR>', { desc = 'Open MR in browser', silent = true })

return {}
