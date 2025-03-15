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
    -- Disabled as using conform.nvim for this
    -- if client:supports_method("textDocument/formatting") then
    --   -- Format the current buffer on save
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     buffer = args.buf,
    --     callback = function()
    --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
    --     end,
    --   })
    -- end
  end,
})

-- Enable configured language servers
-- files are loaded from lsp directory
-- vim.lsp.enable("bashls")
-- vim.lsp.enable("gitlab_ci_ls")
vim.lsp.enable("gitlab_ci_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("nixd")
vim.lsp.enable("terraformls")
vim.lsp.enable("tflint")
vim.lsp.enable("yamlls")
vim.lsp.enable("jsonls")
vim.lsp.enable("zls")
