vim.pack.add({
  -- Improved quickfix UI.
  { src = "https://github.com/stevearc/quicker.nvim" },
  { src = "https://github.com/kevinhwang91/nvim-bqf", { ft = "qf" } }
}, { confirm = false })


vim.defer_fn(function()
  require("quicker").setup({
    borders = {
      -- Thinner separator.
      vert = require('util.icons').misc.vertical_bar,
    },
    keys = {
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
  })

  -- vim.keymap.set("n", "<leader>qq", function() require('quicker').toggle() end, { desc = "Toggle quicker" })
  --
  -- vim.keymap.set("n", '<leader>ql', function() require('quicker').toggle { loclist = true } end,
  --   { desc = 'Toggle loclist list' })

  vim.keymap.set("n", '<leader>qw',
    function()
      local quicker = require 'quicker'

      if quicker.is_open() then
        quicker.close()
      else
        local diagnostics = vim.diagnostic.get()
        if next(diagnostics) == nil then
          vim.notify("No diagnostics found")
        else
          vim.diagnostic.setqflist()
          -- vim.diagnostic.setqflist({severity = vim.diagnostic.severity.ERROR})
        end
      end
    end,
    { desc = 'diagnostics workspace' })

  vim.keymap.set("n", '<leader>qb',
    function()
      local quicker = require 'quicker'

      if quicker.is_open() then
        quicker.close()
      else
        local diagnostics = vim.diagnostic.get(0)
        if next(diagnostics) == nil then
          vim.notify("No diagnostics found")
        else
          vim.diagnostic.setloclist()
          -- vim.diagnostic.setloclist({severity = vim.diagnostic.severity.ERROR})
        end
      end
    end,
    { desc = 'diagnostics buffer' })
end, 600)
