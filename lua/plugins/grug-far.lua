-- Find and replace.
return {
  {
    'MagicDuck/grug-far.nvim',
    lazy = true,
    opts = {},
    cmd = 'GrugFar',
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require 'grug-far'
          grug.open {
            transient = true,
            keymaps = { help = '?' },
          }
        end,
        desc = 'replace in files (GrugFar)',
        mode = { 'n', 'v' },
      },
    },
  },
}
