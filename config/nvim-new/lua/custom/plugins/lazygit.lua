return {
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },

    config = function()
      require 'lazygit'
      require('telescope').load_extension 'lazygit'
      vim.keymap.set('n', '<leader>cg', ':LazyGitCurrentFile<cr>', { desc = 'LazyGit cwd of file' })
      vim.keymap.set('n', '<leader>cG', ':LazyGit<cr', { desc = 'LazyGit root' })
    end,
  },
}
