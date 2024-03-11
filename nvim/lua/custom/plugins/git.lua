return {
  {
    'thePrimeagen/git-worktree.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {},
    config = function()
      require('telescope').load_extension 'git_worktree'

      vim.keymap.set('n', '<leader>cw', function()
        require('telescope').extensions.git_worktree.git_worktrees()
      end, { noremap = true, silent = true, desc = 'View/select git [w]orktrees' })

      vim.keymap.set('n', '<leader>cW', function()
        require('telescope').extensions.git_worktree.create_git_worktree()
      end, { noremap = true, silent = true, desc = 'Create git [W]orktree' })
    end,
  },
}
