return {
  'SuperBo/fugit2.nvim',
  lazy = true,
  -- requires libgit2 installed in the OS
  opts = {},
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
    "sindrets/diffview.nvim", -- optional
  },
  cmd = { 'Fugit2', 'Fugit2Graph' },
  keys = {
    { '<leader>mf', mode = 'n', '<cmd>Fugit2<cr>', desc = "fugit" }
  }
}
