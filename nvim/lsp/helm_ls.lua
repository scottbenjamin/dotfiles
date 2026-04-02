---@type vim.lsp.Config
return {
  cmd = { "helm", "ls", "--all-namespaces", "--output", "json" },
  filetypes = { "helm" },
  root_markers = { "Chart.yaml" },
  single_file_support = true,
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
}
