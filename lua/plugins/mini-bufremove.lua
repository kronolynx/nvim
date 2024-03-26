return {
  'echasnovski/mini.bufremove',
  config = true,
  lazy = true,
  keys = {
    {
      '<leader>td',
      function()
        require('mini.bufremove').delete(0, false)
      end,
      desc = 'delete',
    },
  }
}
