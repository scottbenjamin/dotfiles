local M = {
  name = "quicker.nvim",
  spec = "https://github.com/stevearc/quicker.nvim",
}

local function init_quicker()
  vim.cmd.packadd("quicker.nvim")
  require("quicker").setup({})
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    once = true,
    group = vim.api.nvim_create_augroup("plugin_quicker_setup", { clear = true }),
    callback = init_quicker,
  })
end

return M
