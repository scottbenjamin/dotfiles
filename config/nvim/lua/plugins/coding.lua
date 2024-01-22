return {
  -- helm templates
  { "towolf/vim-helm" },
  { "b0o/SchemaStore.nvim" },

  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        yaml = true,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        markdown = { "markdownlint" },
        python = { "ruff_fix", "isort", "darker" },
        shell = { "shfmt", "shellharden" },
        sql = { "sql_formatter" },
        terraform = { "terraform_fmt" },
        yaml = { "yamlfmt" },
        ["*"] = { "trim_whitespace", "trim_lines" }, -- Run on all files
      },
    },
  },
}
