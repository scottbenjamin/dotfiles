local M = {
  name = "conform.nvim",
  spec = "https://github.com/stevearc/conform.nvim",
}

local function setup_keymaps()
  local kms = vim.keymap.set

  kms("", "<leader>cf", function()
    require("conform").format({ async = true })
  end, { desc = "Format buffer" })

  kms("", "<leader>tf", function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    Snacks.notify.info("Buffer Autoformat: [ " .. tostring(not vim.b.disable_autoformat) .. " ]")
  end, { desc = "Toggle Autoformat (buffer)" })

  kms("", "<leader>tF", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    Snacks.notify.info("Global Autoformat: [ " .. tostring(not vim.g.disable_autoformat) .. " ]")
  end, { desc = "Toggle Autoformat Globally" })
end

local function init_conform()
  vim.cmd.packadd("conform.nvim")

  require("conform").setup({
    formatters_by_ft = {
      hcl = { "hcl" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      lua = { "stylua" },
      markdown = { "markdownlint-cli2", "markdownfmt" },
      nix = { "alejandra" },
      python = { "ruff", "isort" },
      terraform = { "terraform_fmt" },
      tf = { "terraform_fmt" },
      tofu = { "tofu_fmt" },
      yaml = { "prettier" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  setup_keymaps()
end

function M.setup()
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_conform_setup", { clear = true }),
    callback = init_conform,
  })
end

return M
