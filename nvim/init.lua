-- Leader keys (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local pack = require("plugins.pack")
local spec = require("plugins.spec")
local core = require("plugins.core")
local editor = require("plugins.editor")
local first_buffer = require("plugins.first_buffer")
local tools = require("plugins.tools")

pack.setup_build_hooks()
spec.add()
pack.setup_commands()
core.setup()

require("config.options")
require("config.keymaps")
if vim.g.neovide then
  require("config.neovide")
end

local local_group = vim.api.nvim_create_augroup

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  group = local_group("load_completion_lsp", { clear = true }),
  callback = first_buffer.setup_on_first_buffer,
})

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  group = local_group("load_deferred_editor_plugins", { clear = true }),
  callback = editor.setup_deferred,
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  group = local_group("load_event_driven_tools", { clear = true }),
  callback = tools.setup_event_driven,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  once = true,
  group = local_group("load_quickfix_tools", { clear = true }),
  callback = tools.setup_quickfix,
})

tools.setup_on_demand()
pack.setup_daily_check()
