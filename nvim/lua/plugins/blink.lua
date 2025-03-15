return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  event = "InsertEnter",

  -- use a release tag to download pre-built binaries
  version = "*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    cmdline = { enabled = false },
    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
    },
    completion = {
      menu = {
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline"
        end,
      },
    },

    signature = { enabled = true },
  },
}
