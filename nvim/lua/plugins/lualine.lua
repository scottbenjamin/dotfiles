local M = {
  name = "lualine.nvim",
  spec = "https://github.com/nvim-lualine/lualine.nvim",
}

function M.setup()
  pcall(vim.cmd.packadd, "nvim-web-devicons")
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
