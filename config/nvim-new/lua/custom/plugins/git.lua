return {
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('telescope').load_extension 'lazygit'
    end,
    vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'LazyGit' }),
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'nvim-telescope/telescope.nvim', -- optional
      'sindrets/diffview.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
    },
    config = true,
    keys = {
      {
        '<leader>gn',
        function()
          require('neogit').open { king = 'split' }
        end,
        desc = "Neogit in file's cwd",
      },
    },
  },
} -- return
