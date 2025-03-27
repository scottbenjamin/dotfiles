local kms = vim.keymap.set

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

-- Enable all language servers found in the lsp directory
for _, server in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnameescape(vim.fn.fnamemodify(server, ":t:r"))
  vim.lsp.enable(server_name)
end

-- enable lsp completion
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", {}),

  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    if client:supports_method("textDocument/signatureHelp") then
      kms("n", "gK", function()
        return vim.lsp.buf.signature_help()
      end, { desc = "Show signature help" })
    end

    if client:supports_method("textDocument/hover") then
      kms("n", "K", function()
        return vim.lsp.buf.hover()
      end, { desc = "Show hover" })
    end

    if client:supports_method("textDocument/codeAction") then
      kms({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    end

    kms({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
    kms("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })

    if client:supports_method("textDocument/rename") then
      kms("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
    end

    -- Auto Completion
    if client:supports_method("textDocument/completion") then
      -- Enable auto-completion
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- Inline Hints
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
      Snacks.toggle.inlay_hints():map("<leader>th")
    end

    if client:supports_method("textDocument/codelens") then
      vim.lsp.codelens.refresh({ bufnr = 0 })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = buffer,
        callback = vim.lsp.codelens.refresh,
      })
    end
  end,
})
