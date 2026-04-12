local M = {
  name = "nvim-web-devicons",
  spec = "https://github.com/nvim-tree/nvim-web-devicons",
}

function M.setup()
  vim.cmd.packadd("nvim-web-devicons")
end

return M
