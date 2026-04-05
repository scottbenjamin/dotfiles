local M = {}

local gh = function(x)
  return "https://github.com/" .. x
end

function M.add()
  vim.pack.add({
    -- colorscheme
    { src = gh("catppuccin/nvim"), name = "catppuccin" },

    -- core ui
    gh("folke/snacks.nvim"),
    gh("stevearc/oil.nvim"),
    gh("nvim-lualine/lualine.nvim"),
    gh("nvim-tree/nvim-web-devicons"),

    -- completion
    { src = gh("saghen/blink.cmp"), version = vim.version.range("1.10.x") },
    gh("rafamadriz/friendly-snippets"),
    gh("xzbdmw/colorful-menu.nvim"),

    -- lsp tooling
    gh("williamboman/mason.nvim"),
    gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
    gh("RubixDev/mason-update-all"),

    -- deferred
    gh("nvim-treesitter/nvim-treesitter"),
    gh("echasnovski/mini.nvim"),
    gh("folke/which-key.nvim"),
    gh("folke/lazydev.nvim"),
    gh("stevearc/conform.nvim"),

    -- event-driven
    gh("lewis6991/gitsigns.nvim"),
    gh("mfussenegger/nvim-lint"),
    gh("stevearc/quicker.nvim"),

    -- on-demand
    gh("folke/trouble.nvim"),
    gh("mfussenegger/nvim-ansible"),
  })
end

return M
