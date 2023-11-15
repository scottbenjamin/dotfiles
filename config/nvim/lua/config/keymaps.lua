-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>gm", ":Octo pr browser<cr>", { desc = "View current PR" })
vim.keymap.set("n", "<leader>gM", ":Octo pr create<cr>", { desc = "Create New PR" })
