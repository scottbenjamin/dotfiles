local M = {
  name = "oil.nvim",
  spec = "https://github.com/stevearc/oil.nvim",
}

local plugin = require("utils.plugin")

local function open_oil()
  plugin.packadd_and_setup("oil.nvim", function()
    require("oil").setup({})
  end)
  vim.cmd("Oil")
end

function M.setup()
  vim.keymap.set("n", "-", open_oil, { desc = "Oil" })
  vim.keymap.set("n", "<leader>e", open_oil, { desc = "Oil" })
end

return M
