if vim.g.neovide then
  if vim.uv.os_uname().sysname == "Darwin" then
    vim.o.guifont = "JetBrainsMono Nerd Font Mono:h13"
  else
    vim.o.guifont = "JetBrainsMono Nerd Font Mono:h10"
  end
end
