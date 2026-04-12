local M = {
  name = "nvim-ansible",
  spec = "https://github.com/mfussenegger/nvim-ansible",
}

function M.setup()
  vim.keymap.set("n", "<leader>ta", function()
    vim.cmd.packadd("nvim-ansible")
    require("ansible").run()
  end, { desc = "Ansible Run Playbook/Role", silent = true })
end

return M
