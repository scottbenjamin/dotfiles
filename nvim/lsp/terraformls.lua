---@type vim.lsp.Config

return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".git", ".terraform" },
}
