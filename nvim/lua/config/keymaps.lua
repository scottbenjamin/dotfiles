-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local kms = vim.keymap.set

--  Glab CLI
kms("n", "<leader>gM", "<cmd>!glab mr create -fw<CR>", { desc = "Create new MR in browser", silent = true })
kms("n", "<leader>gm", "<cmd>!glab mr view -w<CR>", { desc = "Open MR in browser", silent = true })
kms("n", "<leader>gj", "<cmd>!glab ci view -w<CR>", { desc = "Open CI Jobs in browser", silent = true })
