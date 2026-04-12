local M = {
  _setup_done = {},
}

function M.packadd(name)
  vim.cmd.packadd(name)
end

function M.setup_once(name, setup)
  if M._setup_done[name] then
    return
  end
  setup()
  M._setup_done[name] = true
end

function M.packadd_and_setup(name, setup)
  M.packadd(name)
  M.setup_once(name, setup)
end

return M
