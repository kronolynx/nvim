vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = 'https://github.com/igorlfs/nvim-dap-view' },
  { src = 'https://github.com/m00qek/baleia.nvim' },
}, { confirm = false, load = true })

vim.defer_fn(function()
  vim.keymap.set('n', '<leader>ldr', "<cmd>lua require('dap').continue()<CR>", { desc = '[r]un continue/start' })
  vim.keymap.set('n', '<leader>ldi', "<cmd>lua require('dap').step_into()<CR>", { desc = 'step [i]nto' })
  vim.keymap.set('n', '<leader>ldo', "<cmd>lua require('dap').step_over()<CR>", { desc = 'step [o]ver' })
  vim.keymap.set('n', '<leader>ldO', "<cmd>lua require('dap').step_out()<CR>", { desc = 'step [O]ut' })
  vim.keymap.set('n', '<leader>ldb', "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = 'toggle [b]reakpoint' })
  vim.keymap.set('n', '<leader>ldB', "<cmd>lua require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: '<CR>",
    { desc = 'set [B]reakpoint condition' })
  vim.keymap.set('n', '<leader>ldt', "<cmd>DapViewToggle<CR>", { desc = '[t]oggle ui' })

  vim.fn.sign_define("DapBreakpoint", { text = '', texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = '', texthl = "", linehl = "", numhl = "" })

  local dap = require 'dap'

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


  -- Automatically open UI
  require('dap-view').setup({
    winbar = {
      default_section = "repl",
      controls = {
        enabled = true
      }
    },
    windows = {
      height = 0.40,
      position = "below",
      terminal = {
        width = 0.5,
        position = "left",
        -- List of debug adapters for which the terminal should be ALWAYS hidden
        hide = {},
        -- Hide the terminal when starting a new session
        start_hidden = true,
      },
    },
    auto_toggle = true,
  })

  -- To colorize scala metals
  vim.g.baleia = require("baleia").setup({
    -- TODO use palette from theme
    colors = {
      [00] = "#51576d", -- black
      [01] = "#e78284", -- red
      [02] = "#a6d189", -- green
      [03] = "#e5c890", -- yellow
      [04] = "#8caaee", -- blue
      [05] = "#f4b8e4", -- magenta
      [06] = "#81c8be", -- cyan
      [07] = "#b5bfe2", -- white / light gray

      [08] = "#626880", -- bright black
      [09] = "#ef9f9f", -- bright red
      [10] = "#b8e994", -- bright green
      [11] = "#f2d791", -- bright yellow
      [12] = "#a5b7ff", -- bright blue
      [13] = "#f7c6ff", -- bright magenta
      [14] = "#a3d9d9", -- bright cyan
      [15] = "#c6d0f5", -- bright white
    },
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "dap-repl",
    callback = function()
      vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
    end,
  })
end, 600)
