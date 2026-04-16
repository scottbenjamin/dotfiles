local M = {
  name = "mini.nvim",
  spec = "https://github.com/echasnovski/mini.nvim",
}

local function init_mini()
  vim.cmd.packadd("mini.nvim")
  require("mini.ai").setup()
  require("mini.bracketed").setup()
  require("mini.comment").setup()
  require("mini.surround").setup()
  require("mini.move").setup()
  require("mini.pairs").setup()
  require("mini.icons").setup()
end

function M.setup()
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_mini_setup", { clear = true }),
    callback = init_mini,
  })
end

return M
