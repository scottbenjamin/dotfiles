-- Leader keys (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---- Plugin management (vim.pack) ----------------------------------------

local gh = function(x)
  return "https://github.com/" .. x
end

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

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  if opts.bang then
    -- :PackUpdate! opens the native vim.pack confirmation buffer
    Snacks.notify.info("Fetching plugin updates...")
    vim.schedule(function()
      vim.pack.update()
    end)
    return
  end

  -- Snapshot current revisions
  local before = {}
  for _, p in ipairs(vim.pack.get(nil, { info = false })) do
    before[p.spec.name] = p.rev
  end

  -- Fetch and force-apply updates
  Snacks.notify.info("Fetching plugin updates...")
  vim.schedule(function()
    vim.pack.update(nil, { force = true })

    -- Compare revisions after update
    vim.schedule(function()
      local after = vim.pack.get(nil, { info = false })
      local updated = {}
      local up_to_date = 0
      for _, p in ipairs(after) do
        local old_rev = before[p.spec.name]
        if old_rev and old_rev ~= p.rev then
          updated[#updated + 1] = string.format("  %s  %s -> %s", p.spec.name, old_rev:sub(1, 8), p.rev:sub(1, 8))
        else
          up_to_date = up_to_date + 1
        end
      end

      if #updated == 0 then
        Snacks.notify.info("All " .. up_to_date .. " plugins up to date.", { title = "Pack Update" })
      else
        local msg = #updated .. " updated, " .. up_to_date .. " unchanged:\n\n" .. table.concat(updated, "\n")
        Snacks.notify.info(msg, { title = "Pack Update", timeout = 15000 })
      end
    end)
  end)
end, { bang = true, desc = "Update plugins (! for native vim.pack UI)" })

vim.api.nvim_create_user_command("PackStatus", function()
  local plugins = vim.pack.get(nil, { info = false })
  local lines = {}
  for _, p in ipairs(plugins) do
    local name = p.spec.name
    local rev = p.rev:sub(1, 8)
    local version = p.spec.version
    local tag = ""
    if type(version) == "string" then
      tag = " (" .. version .. ")"
    end
    local status = p.active and "loaded" or "not loaded"
    lines[#lines + 1] = string.format("  %-28s %s  %s%s", name, rev, status, tag)
  end
  table.sort(lines)
  local header = string.format("Plugins: %d total\n", #plugins)
  Snacks.notify.info(header .. table.concat(lines, "\n"), { title = "Pack Status", timeout = 10000 })
end, { desc = "Show plugin status summary" })

---- Tier 1: Immediate ---------------------------------------------------

-- Colorscheme
vim.cmd.packadd("catppuccin")
require("catppuccin").setup({ flavour = "mocha" })
vim.cmd.colorscheme("catppuccin-mocha")

-- Snacks (core UI framework)
vim.cmd.packadd("snacks.nvim")
require("plugins.snacks").setup()

-- Oil (file browser)
vim.cmd.packadd("nvim-web-devicons")
vim.cmd.packadd("oil.nvim")
require("oil").setup({})

-- Lualine (statusline)
vim.cmd.packadd("lualine.nvim")
require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- Mason (LSP installer)
vim.cmd.packadd("mason.nvim")
vim.cmd.packadd("mason-tool-installer.nvim")
vim.cmd.packadd("mason-update-all")
require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    "basedpyright",
    "lua-language-server",
    "terraform-ls",
    "tflint",
  },
})
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

-- Blink.cmp (completion)
vim.cmd.packadd("friendly-snippets")
vim.cmd.packadd("colorful-menu.nvim")
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

---- Core config ----------------------------------------------------------

require("options")
require("lsp")
require("keymaps")
require("neovide")

---- Tier 2: Deferred (UIEnter) ------------------------------------------

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    -- mini.nvim
    vim.cmd.packadd("mini.nvim")
    require("mini.ai").setup()
    require("mini.bracketed").setup()
    require("mini.surround").setup()
    require("mini.move").setup()
    require("mini.pairs").setup()
    require("mini.icons").setup()

    -- which-key
    vim.cmd.packadd("which-key.nvim")
    require("which-key").setup({
      preset = "helix",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file" },
          { "<leader>g", group = "git" },
          { "<leader>s", group = "search" },
          { "<leader>t", group = "toggle" },
          { "<leader>u", group = "ui" },
        },
      },
    })

    -- lazydev (lua LSP enhancement)
    vim.cmd.packadd("lazydev.nvim")
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    })

    -- conform (formatting)
    vim.cmd.packadd("conform.nvim")
    require("plugins.conform").setup()
  end,
})

---- Tier 3: Event-driven ------------------------------------------------

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    -- gitsigns
    vim.cmd.packadd("gitsigns.nvim")
    require("gitsigns").setup({})
    Snacks.toggle({
      name = "Git Signs",
      get = function()
        return require("gitsigns.config").config.signcolumn
      end,
      set = function(state)
        require("gitsigns").toggle_signs(state)
      end,
    }):map("<leader>tG")

    -- lint
    vim.cmd.packadd("nvim-lint")
    require("plugins.lint").setup()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  once = true,
  callback = function()
    vim.cmd.packadd("quicker.nvim")
    require("quicker").setup({})
  end,
})

---- Tier 4: On-demand (keymap/command) -----------------------------------

-- Trouble (diagnostics viewer)
local trouble_keys = {
  { "<leader>tx", "diagnostics toggle" },
  { "<leader>tX", "diagnostics toggle filter.buf=0" },
  { "<leader>ts", "symbols toggle focus=false" },
  { "<leader>tl", "lsp toggle focus=false win.position=right" },
  { "<leader>tL", "loclist toggle" },
  { "<leader>tQ", "qflist toggle" },
}
for _, key in ipairs(trouble_keys) do
  vim.keymap.set("n", key[1], function()
    vim.cmd.packadd("trouble.nvim")
    require("trouble").setup({})
    vim.cmd("Trouble " .. key[2])
  end, { desc = "Trouble: " .. key[2] })
end

-- nvim-ansible
vim.keymap.set("n", "<leader>ta", function()
  vim.cmd.packadd("nvim-ansible")
  require("ansible").run()
end, { desc = "Ansible Run Playbook/Role", silent = true })
