---@type vim.lsp.Config
local files = { ".git", ".terraform" }

return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_dirs = vim.fs.root(0, files),
}
