---@tyrfore vim.lsp.Config
return {
  cmd = { "tflint", "--langserver" },
  filetypes = { "terraform" },
  root_markers = { ".terraform", ".tflint.hcl" },
}
