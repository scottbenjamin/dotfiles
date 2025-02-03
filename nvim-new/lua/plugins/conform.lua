return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
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
          vim.b.autoformat = not vim.b.autoformat
          Snacks.notify.info(" Buffer Formatting: [ " .. tostring(not vim.b.autoformat) .. " ]")
        end,
        mode = "",
        desc = "Toggle Format (buffer)",
      },
      {
        "<leader>tF",
        function()
          vim.g.autoformat = not vim.g.autoformat
          Snacks.notify.info(" Global Formatting: [ " .. tostring(not vim.g.autoformat) .. " ]")
        end,
        mode = "",
        desc = "Toggle Format Globally",
      },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        hcl = { "terragrunt_hclfmt" },
        tofu = { "tofu_fmt" },
        nu = { "alejandra" },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Don't format if it's toggled off globally or for the buffer
        if vim.g.autoformat or vim.b[bufnr].autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
