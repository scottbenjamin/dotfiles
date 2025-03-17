-- setup neovim 0.11 lsp config
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})

-- example override
-- vim.lsp.config("lua", { filetypes = { "lua" } })

-- enable lsp completion
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),

  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/implementation") then
      -- Create a keymap for vim.lsp.buf.implementation
    end
    if client:supports_method("textDocument/completion") then
      -- Enable auto-completion
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      Snacks.toggle.inlay_hints():map("<leader>th")
    end
  end,
})

-- Enable all language servers found in the lsp directory
for _, server in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnameescape(vim.fn.fnamemodify(server, ":t:r"))
  vim.lsp.enable(server_name)
end
