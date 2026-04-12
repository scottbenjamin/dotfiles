local M = {
  name = "nvim-treesitter",
  spec = "https://github.com/nvim-treesitter/nvim-treesitter",
}

local ts_ensure = { "fish", "go", "graphql", "ini", "jq", "just", "make", "rust", "sql", "tmux", "zig" }

local function init_treesitter()
  vim.cmd.packadd("nvim-treesitter")
  require("nvim-treesitter").setup()

  vim.defer_fn(function()
    local missing = {}
    for _, lang in ipairs(ts_ensure) do
      if not pcall(vim.treesitter.language.inspect, lang) then
        missing[#missing + 1] = lang
      end
    end
    if #missing > 0 then
      vim.cmd("TSInstall " .. table.concat(missing, " "))
    end
  end, 0)
end

function M.setup()
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_treesitter_setup", { clear = true }),
    callback = init_treesitter,
  })
end

return M
