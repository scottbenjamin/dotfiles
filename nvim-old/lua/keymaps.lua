local kms = vim.keymap.set
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

kms("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
kms("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

kms("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
kms("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
