local kms = vim.keymap.set

local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    local dir = -1
    if next then
      dir = 1
    end

    vim.diagnostic.jump({ count = dir, float = true, severity = severity })
  end
end
-- stylua: ignore start
--
-- Remaps keys to keep cursor in the middle of the screen
kms("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
kms("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })

-- Want something to yank to clipboard directly
kms({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })

--  Glab CLI
kms("n", "<leader>gM", "<cmd>!glab mr create -fw<CR>", { desc = "Create new [M]R in browser", silent = true })
kms("n", "<leader>gm", "<cmd>!glab mr view -w<CR>", { desc = "Open [m]R in browser", silent = true })
kms("n", "<leader>gC", "<cmd>!glab ci view -w<CR>", { desc = "Open [C]I Jobs in browser", silent = true })

-- Buffers
kms("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
kms("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
kms("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
kms("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
kms("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
kms("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
kms("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- new file
kms("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- save file
-- kms({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
kms("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
kms("v", "<", "<gv")
kms("v", ">", ">gv")

-- diagnostics
kms("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
kms("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

kms("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
kms("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

kms("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- kms("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
-- kms("n", "]d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
kms("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
kms("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
kms("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
kms("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- commenting
kms("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
kms("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Oil
kms("n", "-", "<cmd>Oil<cr>", { desc = "Oil" })

-- stylua: ignore end
