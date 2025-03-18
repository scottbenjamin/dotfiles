return {
  cmd = { "helm", "ls", "--all-namespaces", "--output", "json" },
  filetypes = { "helm" },
  root_markers = { ".git", "Chart.yaml" },
  single_file_support = true,
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
}
