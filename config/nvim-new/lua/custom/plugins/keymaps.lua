return {
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", {desc = "Lazy"}),

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true }),
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true }),
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true }),
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true }),

-- windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true }),
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true }),
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true }),
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true }),
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true }),
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true }),


-- Working with Gitlab
vim.keymap.set("n", "<leader>gm", ":!glab mr view --web<cr><cr>", { desc = "View current MR" }),
vim.keymap.set("n", "<leader>gM", ":!glab mr new --web<cr><cr>", { desc = "Create New MR" })

}
