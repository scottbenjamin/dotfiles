local M = {
  name = "conform.nvim",
  spec = "https://github.com/stevearc/conform.nvim",
  event = "UIEnter",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
    {
      "<leader>tf",
      function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        Snacks.notify.info("Buffer Autoformat: [ " .. tostring(not vim.b.disable_autoformat) .. " ]")
      end,
      mode = "",
      desc = "Toggle Autoformat (buffer)",
    },
    {
      "<leader>tF",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        Snacks.notify.info("Global Autoformat: [ " .. tostring(not vim.g.disable_autoformat) .. " ]")
      end,
      mode = "",
      desc = "Toggle Autoformat Globally",
    },
  },
  opts = {
    formatters_by_ft = {
      hcl = { "hcl" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      lua = { "stylua" },
      markdown = { "prettier", "markdownlint-cli2" },
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
  },
}

function M.config(_, opts)
  require("conform").setup(opts)
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M
