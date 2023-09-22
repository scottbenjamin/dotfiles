-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>gm", ":!glab mr view --web<cr><cr>", { desc = "View current MR" })
vim.keymap.set("n", "<leader>gM", ":!glab mr new --web --fill<cr><cr>", { desc = "Create New MR" })
