-- Leader keys (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local pack = require("plugins.pack")

pack.setup_build_hooks()
pack.add_specs()
pack.setup_commands()
pack.setup_plugins()

require("config.options")
require("config.autocmds")
require("config.keymaps")
if vim.g.neovide then
  require("config.neovide")
end

pack.setup_daily_check()
