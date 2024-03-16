return {
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    lazy = false,
    config = function()
      require('codeium').setup {}
    end,
  },
}
