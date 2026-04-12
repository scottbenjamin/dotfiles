local M = {
  name = "which-key.nvim",
  spec = "https://github.com/folke/which-key.nvim",
}

local function init_which_key()
  vim.cmd.packadd("which-key.nvim")
  require("which-key").setup({
    preset = "helix",
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "toggle" },
        { "<leader>u", group = "ui" },
      },
    },
  })
end

function M.setup()
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_which_key_setup", { clear = true }),
    callback = init_which_key,
  })
end

return M
