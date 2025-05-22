if vim.g.neovide then
  if vim.fn.has('macunix') then
    vim.o.guifont = "JetBrainsMono Nerd Font Mono:h13"
  else
    vim.o.guifont = "JetBrainsMono Nerd Font Mono:h11"
  end
end
