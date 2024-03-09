-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable diagnostics for filetype helm
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "helm" },
  callback = function()
    vim.schedule(function()
      vim.diagnostic.disable(0)
    end)
  end,
})
