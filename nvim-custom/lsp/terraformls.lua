---@type vim.lsp.Config
local files = { ".terraform" }

return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = files,
}
