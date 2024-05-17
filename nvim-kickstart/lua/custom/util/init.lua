local M = {}

local function getPath(str, sep)
  sep = sep or '/'
  return str:match('(.*' .. sep .. ')')
end

function M.get_buf_cwd()
  x = getPath(vim.api.nvim_buf_get_name(0))
  return x
end

return M
