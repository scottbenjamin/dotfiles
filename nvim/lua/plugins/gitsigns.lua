local M = {
  name = "gitsigns.nvim",
  spec = "https://github.com/lewis6991/gitsigns.nvim",
}

local function init_gitsigns()
  vim.cmd.packadd("gitsigns.nvim")
  require("gitsigns").setup({})

  Snacks.toggle({
    name = "Git Signs",
    get = function()
      return require("gitsigns.config").config.signcolumn
    end,
    set = function(state)
      require("gitsigns").toggle_signs(state)
    end,
  }):map("<leader>tG")
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_gitsigns_setup", { clear = true }),
    callback = init_gitsigns,
  })
end

return M
