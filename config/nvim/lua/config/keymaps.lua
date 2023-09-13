-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down half while center", noremap = true, silent = true })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up half while center", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gm", ":!glab mr view --web<cr><cr>", { desc = "View current MR" })
