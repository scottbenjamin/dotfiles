local opt = vim.opt

---- Options ------------------------------------

opt.breakindent = true -- Enable break indent
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect,noinsert,popup" -- TODO: remove noinsert/popup when neovim 0.11 comes out
opt.conceallevel = 2
opt.cursorline = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "split"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 10
opt.shiftround = true
opt.shiftwidth = 3
opt.showmode = false
opt.signcolumn = "yes" -- Keep signcolumn on by default
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 300 -- Decrease mapped sequence wait time
opt.undofile = true -- Save undo history
opt.undolevels = 1000
opt.updatetime = 250 -- Decrease update time
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wrap = false

vim.lsp.set_log_level("off")

vim.filetype.add({
  extension = {
    hcl = "hcl",
    tofu = "terraform",
    sls = "sls.yaml",
  },
})

---- Autocommands ------------------------------------

-- Gitlab CI
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.gitlab-ci*.{yml,yaml}",
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})

-- HCL Files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.hcl",
  callback = function()
    vim.bo.commentstring = "#%s"
  end,
})
