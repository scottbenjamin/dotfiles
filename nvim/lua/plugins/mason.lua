local M = {
  name = "mason.nvim",
  spec = {
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/RubixDev/mason-update-all",
  },
}

local mason_loaded = false

local function ensure_mason()
  vim.cmd.packadd("mason.nvim")
  pcall(vim.cmd.packadd, "mason-tool-installer.nvim")
  pcall(vim.cmd.packadd, "mason-update-all")

  if mason_loaded then
    return
  end

  require("mason").setup()
  if package.loaded["mason-tool-installer"] or pcall(require, "mason-tool-installer") then
    require("mason-tool-installer").setup({
      ensure_installed = {
        "basedpyright",
        "lua-language-server",
        "terraform-ls",
        "tflint",
      },
    })
  end

  mason_loaded = true
end

function M.open()
  ensure_mason()
  vim.cmd("Mason")
end

function M.setup()
  vim.keymap.set("n", "<leader>cm", M.open, { desc = "Mason" })
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_mason_setup", { clear = true }),
    callback = function()
      vim.defer_fn(ensure_mason, 100)
    end,
  })
end

return M
