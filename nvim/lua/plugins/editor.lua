local M = {}

local ts_ensure = { "fish", "go", "graphql", "ini", "jq", "just", "make", "rust", "sql", "tmux", "zig" }

local mason_loaded = false

function M.ensure_mason()
  vim.cmd.packadd("mason.nvim")
  vim.cmd.packadd("mason-tool-installer.nvim")
  vim.cmd.packadd("mason-update-all")

  if mason_loaded then
    return
  end

  require("mason").setup()
  require("mason-tool-installer").setup({
    ensure_installed = {
      "basedpyright",
      "lua-language-server",
      "terraform-ls",
      "tflint",
    },
  })

  mason_loaded = true
end

local function setup_treesitter()
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

local function setup_mini()
  vim.cmd.packadd("mini.nvim")
  require("mini.ai").setup()
  require("mini.bracketed").setup()
  require("mini.surround").setup()
  require("mini.move").setup()
  require("mini.pairs").setup()
  require("mini.icons").setup()
end

function M.setup_deferred()
  vim.defer_fn(M.ensure_mason, 100)

  setup_treesitter()
  setup_mini()

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

  vim.cmd.packadd("lazydev.nvim")
  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })

  vim.cmd.packadd("conform.nvim")
  require("plugins.conform").setup()
end

return M
