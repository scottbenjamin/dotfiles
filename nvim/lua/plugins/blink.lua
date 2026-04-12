local M = {
  name = "blink.cmp",
  spec = { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.10.x") },
}

local function init_blink()
  pcall(vim.cmd.packadd, "friendly-snippets")
  pcall(vim.cmd.packadd, "colorful-menu.nvim")
  vim.cmd.packadd("blink.cmp")

  require("colorful-menu").setup()
  require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = false },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  })

  require("lsp")
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    group = vim.api.nvim_create_augroup("plugin_blink_setup", { clear = true }),
    callback = init_blink,
  })
end

return M
