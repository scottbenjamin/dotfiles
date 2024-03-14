local M = {}

local function getPath(str, sep)
  sep = sep or '/'
  return str:match('(.*' .. sep .. ')')
end

function M.get_buf_cwd()
  return getPath(vim.api.nvim_buf_get_name(0))
end

return M
