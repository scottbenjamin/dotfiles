-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local kms = vim.keymap.set

-- Remaps keys to keep cursor in the middle of the screen
kms("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
kms("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })

--  Glab CLI
kms("n", "<leader>gM", "<cmd>!glab mr create -fw<CR>", { desc = "Create new MR in browser", silent = true })
kms("n", "<leader>gm", "<cmd>!glab mr view -w<CR>", { desc = "Open MR in browser", silent = true })
kms("n", "<leader>gj", "<cmd>!glab ci view -w<CR>", { desc = "Open CI Jobs in browser", silent = true })
