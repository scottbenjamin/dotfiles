local disabled_plugins = { "nvim-neo-tree/neo-tree.nvim" }

local function disable_plugins(arr)
  local map = {}

  for index, plugin in ipairs(arr) do
    local this = { index, enabled = false }
    table.insert(map, this)
  end

  return map
end

return disable_plugins(disabled_plugins)
