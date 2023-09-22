return {

vim.keymap.set("n", "<leader>gm", ":!glab mr view --web<cr><cr>", { desc = "View current MR" }),
vim.keymap.set("n", "<leader>gM", ":!glab mr new --web<cr><cr>", { desc = "Create New MR" })

}
