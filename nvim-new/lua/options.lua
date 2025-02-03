local opt = vim.opt
local kms = vim.keymap.set

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

kms({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })

--  Glab CLI
kms("n", "<leader>gM", "<cmd>!glab mr create -fw<CR>", { desc = "Create new [M]R in browser", silent = true })
kms("n", "<leader>gm", "<cmd>!glab mr view -w<CR>", { desc = "Open [m]R in browser", silent = true })
kms("n", "<leader>gC", "<cmd>!glab ci view -w<CR>", { desc = "Open [C]I Jobs in browser", silent = true })
