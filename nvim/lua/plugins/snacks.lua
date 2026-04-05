local M = {}

M.opts = {
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
        { icon = "󰒲 ", key = "u", desc = "Update Plugins", action = ":PackUpdate" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "recent_files", limit = 5, padding = 1 },
    },
  },
  explorer = { enabled = false },
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
}

function M.setup()
  require("snacks").setup(M.opts)

  local kms = vim.keymap.set

  -- Picker keymaps: { lhs, picker, opts, desc }
  -- stylua: ignore start
  local picker_keys = {
    -- common
    { "<leader><space>", "files",                nil,                                "Find Files" },
    { "<leader>,",       "buffers",              nil,                                "Buffers" },
    { "<leader>/",       "grep",                 nil,                                "Grep" },
    { "<leader>:",       "command_history",       nil,                                "Command History" },
    -- find
    { "<leader>fb",      "buffers",              nil,                                "Buffers" },
    { "<leader>fc",      "files",                { cwd = vim.fn.stdpath("config") }, "Find Config File" },
    { "<leader>fg",      "git_files",            nil,                                "Find Git Files" },
    { "<leader>fr",      "recent",               nil,                                "Recent" },
    -- git
    { "<leader>gc",      "git_log",              nil,                                "Git Log" },
    { "<leader>gs",      "git_status",           nil,                                "Git Status" },
    -- grep / search
    { "<leader>sb",      "lines",                nil,                                "Buffer Lines" },
    { "<leader>sB",      "grep_buffers",         nil,                                "Grep Open Buffers" },
    { '<leader>s"',      "registers",            nil,                                "Registers" },
    { "<leader>sa",      "autocmds",             nil,                                "Autocmds" },
    { "<leader>sC",      "commands",             nil,                                "Commands" },
    { "<leader>sd",      "diagnostics",          nil,                                "Diagnostics" },
    { "<leader>sh",      "help",                 nil,                                "Help Pages" },
    { "<leader>sH",      "highlights",           nil,                                "Highlights" },
    { "<leader>sj",      "jumps",                nil,                                "Jumps" },
    { "<leader>sk",      "keymaps",              nil,                                "Keymaps" },
    { "<leader>sl",      "loclist",              nil,                                "Location List" },
    { "<leader>sM",      "man",                  nil,                                "Man Pages" },
    { "<leader>sm",      "marks",                nil,                                "Marks" },
    { "<leader>sR",      "resume",               nil,                                "Resume" },
    { "<leader>ss",      "lsp_symbols",          nil,                                "LSP Symbols" },
    { "<leader>sS",      "lsp_workspace_symbols", nil,                               "LSP Workspace Symbols" },
    { "<leader>sq",      "qflist",               nil,                                "Quickfix List" },
    { "<leader>uC",      "colorschemes",         nil,                                "Colorschemes" },
    -- LSP navigation
    { "gd",              "lsp_definitions",      nil,                                "Goto Definition" },
    { "grr",             "lsp_references",       nil,                                "References" },
    { "gri",             "lsp_implementations",  nil,                                "Goto Implementation" },
  }
  -- stylua: ignore end

  for _, k in ipairs(picker_keys) do
    kms("n", k[1], function()
      Snacks.picker[k[2]](k[3])
    end, { desc = k[4] })
  end

  -- Multi-mode picker
  kms({ "n", "x" }, "<leader>sw", function()
    Snacks.picker.grep_word()
  end, { desc = "Visual selection or word" })

  -- Non-picker Snacks keymaps (different APIs, kept explicit)
  -- stylua: ignore start
  kms("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
  kms("n", "<leader>gg", function() Snacks.lazygit.open() end,       { desc = "Lazygit" })
  kms("n", "<leader>gb", function() Snacks.git.blame_line() end,     { desc = "Git Blame" })
  kms("n", "<leader>tz", function() Snacks.toggle.zen() end,         { desc = "Toggle Zenmode" })
  kms("n", "<leader>td", function() Snacks.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
  kms("n", "<leader>bd", function() Snacks.bufdelete() end,          { desc = "Delete Buffer" })
  kms("n", "<leader>bo", function() Snacks.bufdelete.other() end,    { desc = "Delete Other Buffers" })
  kms("n", "<leader>.",  function() Snacks.scratch() end,            { desc = "Toggle Scratch Buffer" })
  kms("n", "<leader>S",  function() Snacks.scratch.select() end,     { desc = "Select Scratch Buffer" })
  kms("n", "<leader>un", function() Snacks.notifier.hide() end,      { desc = "Dismiss All Notifications" })
  -- stylua: ignore end

  -- Notifications (conditional logic)
  kms("n", "<leader>n", function()
    if Snacks.config.picker and Snacks.config.picker.enabled then
      Snacks.picker.notifications()
    else
      Snacks.notifier.show_history()
    end
  end, { desc = "Notification History" })
end

return M
