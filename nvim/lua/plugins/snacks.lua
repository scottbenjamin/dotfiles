return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      formatters = {
        file = {
          truncate = 80,
        },
      },
      icons = {
        files = { enabled = false },
      },
      matcher = { frecency = true },
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    toggle = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    -- stylua: ignore start
    -- common
    { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files", },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers", },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep", },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History", },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },

    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers", },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File", },
    -- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files", },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files", },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent", },
    {"<leader>cR", function() Snacks.rename.rename_file() end,  desc = "Rename File" } ,

   -- git
    { "<leader>gg", function() Snacks.lazygit.open() end, desc = "Lazygit", },
    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log", },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },
    {"<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame"},

    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers", },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" }, },

    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers", },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds", },
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
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols", },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace aSymbols", },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List", },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes", },

    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", },
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References", },
    { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation", },
    -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition", },

    -- UI toggles
    { "<leader>tz", function() Snacks.toggle.zen() end, desc = "Toggle Zenmode", },
    { "<leader>td", function() Snacks.toggle.diagnostics() end, desc = "Toggle Diagnostics", },
    {"<leader>bd", function() Snacks.bufdelete() end,  desc = "Delete Buffer" },
    {"<leader>bo", function() Snacks.bufdelete.other() end,  desc = "Delete Other Buffers" },

    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    -- stylua: ignore end

    -- Notificiations
    {
      "<leader>n",
      function()
        if Snacks.config.picker and Snacks.config.picker.enabled then
          Snacks.picker.notifications()
        else
          Snacks.notifier.show_history()
        end
      end,
      desc = "Notification History",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
  },
}
