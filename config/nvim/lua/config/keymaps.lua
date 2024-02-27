-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ghm", ":!gh pr view --web<cr>", { desc = "View current PR web" })
vim.keymap.set("n", "<leader>ghM", ":!gh pr create --web<cr>", { desc = "Create New PR web" })
vim.keymap.set("n", "<leader>ghw", ":!gh pr checks <cr>", { desc = "Watch PR checks live" })
vim.keymap.set("n", "<leader>ghW", ":!gh pr checks --web<cr>", { desc = "Open PR checks in browser" })
vim.keymap.set("n", "<leader>gl", "", { desc = "gitlab" })
vim.keymap.set("n", "<leader>glm", ":!glab mr view -w<cr>", { desc = "View current MR web" })
vim.keymap.set("n", "<leader>glM", ":!glab mr create -w<cr>", { desc = "Create New MR web" })
vim.keymap.set("n", "<leader>glw", ":!glab ci view <cr>", { desc = "Watch MR checks live" })
vim.keymap.set("n", "<leader>glW", ":!glab ci view -w<cr>", { desc = "Open MR checks in browser" })
