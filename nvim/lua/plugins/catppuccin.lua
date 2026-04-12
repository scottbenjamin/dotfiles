local M = {
  name = "catppuccin",
  spec = { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
}

function M.setup()
  vim.cmd.packadd("catppuccin")
  require("catppuccin").setup({
    flavour = "mocha",
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    compile = true,
  })
  vim.cmd.colorscheme("catppuccin-mocha")
end

return M
