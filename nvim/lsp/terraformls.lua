---@type vim.lsp.Config
return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform" },
  on_attach = function(client)
    -- Workaround: terraform-ls emits negative deltaStart for heredoc
    -- interpolations, causing infinite loop in nvim 0.12 semantic tokens.
    -- https://github.com/hashicorp/terraform-ls/issues/2094
    client.server_capabilities.semanticTokensProvider = nil
  end,
}
