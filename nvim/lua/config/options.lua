local opt = vim.opt

---- Options ------------------------------------
vim.g.snacks_animate = false

opt.breakindent = true -- Enable break indent
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "split"
opt.laststatus = 3
opt.linebreak = true
opt.list = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 999
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.signcolumn = "yes" -- Keep signcolumn on by default
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.timeoutlen = 250               -- Decrease mapped sequence wait time
opt.undofile = true                -- Save undo history
opt.undolevels = 1000
opt.updatetime = 200               -- Decrease update time
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wrap = false

vim.filetype.add({
  extension = {
    tofu = "terraform",
    sls = "sls.yaml",
    packer = "pkr.hcl",
    shell = "sh.tpl",
  },
})

-- diagnostics
vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = true,
  virtual_text = {
    spacing = 4,
  },
})
