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

  {
    'SuperBo/fugit2.nvim',
    enabled = false,
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim', -- optional: for Diffview
    },
    cmd = { 'Fugit2', 'Fugit2Graph' },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' },
    },
  },

  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next git [c]hange' })

        map({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = false }
        end, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = '[T]oggle git show [d]eleted' })
      end,
    },
  },

  {
    'NeogitOrg/neogit',
    branch = 'nightly',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
    },
    config = function()
      local ng = require 'neogit'
      ng.setup {
        vim.keymap.set('n', '<leader>cs', ng.open, { silent = true, desc = 'Open Neogit' }),
        vim.keymap.set('n', '<leader>cc', ':Neogit commit<cr>', { silent = true, desc = 'Neogit open commits' }),
        vim.keymap.set('n', '<leader>cp', ':Neogit pull<cr>', { silent = true, desc = 'Neogit pull' }),
        vim.keymap.set('n', '<leader>cP', ':Neogit push<cr>', { silent = true, desc = 'Neogit push' }),
        vim.keymap.set('n', '<leader>cb', ':Telescope git_branches<cr>', { silent = true, desc = 'Git branches' }),
        -- TODO: Add binding for git blame
      }
    end,
  },
}
