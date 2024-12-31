return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    -- Creates a beautiful debugger UI
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
      -- For more information, see |:help nvim-dap-ui|
      opts = {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              -- "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil,  -- Floats will be treated as percentage of your screen.
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
        },
      }
    },
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = { virt_text_pos = 'eol' },
    },
    {
      'LiadOz/nvim-dap-repl-highlights',
      config = true,
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-treesitter/nvim-treesitter",
      },
      build = function()
        if not require("nvim-treesitter.parsers").has_parser("dap_repl") then
          vim.cmd(":TSInstall dap_repl")
        end
      end,
    },
    -- Lua adapter.
    {
      'jbyuki/one-small-step-for-vimkind',
      keys = {
        { '<leader>ldl', "<cmd>lua require('osv').launch { port = 8086 }<CR>", desc = 'Launch Lua adapter' }
      },
    },
  },
  keys = {
    { '<leader>ldr', "<cmd>lua require('dap').continue()<CR>",                                           desc = '[r]un continue/start' },
    { '<leader>ldi', "<cmd>lua require('dap').step_into()<CR>",                                          desc = 'step [i]nto' },
    { '<leader>ldo', "<cmd>lua require('dap').step_over()<CR>",                                          desc = 'step [o]ver' },
    { '<leader>ldO', "<cmd>lua require('dap').step_out()<CR>",                                           desc = 'step [O]ut' },
    { '<leader>ldb', "<cmd>lua require('dap').toggle_breakpoint()<CR>",                                  desc = 'toggle [b]reakpoint' },
    { '<leader>ldB', "<cmd>lua require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: '<CR>", desc = 'set [B]reakpoint condition' },
    { '<leader>ldt', "<cmd>lua require('dapui').toggle()<CR>",                                           desc = '[t]oggle ui' },
    --- FZF
    { "<leader>lds", "<cmd>FzfLua dap_breakpoints<cr>",                                                  desc = "debug breakpoints" },
    { "<leader>ldv", "<cmd>FzfLua dap_variables<cr>",                                                    desc = "debug variables" },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- :h metals-nvim-dap
    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "Run or Test",
        metals = {
          runType = "runOrTestFile",
        }
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Run or test with input",
        metals = {
          runType = "runOrTestFile",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end,
        },
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

    vim.fn.sign_define("DapBreakpoint", { text = '', texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = '', texthl = "", linehl = "", numhl = "" })

    -- Automatically open UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
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
  end,
}
