return {
  'rcarriga/nvim-notify',
  enable = false,
  keys = {
    {
      '<leader>nd',
      function()
        require('notify').dismiss({ silent = true, pending = true })
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<leader>nh',
      function()
        require("notify").history()
      end,
      desc = "Show Notification History"
    }
  },
  init = function()
    local nvim_notify = require("notify")

    nvim_notify.setup {
      -- Animation style
      stages = "fade_in_slide_out",
      -- Default timeout for notifications
      timeout = 3000,
    }

    vim.notify = nvim_notify
    -- override the default print function to use nvim-notify
    -- -- TODO not needed with extui
    -- print = function(...)
    --   local print_safe_args = {}
    --   local _ = { ... }
    --   for i = 1, #_ do
    --     table.insert(print_safe_args, tostring(_[i]))
    --   end
    --   vim.notify(table.concat(print_safe_args, ' '), "info")
    -- end
  end
}
