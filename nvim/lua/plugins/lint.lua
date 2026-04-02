local M = {}

function M.setup()
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

return M
