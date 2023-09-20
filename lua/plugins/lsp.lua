local api = vim.api
local on_attach = function(_, bufnr)
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

return {{
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>",                 desc = "Rename symbol" },
    { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Action" },
    { "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<CR>",               desc = "Code lens run" },
    { "<leader>=",  "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", desc = "Format" },
    { "<leader>vt", "<cmd>lua vim.lsp.buf.hover()<CR>",                  desc = "Hover" },
    { "<leader>vp", "<cmd>lua vim.lsp.buf.signature_help()<CR>",         desc = "Signature" },
    { "<leader>vs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>",        desc = "Document symbol" },
    { "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>",         desc = "Implementation" },
    { "<leader>fr", "<cmd>lua vim.lsp.buf.references()<CR>",             desc = "References" },
    { "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>",             desc = "References" },
    { "<leader>gd", "<cmd>lua vim.lsp.buf.type_definition()<CR>",        desc = "Type definition" },
    { "<leader>gu", "<cmd>lua vim.lsp.buf.incomming_calls()<CR>",        desc = "Incomming calls" },
    { "<leader>go", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>",         desc = "Outgoing calls" },
    { "<M-CR>",     "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Code action" },
    { "<leader>as", "<cmd>lua vim.lsp.start_client()<CR>",               desc = "Start client" },
    { "<leader>ah", "<cmd>lua vim.lsp.stop_client()<CR>",                desc = "Stop client" },

  -- TODO
  -- add lspsaga bindings
  -- vim.lsp.buf.workspace_symbol()  Lists all symbols in the current workspace in the quickfix window.
  --*vim.lsp.buf.clear_references()* Removes document highlights from current buffer.
  --*vim.lsp.buf.completion()* Retrieves the completion items at the current cursor position. Can only be called in Insert mode.
  },
  opts = {
    setup = {
      metals = {},
    },
  },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = {
        -- Replace these with whatever servers you want to install
        -- https://github.com/williamboman/mason-lspconfig.nvim
        'rust_analyzer',
        'tsserver',
        'pyright',
        'lua_ls',
        'bashls',
        'jsonls',
        --    'hls',
        'taplo',
        'yamlls'
      }
    })

    local lspconfig = require("lspconfig")
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    require('mason-lspconfig').setup_handlers({
      function(server_name)
        -- lspconfig[server_name].setup({
        --   capabilities = lsp_capabilities,
        -- })
        lspconfig[server_name].setup({})
      end,
    })

    lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
      capabilities = lsp_capabilities,
    })

    -- using Noice for hover
    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })




    lspconfig.jsonls.setup({
      on_attach = on_attach,
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
          end,
        },
      },
    })

    -- -- These server just use the vanilla setup
    local servers = { "bashls", "tsserver", "yamlls", "lua_ls" }
    for _, server in pairs(servers) do
      lspconfig[server].setup({ on_attach = on_attach })
    end

    -- Uncomment for trace logs from neovim
    --vim.lsp.set_log_level('trace')
  end,
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    {
      "j-hui/fidget.nvim",
      enabled = false,
      tag = 'legacy',
      config = function()
        require('fidget').setup()
      end
    }, -- Useful status updates for LSP
    {
      "folke/neodev.nvim",
      config = function()
        require('neodev').setup()
      end
    }, -- Additional lua configuration
    -- {
    --   'nvimdev/lspsaga.nvim',
    --   config = function()
    --     require('lspsaga').setup({
    --       ui = {
    --         border = 'rounded',
    --       },
    --       symbol_in_winbar = {
    --         enable = false
    --       },
    --       lightbulb = {
    --         enable = true
    --       },
    --       outline = {
    --         layout = 'float'
    --       },
    --       finder = {
    --         edit = { "o", "<CR>" },
    --         vsplit = "s",
    --         split = "i",
    --         tabe = "t",
    --         quit = { ";", "<ESC>" },
    --       },
    --     })
    --   end,
    -- }
  }
},
    {
      'scalameta/nvim-metals',
      enabled = false,
      keys = {
        { "<leader>at",  ":Telescope metals commands<CR>",                         desc =                "Metals commands" },
        { "<leader>ws",  "<cmd>lua require('metals').hover_worksheet({ border = 'single' })<CR>",  desc = "Hover worksheet" },
        { "<leader>tt",  "<cmd>lua require('metals.tvp').toggle_tree_view()<CR>",                  desc = "Toggle tree" },
        { "<leader>ff",  "<cmd>lua require('metals.tvp').reveal_in_tree()<CR>",                    desc = "Find in tree" },
        { "<leader>vis", "<cmd>lua require('metals').toggle_setting('showImplicitArguments')<CR>", desc = "Show implicits" },
        { "<leader>am",  "<cmd>lua require('telescope').extensions.metals.commands()<CR>",         desc = "Metal commands" },
        { "<leader>vt", "<Esc><cmd>lua require('metals').type_of_range()<CR>", mode = "v", desc = "View type" }
      },
      ft = { "scala", "sbt" },
      dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim", "nvim-lspconfig" },
      config = function()
        --================================
        -- Metals specific setup
        --================================
        local metals_config = require("metals").bare_config()

        local lsp_group = api.nvim_create_augroup("lsp", { clear = true })
        local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
        metals_config.tvp = {
          icons = {
            enabled = true
          }
        }

        metals_config.settings = {
          showImplicitArguments = true,
          showImplicitConversionsAndClasses = true,
          showInferredType = true,
          excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl",
            "akka.stream.javadsl",
            "akka.http.javadsl",
          },
        }

        metals_config.init_options.statusBarProvider = "on"
        metals_config.capabilities = lsp_capabilities

        metals_config.on_attach = function(client, bufnr)
          on_attach(client, bufnr)

          -- A lot of the servers I use won't support document_highlight or codelens,
          -- so we juse use them in Metals
          api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = lsp_group,
          })
          api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = lsp_group,
          })
          api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            callback = vim.lsp.codelens.refresh,
            buffer = bufnr,
            group = lsp_group,
          })
          api.nvim_create_autocmd("FileType", {
            pattern = { "dap-repl" },
            callback = function()
              require("dap.ext.autocompl").attach()
            end,
            group = lsp_group,
          })

          -- nvim-dap
          -- I only use nvim-dap with Scala, so we keep it all in here
          local dap = require("dap")

          dap.configurations.scala = {
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
            {
              type = "scala",
              request = "launch",
              name = "Run or Test",
              metals = {
                runType = "runOrTestFile",
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }

          -- TODO add to keybindings
          -- map("n", "<leader>dc", [[<cmd>lua require("dap").continue()<CR>]])
          -- map("n", "<leader>dr", [[<cmd>lua require("dap").repl.toggle()<CR>]])
          -- map("n", "<leader>dK", [[<cmd>lua require("dap.ui.widgets").hover()<CR>]])
          -- map("n", "<leader>dt", [[<cmd>lua require("dap").toggle_breakpoint()<CR>]])
          -- map("n", "<leader>dso", [[<cmd>lua require("dap").step_over()<CR>]])
          -- map("n", "<leader>dsi", [[<cmd>lua require("dap").step_into()<CR>]])
          -- map("n", "<leader>drl", [[<cmd>lua require("dap").run_last()<CR>]])

          -- dap.listeners.after["event_terminated"]["nvim-metals"] = function(session, body)
          --   --vim.notify("Tests have finished!")
          --   dap.repl.open()
          -- end

          require("metals").setup_dap()
        end

        local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
        api.nvim_create_autocmd("FileType", {
          pattern = { "scala", "sbt" },
          callback = function()
            vim.notify("Metals initialize")
            require("metals").initialize_or_attach(metals_config)
          end,
          group = nvim_metals_group,
        })
      end
    }}
