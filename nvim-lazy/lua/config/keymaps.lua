-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = LazyVim.safe_keymap_set

--  Glab CLI
map("n", "<leader>gM", "<cmd>!glab mr create -fw<CR>", { desc = "Create new [M]R in browser", silent = true })
map("n", "<leader>gm", "<cmd>!glab mr view -w<CR>", { desc = "Open [m]R in browser", silent = true })
