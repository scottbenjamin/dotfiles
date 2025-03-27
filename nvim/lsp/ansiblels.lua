---@type vim.lsp.Config

return {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
  root_markers = { "ansible.cfg", ".ansible.lint", ".git" },
  single_file_support = true,
  settings = {
    python = {
      interpreterPath = "python",
    },
    ansible = {
      path = "ansible",
    },
    executionEnvironment = {
      enabled = false,
    },
    validation = {
      enabled = true,
      lint = {
        enabled = true,
        path = "ansible-lint",
      },
    },
  },
}
