local M = {}

function M.setup()
  vim.cmd.packadd("catppuccin")
  require("catppuccin").setup({
    flavour = "mocha",
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    compile = true,
  })
  vim.cmd.colorscheme("catppuccin-mocha")

  vim.cmd.packadd("snacks.nvim")
  require("plugins.snacks").setup()

  vim.cmd.packadd("nvim-web-devicons")
  vim.cmd.packadd("lualine.nvim")
  require("lualine").setup({
    options = {
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "diagnostics", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

return M
