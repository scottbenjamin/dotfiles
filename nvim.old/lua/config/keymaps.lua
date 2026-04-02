-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local kms = vim.keymap.set

-- Create Gitlab Team MR
function GlabMR(draft)
  draft = draft or false
  local cmd = "glab mr create -fw"

  if vim.fn.hostname() == "M-WQ43L-ASB" then
    cmd = cmd .. "-a sbenjamin --reviewer dmildh --reviewer jkaiser"
  end

  if draft then
    cmd = cmd .. " --draft"
  end

  -- Run command in background without opening terminal
  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("MR created successfully!", vim.log.levels.INFO)
      else
        vim.notify("Failed to create MR", vim.log.levels.ERROR)
      end
    end,
  })
end
-- Remaps keys to keep cursor in the middle of the screen
kms("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
kms("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
kms("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Esc from terminal", silent = true })

--  Glab CLI
kms("n", "<leader>gM", "<cmd>!glab mr create -fw<CR>", { desc = "Create new MR in browser", silent = true })
kms("n", "<leader>gm", "<cmd>!glab mr view -w<CR>", { desc = "Open MR in browser", silent = true })
kms("n", "<leader>gj", "<cmd>!glab ci view -w<CR>", { desc = "Open CI Jobs in browser", silent = true })

kms("n", "<leader>gO", function()
  GlabMR(true)
end, { desc = "Open Team DRAFT MR in browser", silent = true })
kms("n", "<leader>go", function()
  GlabMR()
end, { desc = "Open Team MR in browser", silent = true })
