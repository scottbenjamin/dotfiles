vim.lsp.log.set_level("OFF")

-- Global LSP capabilities (blink.cmp integration)
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Enable all servers found in lsp/
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local servers = {}
local configured_cmds = {}
for name, type in vim.fs.dir(lsp_dir) do
  if type == "file" and name:match("%.lua$") then
    local server = name:gsub("%.lua$", "")
    servers[#servers + 1] = server
    local ok, cfg = pcall(dofile, lsp_dir .. "/" .. name)
    if ok and cfg and cfg.cmd and cfg.cmd[1] then
      configured_cmds[cfg.cmd[1]] = server
    end
  end
end
vim.lsp.enable(servers)

-- :LspCheck — show mason-installed LSP servers missing a lsp/ config
vim.api.nvim_create_user_command("LspCheck", function()
  local registry = require("mason-registry")
  registry.refresh()
  local missing = {}
  for _, pkg in ipairs(registry.get_installed_packages()) do
    if vim.list_contains(pkg.spec.categories or {}, "LSP") then
      local bins = vim.tbl_keys(pkg.spec.bin or {})
      local has_config = false
      for _, bin in ipairs(bins) do
        if configured_cmds[bin] then
          has_config = true
          break
        end
      end
      if not has_config then
        missing[#missing + 1] = pkg.name .. "  (bin: " .. table.concat(bins, ", ") .. ")"
      end
    end
  end
  if #missing == 0 then
    vim.notify("All mason LSP servers have configs in lsp/", vim.log.levels.INFO)
  else
    vim.notify("Mason LSP servers missing lsp/ config:\n  " .. table.concat(missing, "\n  "), vim.log.levels.WARN)
  end
end, { desc = "Check mason LSP servers against lsp/ configs" })
