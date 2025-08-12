return {
  'akinsho/toggleterm.nvim',
  enabled = false,
  event = "VeryLazy",
  opts = {
    -- direction = 'horizontal',
    direction = 'float',
    open_mapping = [[<M-r>]],
    auto_scroll = false
  },
  config = function(_, opts)
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      dir = 'git_dir',
      direction = 'float',
      count = 0
    })

    require("toggleterm").setup(opts)
    -- vim.keymap.set('n', '<leader>ml', function() lazygit:toggle() end, {
    --   desc = 'lazygit',
    -- })
  end
}
