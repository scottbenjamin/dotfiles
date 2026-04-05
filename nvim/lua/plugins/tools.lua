local M = {}

local trouble_loaded = false

local function ensure_trouble()
  vim.cmd.packadd("trouble.nvim")
  if not trouble_loaded then
    require("trouble").setup({})
    trouble_loaded = true
  end
end

function M.setup_event_driven()
  vim.cmd.packadd("gitsigns.nvim")
  require("gitsigns").setup({})
  Snacks.toggle({
    name = "Git Signs",
    get = function()
      return require("gitsigns.config").config.signcolumn
    end,
    set = function(state)
      require("gitsigns").toggle_signs(state)
    end,
  }):map("<leader>tG")

  vim.cmd.packadd("nvim-lint")
  require("plugins.lint").setup()
end

function M.setup_quickfix()
  vim.cmd.packadd("quicker.nvim")
  require("quicker").setup({})
end

function M.setup_on_demand()
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

  vim.keymap.set("n", "<leader>ta", function()
    vim.cmd.packadd("nvim-ansible")
    require("ansible").run()
  end, { desc = "Ansible Run Playbook/Role", silent = true })
end

return M
