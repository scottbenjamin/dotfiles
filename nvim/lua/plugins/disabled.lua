local disabled_plugins = {
  "nvim-neo-tree/neo-tree.nvim",
}

local disabled = {}
for _, v in pairs(disabled_plugins) do
  table.insert(disabled, { v, enabled = false })
end

return disabled
