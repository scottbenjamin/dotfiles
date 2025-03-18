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

-- example override
-- vim.lsp.config("lua", { filetypes = { "lua" } })

-- enable lsp completion
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),

  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Keymaps for LSP
    -- kms("n", "<leader>th", function()
    --   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
    -- end, { desc = "Toggle Inlay Hints" })

    kms("n", "gK", function()
      return vim.lsp.buf.signature_help()
    end, { desc = "Show signature help" })

    kms({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    kms({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
    kms("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
    kms("n", "<leader>cR", function()
      Snacks.rename.rename_file()
    end, { desc = "Rename File" })
    kms("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

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

-- Enable all language servers found in the lsp directory
for _, server in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnameescape(vim.fn.fnamemodify(server, ":t:r"))
  vim.lsp.enable(server_name)
end
