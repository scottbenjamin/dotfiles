return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes heres
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    lazygit = { enabled = true },
    toggle = { enabled = true },
  },
  keys = {
    -- common
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers", },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep", },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History", },
    { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files", },

    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers", },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File", },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files", },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files", },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent", },

    -- git
    { "<leader>gg", function() Snacks.lazygit.open() end, desc = "Lazygit", },
    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log", },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },

    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers", },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep", },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" }, },

    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers", },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds", },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History", },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands", },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics", },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages", },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights", },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps", },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps", },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List", },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages", },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks", },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume", },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List", },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes", },

    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References", },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation", },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition", },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols", },

    -- UI toggles
    { "<leader>tz", function() Snacks.toggle.zen() end, desc = "Toggle Zenmode", },
    { "<leader>td", function() Snacks.toggle.diagnostics() end, desc = "Toggle Diagnostics", },
  },
}
