local M = {
  name = "lazydev.nvim",
  spec = "https://github.com/folke/lazydev.nvim",
}

local function init_lazydev()
  vim.cmd.packadd("lazydev.nvim")
  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })
end

function M.setup()
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_lazydev_setup", { clear = true }),
    callback = init_lazydev,
  })
end

return M
