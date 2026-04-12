local M = {
  name = "trouble.nvim",
  spec = "https://github.com/folke/trouble.nvim",
}

local plugin = require("utils.plugin")

local function ensure_trouble()
  plugin.packadd_and_setup("trouble.nvim", function()
    require("trouble").setup({})
  end)
end

function M.setup()
  local trouble_keys = {
    { "<leader>tx", "diagnostics toggle" },
    { "<leader>tX", "diagnostics toggle filter.buf=0" },
    { "<leader>ts", "symbols toggle focus=false" },
    { "<leader>tl", "lsp toggle focus=false win.position=right" },
    { "<leader>tL", "loclist toggle" },
    { "<leader>tQ", "qflist toggle" },
  }

  for _, key in ipairs(trouble_keys) do
    vim.keymap.set("n", key[1], function()
      ensure_trouble()
      vim.cmd("Trouble " .. key[2])
    end, { desc = "Trouble: " .. key[2] })
  end
end

return M
