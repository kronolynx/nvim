-- Improved quickfix UI.
return {
  {
    'stevearc/quicker.nvim',
    -- enabled = false,
    event = 'VeryLazy',
    opts = {
      borders = {
        -- Thinner separator.
        vert = require('util.icons').misc.vertical_bar,
      },
    },
    keys = {
      {
        '<leader>qq',
        function()
          require('quicker').toggle()
        end,
        desc = 'Toggle quickfix',
      },
      {
        '<leader>ql',
        function()
          require('quicker').toggle { loclist = true }
        end,
        desc = 'Toggle loclist list',
      },
      {
        '<leader>dt',
        function()
          local quicker = require 'quicker'

          if quicker.is_open() then
            quicker.close()
          else
            vim.diagnostic.setqflist()
          end
        end,
        desc = 'Toggle diagnostics list',
      },
      {
        '>',
        function()
          require('quicker').expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = 'Expand context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse context',
      },
    },
  },
}
