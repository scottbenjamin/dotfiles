local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new {
  cmd = 'lazygit',
  hidden = true,
  direction = 'float',
  float_opts = {
    -- border = 'double',
  },
}

function Lazygit_toggle()
  lazygit:toggle()
end

-- Lazygit
vim.api.nvim_set_keymap('n', '<leader>cg', '<cmd>lua Lazygit_toggle()<CR>', { noremap = true, silent = true, desc = 'Open Lazygit' })

--  Glab CLI
vim.api.nvim_set_keymap('n', '<leader>cM', '<cmd>glab mr create -w<CR>', { desc = 'Create new MR in browser', silent = true })
vim.api.nvim_set_keymap('n', '<leader>cm', '<cmd>glab mr view -w<CR>', { desc = 'Open MR in browser', silent = true })

return {}
