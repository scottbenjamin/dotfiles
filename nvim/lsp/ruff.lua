local files = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" }
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_dir = vim.fs.root(0, files),
  single_file_support = true,
  settings = { hint = { enabled = true } },
}
