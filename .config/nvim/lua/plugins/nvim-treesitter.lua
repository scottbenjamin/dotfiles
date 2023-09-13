return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "dockerfile",
          "hcl",
          "json",
          "json5",
          "jsonc",
          "lua",
          "ninja",
          "python",
          "regex",
          "rst",
          "terraform",
          "toml",
          "vimdoc",
          "yaml",
        })
      end
    end,
  },
}
