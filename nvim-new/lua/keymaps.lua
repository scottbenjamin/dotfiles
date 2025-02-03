local kms = vim.keymap.set
-- Want something to yank to clipboard directly
kms({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })

--  Glab CLI
kms("n", "<leader>gM", "<cmd>!glab mr create -fw<CR>", { desc = "Create new [M]R in browser", silent = true })
kms("n", "<leader>gm", "<cmd>!glab mr view -w<CR>", { desc = "Open [m]R in browser", silent = true })
kms("n", "<leader>gC", "<cmd>!glab ci view -w<CR>", { desc = "Open [C]I Jobs in browser", silent = true })
