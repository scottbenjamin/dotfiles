-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LSP
-- vim.lsp.set_log_level("off")

-- Filetype
vim.filetype.add({
  extension = {
    hcl = "hcl",
    tofu = "terraform",
    sls = "sls.yaml",
  },
})

-- disable snacks thingies
vim.g.snacks_animate = false

vim.opt.scrolloff = 999
