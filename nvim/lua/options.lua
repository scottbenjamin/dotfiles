local opt = vim.opt

---- Options ------------------------------------
-- disable snacks thingies
vim.g.snacks_animate = false

opt.breakindent = true -- Enable break indent
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect,noinsert,popup" -- TODO: remove noinsert/popup when neovim 0.11 comes out
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
opt.timeoutlen = 300 -- Decrease mapped sequence wait time
opt.undofile = true -- Save undo history
opt.undolevels = 10000
opt.updatetime = 200 -- Decrease update time
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

-- diagnostics
vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = true,
  virtual_text = {
    prefix = "",
    spacing = 4,
  },
})

---- Autocommands ------------------------------------
---
-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

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

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
