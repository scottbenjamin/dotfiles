local M = {}

function M.setup_on_first_buffer()
  vim.cmd.packadd("friendly-snippets")
  vim.cmd.packadd("colorful-menu.nvim")
  vim.cmd.packadd("blink.cmp")
  require("plugins.blink").setup()

  require("lsp")
end

return M
