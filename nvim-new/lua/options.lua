local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.inccommand = "split"
opt.shiftwidth = 4

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
