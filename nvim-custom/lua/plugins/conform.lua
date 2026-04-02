local M = {}

function M.setup()
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
      return { timeout_ms = 500 }
    end,
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  local kms = vim.keymap.set
  kms("", "<leader>cf", function()
    require("conform").format({ async = true })
  end, { desc = "Format buffer" })
  kms("", "<leader>tf", function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    local state = vim.b.disable_autoformat and "off" or "on"
    Snacks.notify.info("Buffer format-on-save: " .. state)
  end, { desc = "Toggle Format (buffer)" })
  kms("", "<leader>tF", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    local state = vim.g.disable_autoformat and "off" or "on"
    Snacks.notify.info("Global format-on-save: " .. state)
  end, { desc = "Toggle Format Globally" })
end

return M
