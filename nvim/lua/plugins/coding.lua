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
    -- https://github.com/esensar/nvim-dev-container
    "https://codeberg.org/esensar/nvim-dev-container",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("devcontainer").setup({
        container_runtime = "docker",
        backup_runtime = "docker-compose",
      })
    end,
  },
}
