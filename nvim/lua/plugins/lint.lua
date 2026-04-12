local M = {
  name = "nvim-lint",
  spec = "https://github.com/mfussenegger/nvim-lint",
}

local function init_lint()
  vim.cmd.packadd("nvim-lint")

  local lint = require("lint")
  lint.linters_by_ft = {
    hcl = { "tflint" },
    terraform = { "terraform_validate" },
    tf = { "terraform_validate" },
  }

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("lint", { clear = true }),
    callback = function()
      if vim.opt_local.modifiable:get() then
        lint.try_lint()
      end
    end,
  })
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_lint_setup", { clear = true }),
    callback = init_lint,
  })
end

return M
