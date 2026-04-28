local M = {
  name = "mason.nvim",
  spec = {
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/RubixDev/mason-update-all",
  },
  event = "UIEnter",
  defer_ms = 100,
  keys = {
    {
      "<leader>cm",
      function()
        M.open()
      end,
      desc = "Mason",
    },
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

function M.config()
  ensure_mason()
end

return M
