---@type vim.lsp.Config
local files = { "pyproject.toml", "ruff.toml", ".ruff.toml" }
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = files,
  single_file_support = true,
  settings = { hint = { enabled = true } },
}
