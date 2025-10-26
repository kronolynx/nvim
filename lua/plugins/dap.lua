vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/nvim-neotest/nvim-nio" }, -- dap-ui dependency
  { src = "https://github.com/rcarriga/nvim-dap-ui" }
}, { confirm = false, load = true })

vim.defer_fn(function()
  -- require("nvim-dap-ui").setup(
  --   {
  --     -- Set icons to characters that are more likely to work in every terminal.
  --     --    Feel free to remove or use ones that you like more! :)
  --     --    Don't feel like these are good choices.
  --     icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  --     mappings = {
  --       -- Use a table to apply multiple mappings
  --       expand = { "<CR>", "<2-LeftMouse>" },
  --       open = "o",
  --       remove = "d",
  --       edit = "e",
  --       repl = "r",
  --       toggle = "t",
  --     },
  --     controls = {
  --       icons = {
  --         pause = '⏸',
  --         play = '▶',
  --         step_into = '⏎',
  --         step_over = '⏭',
  --         step_out = '⏮',
  --         step_back = 'b',
  --         run_last = '▶▶',
  --         terminate = '⏹',
  --         disconnect = '⏏',
  --       },
  --     },
  --     layouts = {
  --       {
  --         elements = {
  --           -- Elements can be strings or table with id and size keys.
  --           { id = "scopes", size = 0.25 },
  --           "breakpoints",
  --           "stacks",
  --           "watches",
  --         },
  --         size = 40,     -- 40 columns
  --         position = "left",
  --       },
  --       {
  --         elements = {
  --           "repl",
  --           -- "console",
  --         },
  --         size = 0.25,     -- 25% of total lines
  --         position = "bottom",
  --       },
  --     },
  --     floating = {
  --       max_height = nil,     -- These can be integers or a float between 0 and 1.
  --       max_width = nil,      -- Floats will be treated as percentage of your screen.
  --       mappings = {
  --         close = { "q", "<Esc>" },
  --       },
  --     },
  --     windows = { indent = 1 },
  --     render = {
  --       max_type_length = nil,     -- Can be integer or nil.
  --       -- -- Enable ANSI color support TODO check if this exists
  --       -- ansi_colors = true,
  --     },
  --   })
  --
  vim.keymap.set('n', '<leader>ldr', "<cmd>lua require('dap').continue()<CR>", { desc = '[r]un continue/start' })
  vim.keymap.set('n', '<leader>ldi', "<cmd>lua require('dap').step_into()<CR>", { desc = 'step [i]nto' })
  vim.keymap.set('n', '<leader>ldo', "<cmd>lua require('dap').step_over()<CR>", { desc = 'step [o]ver' })
  vim.keymap.set('n', '<leader>ldO', "<cmd>lua require('dap').step_out()<CR>", { desc = 'step [O]ut' })
  vim.keymap.set('n', '<leader>ldb', "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = 'toggle [b]reakpoint' })
  vim.keymap.set('n', '<leader>ldB', "<cmd>lua require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: '<CR>",
    { desc = 'set [B]reakpoint condition' })
  vim.keymap.set('n', '<leader>ldt', "<cmd>lua require('dapui').toggle()<CR>", { desc = '[t]oggle ui' })
  vim.keymap.set('n', '<leader>lds', "<cmd>FzfLua dap_breakpoints<cr>", { desc = "debug breakpoints" })
  vim.keymap.set('n', '<leader>ldv', "<cmd>FzfLua dap_variables<cr>", { desc = "debug variables" })


  local dap = require 'dap'
  -- local dv = require "dap-view"
  local dapui = require 'dapui'
  local icons = require 'util.icons'

  -- `integratedTerminal`
  -- `externalTerminal`
  -- `externalConsole`
  -- :h metals-nvim-dap
  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "Run or Test",
      console = "integratedTerminal",
      metals = {
        runType = "runOrTestFile",
      }
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      console = "integratedTerminal",
      metals = {
        runType = "testTarget",
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Run or test with input",
      console = "integratedTerminal",
      metals = {
        runType = "runOrTestFile",
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " +")
        end,
      },
    },
    {
      type = "scala",
      request = "attach",
      name = "Attach to Docker",
      hostName = "127.0.0.1", -- or the IP address of your Docker container
      port = 5005,
    },
  }

  -- Lua configurations.
  dap.adapters.nlua = function(callback, config)
    callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
  end
  dap.configurations['lua'] = {
    {
      type = 'nlua',
      request = 'attach',
      name = 'Attach to running Neovim instance',
    },
  }
  -- dap.listeners.before.attach["dap-view-config"] = function()
  --   dv.open()
  -- end
  -- dap.listeners.before.launch["dap-view-config"] = function()
  --   dv.open()
  -- end
  --
  -- -- -- keep UI open
  -- dap.listeners.before.event_terminated["dap-view-config"] = nil
  -- dap.listeners.before.event_exited["dap-view-config"] = nil

  -- TODO deprecated
  -- vim.fn.sign_define("DapBreakpoint", { text = '', texthl = "", linehl = "", numhl = "" })
  -- vim.fn.sign_define("DapStopped", { text = '', texthl = "", linehl = "", numhl = "" })

  -- Automatically open UI
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.launch["dap-view-config"] = function()
    dapui.open()
  end
  -- keep UI open
  dap.listeners.after.event_terminated["dapui_config"] = nil
  dap.listeners.before.event_exited["dapui_config"] = nil

  -- dap.listeners.after.event_terminated["dapui_config"] = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited["dapui_config"] = function()
  --   dapui.close()
  -- end
end, 600)
