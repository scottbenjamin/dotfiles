local kms = vim.keymap.set

---- Navigation -----------------------------------------------------------

-- Half page with centered cursor
kms("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
kms("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })

-- Window navigation
kms("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
kms("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
kms("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
kms("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resize
kms("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
kms("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
kms("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
kms("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

---- Buffers --------------------------------------------------------------

kms("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
kms("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
kms("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
kms("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
kms("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

---- LSP ------------------------------------------------------------------

kms("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
kms({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
kms("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
kms("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
kms("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

---- Diagnostics ----------------------------------------------------------

local function diagnostic_goto(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  local dir = next and 1 or -1
  return function()
    vim.diagnostic.jump({ count = dir, float = true, severity = severity })
  end
end

kms("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
kms("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
kms("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
kms("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

---- Quickfix -------------------------------------------------------------

kms("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
kms("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
kms("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
kms("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

---- Editing --------------------------------------------------------------

-- Better indenting
kms("v", "<", "<gv")
kms("v", ">", ">gv")

-- Clipboard
kms({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })

-- Commenting
kms("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
kms("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

---- UI / Utility ---------------------------------------------------------

kms("n", "<leader>ur", "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><cr>", { desc = "Redraw / Clear hlsearch" })
kms("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
kms("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
kms("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

---- Tools ----------------------------------------------------------------

kms("n", "-", "<cmd>Oil<cr>", { desc = "Oil" })
kms("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Oil" })
kms("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

---- Glab CLI -------------------------------------------------------------

kms("n", "<leader>gM", "<cmd>!glab mr create -fw<CR>", { desc = "Create new MR in browser", silent = true })
kms("n", "<leader>gm", "<cmd>!glab mr view -w<CR>", { desc = "Open MR in browser", silent = true })
kms("n", "<leader>gC", "<cmd>!glab ci view -w<CR>", { desc = "Open CI Jobs in browser", silent = true })
