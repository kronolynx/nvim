local api = vim.api
local on_attach = function(_, bufnr)
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

return { {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<C-CR>",      "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Code action" },
    { "<leader>ca",  "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Action" },
    { "<leader>=",   "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", desc = "Format" },
    { "<leader>ah",  "<cmd>lua vim.lsp.stop_client()<CR>",                desc = "Stop client" },
    { "<leader>as",  "<cmd>lua vim.lsp.start_client()<CR>",               desc = "Start client" },
    { "<leader>la",  "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Action" },
    { "<leader>ld",  "<cmd>lua vim.lsp.buf.type_definition()<CR>",        desc = "Type definition" },
    { "<leader>lcl", "<cmd>lua vim.lsp.codelens.run()<CR>",               desc = "Code lens run" },
    { "<leader>lgo", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>",         desc = "Outgoing calls" },
    { "<leader>lh",  "<cmd>lua vim.lsp.stop_client()<CR>",                desc = "Stop client" },
    { "<leader>li",  "<cmd>lua vim.lsp.buf.implementation()<CR>",         desc = "Implementation" },
    { "<leader>ll",  "<cmd>lua vim.lsp.codelens.run()<CR>",               desc = "Code lens run" },
    { "<leader>ls",  "<cmd>lua vim.lsp.buf.signature_help()<CR>",         desc = "Signature" },
    { "<leader>ls",  "<cmd>lua vim.lsp.start_client()<CR>",               desc = "Start client" },
    { "<leader>lt",  "<cmd>lua vim.lsp.buf.hover()<CR>",                  desc = "Hover" },
    { "<leader>lvp", "<cmd>lua vim.lsp.buf.signature_help()<CR>",         desc = "Signature" },
    { "<leader>lvr", "<cmd>lua vim.lsp.buf.references()<CR>",             desc = "References" },
    { "<leader>lvt", "<cmd>lua vim.lsp.buf.hover()<CR>",                  desc = "View type" },
    { "<leader>ly",  "<cmd>lua vim.lsp.buf.document_symbol()<CR>",        desc = "Document symbol" },
    { "<leader>rr",  "<cmd>lua vim.lsp.buf.rename()<CR>",                 desc = "Rename symbol" },
    {
      "<leader>lfi",
      "<cmd>Telescope lsp_incoming_calls<CR>",
      desc =
      "Who calls this symbol"
    },
    {
      "<leader>lfo",
      "<cmd>Telescope lsp_outgoing_calls<CR>",
      desc =
      "What is called by this symbol"
    },
    { "<leader>lgi", "<cmd>Telescope lsp_implementations<CR>",          desc = "implementation" },
    { "<leader>lgr", "<cmd>Telescope lsp_references<CR>",               desc = "references" },
    { "<leader>lgt", "<cmd>Telescope lsp_type_definitions<CR>",         desc = "Type definition" },
    { "<leader>lvs", "<cmd>Telescope lsp_document_symbol<CR>",          desc = "Document symbol" },
    { "<leader>lvs", "<cmd>Telescope lsp_dynamic_workspace_symbol<CR>", desc = "Document symbol" },
    { "<leader>lvs", "<cmd>Telescope lsp_workspace_symbol<CR>",         desc = "Document symbol" },
    { "<leader>lxd", "<cmd>Telescope lsp_definitions<CR>",              desc = "Go definitions" },
    {
      "<leader>lxv",
      ":vsplit | lua vim.lsp.buf.definition()<CR>",
      desc =
      "V split definitions"
    },
    {
      "<leader>lxy",
      ":split | lua vim.lsp.buf.definition()<CR>",
      desc =
      "Y split definitions"
    },
    -- TODO
    -- add lspsaga bindings
    -- vim.lsp.buf.workspace_symbol()  Lists all symbols in the current workspace in the quickfix window.
    --*vim.lsp.buf.clear_references()* Removes document highlights from current buffer.
    --*vim.lsp.buf.completion()* Retrieves the completion items at the current cursor position. Can only be called in Insert mode.
    --map("n", "[d",        function() vim.diagnostic.goto_prev { wrap = false } end)
    --map("n", "]d",        function() vim.diagnostic.goto_next { wrap = false } end)
    --map("n", "<leader>sh", vim.lsp.buf.signature_help)
    --map("n", "<leader>H",  vim.lsp.buf.document_highlight, {desc = "Highlights the current symbol in the entire buffer"})
    --map("n", "<leader>nH", vim.lsp.buf.clear_references,   {desc = "Clear symbol highlights"})

    -- TODO can I make this shorter ?
    { "<leader>lgda", "<cmd>lua require('telescope.builtin').diagnostics<CR>",                  desc = "all diagnostics" },
    {
      "<leader>lgde",
      "<cmd>lua require('telescope.builtin').diagnostics({severity = 'E'}<CR>",
      desc =
      "error diagnostics"
    },
    { "<leader>lgdw", "<cmd>lua require('telescope.builtin').diagnostics({severity = 'W'}<CR>", desc = "warn diagnostics" },
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
    -- local lsp_capabilities =

    -- TODO , do I want this ???
    -- vim.cmd [[
    --  highlight LspDiagnosticsUnderlineError gui=NONE
    --  highlight LspDiagnosticsUnderlineWarning gui=NONE
    --  highlight LspDiagnosticsUnderlineInformation gui=NONE
    --  highlight LspDiagnosticsUnderlineHint gui=NONE
    -- ]]
    -- vim.cmd [[
    --  highlight LspReferenceRead gui=NONE
    --  highlight LspReferenceText gui=NONE
    --  highlight LspReferenceWrite gui=NONE
    -- ]]

    require('mason-lspconfig').setup_handlers({
      function(server_name)
        -- lspconfig[server_name].setup({
        --   capabilities = lsp_capabilities,
        -- })
        lspconfig[server_name].setup({})
      end,
    })

    lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
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

    -- enable completion on all lsp instances
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    local cmp_lsp = require("cmp_nvim_lsp")
    local cmp_capabilities = cmp_lsp.default_capabilities(capabilities)

    -- enable code folding
    -- needs to be on cmp_capabilities or it will get overwritten
    cmp_capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }

    -- -- These server just use the vanilla setup
    local servers = { "bashls", "tsserver", "yamlls", "lua_ls" }
    for _, server in pairs(servers) do
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = cmp_capabilities
      })
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
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("lsp_signature").setup {
          hint_enable = true
        }
      end
    }
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
    enabled = true,
    keys = {
      { "<leader>lmc", ":Telescope metals commands<CR>",                                         desc = "Commands" },
      --{ "<leader>lmc", "<cmd>lua require('telescope').extensions.metals.commands()<CR>",        desc = "Commands" },
      { "<leader>lmw", "<cmd>lua require('metals').hover_worksheet({ border = 'single' })<CR>",  desc = "Hover worksheet" },
      -- { "<leader>lmt", "<cmd>lua require('metals.tvp').toggle_tree_view()<CR>",                 desc = "Toggle tree" },
      -- { "<leader>ff",  "<cmd>lua require('metals.tvp').reveal_in_tree()<CR>",                    desc = "Find in tree" },
      { "<leader>lvi", "<cmd>lua require('metals').toggle_setting('showImplicitArguments')<CR>", desc = "View implicits" },
      {
        "<leader>lvt",
        "<cmd>lua require('metals').toggle_setting('showInferredType')<CR>",
        desc =
        "View infered type"
      },
      { "<leader>lml", "<cmd>lua require('metals').toggle_logs()<CR>",  desc = "view logs" },
      { "<leader>lmi", "<cmd>lua require('metals').import_build()<CR>", desc = "import build" },
      --{ "<C-A-o>", "<cmd>lua require('metals').organize_imports()<CR>", desc = "organize imports" },
      {
        "<leader>lvt",
        "<Esc><cmd>lua require('metals').type_of_range()<CR>",
        mode = "v",
        desc =
        "View type"
      },
    },
    ft = { "scala", "sbt" },
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim", "nvim-lspconfig" },
    config = function()
      --================================
      -- Metals specific setup
      --================================
      local metals_config = require("metals").bare_config()

      local lsp_group = api.nvim_create_augroup("lsp", { clear = true })
      metals_config.tvp = {
        icons = {
          enabled = true
        }
      }

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
          "akka.stream.javadsl",
          "akka.http.javadsl",
        },
      }

      metals_config.init_options.statusBarProvider = "on"
      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to true, however if you do,
      -- you *have* to have a setting to display this in your statusline or else
      -- you'll not see any messages from metals. There is more info in the help
      -- docs about this
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- enable code folding
      -- needs to be on cmp_capabilities or it will get overwritten
      cmp_capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      metals_config.capabilities = cmp_capabilities

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

      --local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
      --api.nvim_create_autocmd("FileType", {
      --  pattern = { "scala", "sbt" },
      --  callback = function()
      --    vim.notify("Metals initialize")
      --    require("metals").initialize_or_attach(metals_config)
      --  end,
      --  group = nvim_metals_group,
      --})

      vim.notify("Metals initialize")
      require("metals").initialize_or_attach(metals_config)
    end
  } }
