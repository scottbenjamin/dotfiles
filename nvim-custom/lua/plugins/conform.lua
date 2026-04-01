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
      if vim.g.autoformat or vim.b[bufnr].autoformat then
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

  local kms = vim.keymap.set
  kms("", "<leader>cf", function()
    require("conform").format({ async = true })
  end, { desc = "Format buffer" })
  kms("", "<leader>tf", function()
    vim.b.autoformat = not vim.b.autoformat
    Snacks.notify.info("Buffer Formatting: [ " .. tostring(vim.b.autoformat) .. " ]")
  end, { desc = "Toggle Format (buffer)" })
  kms("", "<leader>tF", function()
    vim.g.autoformat = not vim.g.autoformat
    Snacks.notify.info("Global Formatting: [ " .. tostring(vim.g.autoformat) .. " ]")
  end, { desc = "Toggle Format Globally" })
end

return M
