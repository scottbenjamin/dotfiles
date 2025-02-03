local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.inccommand = "split"
opt.shiftwidth = 4
opt.breakindent = true -- Enable break indent
opt.undofile = true -- Save undo history
opt.ignorecase = true
opt.signcolumn = "yes" -- Keep signcolumn on by default
opt.smartcase = true
opt.timeoutlen = 300 -- Decrease mapped sequence wait time
opt.updatetime = 250 -- Decrease update time
-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true
-- Preview substitutions live, as you type!
opt.inccommand = "split"
opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

vim.lsp.set_log_level("off")

vim.filetype.add({
  extension = {
    hcl = "hcl",
    tofu = "terraform",
    sls = "sls.yaml",
  },
})

-- disable snacks animation thingies
vim.g.snacks_animate = false
