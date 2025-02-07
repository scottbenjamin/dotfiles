return {
  "saghen/blink.cmp",
  event = "VeryLazy",

  -- optional: provides snippets for the snippet source
  dependencies = "rafamadriz/friendly-snippets",

  -- use a release tag to download pre-built binaries
  version = "*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    completion = {
      menu = {
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline"
        end,
      },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    signature = { enabled = true },
  },
}
