return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
      version = false, -- last release is way too old
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          -- lazy-load schemastore when needed
          -- on_new_config = function(new_config)
          --   new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
          --   vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
          -- end,
          settings = {
            yaml = {
              customTags = { "!reference" },
              format = { enable = true },
              keyOrdering = false,
              schemas = require("schemastore").yaml.schemas(),
              validate = { enable = true },
            },
          },
        },
        terraformls = {},
        ruff_lsp = {},
      },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources, {
        -- Formatting ----------------------------------
        -- nls.builtins.formatting.blue.with({
        --   extra_args = {
        --     "-l120",
        --     "-tpy39",
        --     "--exclude='(.gitlab)'",
        --   },
        -- }),

        nls.builtins.formatting.terraform_fmt,
        nls.builtins.formatting.trim_newlines,
        nls.builtins.formatting.trim_whitespace,
        nls.builtins.formatting.stylua,

        -- Completions ----------------------------------
        nls.builtins.completion.luasnip,

        -- Diagnostics ----------------------------------
        nls.builtins.diagnostics.luacheck,
        nls.builtins.diagnostics.terraform_validate,
        nls.builtins.diagnostics.yamllint,

        -- -- Flake8
        -- nls.builtins.diagnostics.flake8.with({
        --   extra_args = {
        --     "--config=$ROOT/.flake8",
        --     "--max-line-length=120",
        --     "--extend-ignore=E203",
        --   },
        -- }),

        -- Pydocstyle
        -- nls.builtins.diagnostics.pydocstyle.with({
        --   extra_args = { "--config=$ROOT/.pydocstyle" },
        -- }),

        -- Shellcheck
        nls.builtins.diagnostics.shellcheck,
        nls.builtins.code_actions.shellcheck,
        nls.builtins.completion.spell,
      })
    end,
  },
}
