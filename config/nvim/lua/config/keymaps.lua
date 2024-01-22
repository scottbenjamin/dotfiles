-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>gm", ":!gh pr view --web<cr>", { desc = "View current PR web" })
vim.keymap.set("n", "<leader>gM", ":!gh pr create --web<cr>", { desc = "Create New PR web" })
vim.keymap.set("n", "<leader>gw", ":!gh pr checks <cr>", { desc = "Watch PR checks live" })
vim.keymap.set("n", "<leader>gW", ":!gh pr checks --web<cr>", { desc = "Open PR checks in browser" })
