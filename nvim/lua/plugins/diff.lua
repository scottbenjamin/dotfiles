return {
  -- {
  --   "julienvincent/hunk.nvim",
  --   cmd = { "DiffEditor" },
  --   config = function()
  --     require("hunk").setup()
  --   end,
  -- },
  {
    "esmuellert/vscode-diff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
  },
}
