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
    },
  },
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
}

function M.setup()
  require("snacks").setup(M.opts)

  -- stylua: ignore start
  local kms = vim.keymap.set

  -- common
  kms("n", "<leader><space>", function() Snacks.picker.files() end, { desc = "Find Files" })
  kms("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  kms("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
  kms("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
  kms("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })

  -- find
  kms("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
  kms("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
  kms("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
  kms("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
  kms("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })

  -- git
  kms("n", "<leader>gg", function() Snacks.lazygit.open() end, { desc = "Lazygit" })
  kms("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Git Log" })
  kms("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
  kms("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame" })

  -- Grep
  kms("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
  kms("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
  kms({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })

  -- search
  kms("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
  kms("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
  kms("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
  kms("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
  kms("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
  kms("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
  kms("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
  kms("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
  kms("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
  kms("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
  kms("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
  kms("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
  kms("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
  kms("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
  kms("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
  kms("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

  -- LSP
  kms("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
  kms("n", "grr", function() Snacks.picker.lsp_references() end, { desc = "References" })
  kms("n", "gri", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })

  -- UI toggles
  kms("n", "<leader>tz", function() Snacks.toggle.zen() end, { desc = "Toggle Zenmode" })
  kms("n", "<leader>td", function() Snacks.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
  kms("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
  kms("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })

  kms("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
  kms("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })

  -- Notifications
  kms("n", "<leader>n", function()
    if Snacks.config.picker and Snacks.config.picker.enabled then
      Snacks.picker.notifications()
    else
      Snacks.notifier.show_history()
    end
  end, { desc = "Notification History" })
  kms("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
  -- stylua: ignore end
end

return M
