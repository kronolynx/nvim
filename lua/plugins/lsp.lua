local api = vim.api
local on_attach = function(_, bufnr)
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

return { {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>gd",  "<cmd>Telescope lsp_definitions<CR>",                desc = "[D]efinitions" },
    { "<leader>gr",  "<cmd>Telescope lsp_references<CR>",                 desc = "[R]eferences" },
    { "<leader>gi",  "<cmd>Telescope lsp_implementations<CR>",            desc = "[I]mplementation" },
    { "<leader>gt",  "<cmd>Telescope lsp_type_definitions<CR>",           desc = "[T]ype definition" }, -- TODO what does this do ?
    { "<leader>vt",  "<cmd>lua vim.lsp.buf.hover()<CR>",                  desc = "[T]ype documentation" },
    { "<leader>vt",  "<cmd>lua vim.lsp.buf.hover()<CR>", mode = "v",      desc = "[T]ype documentation" },
    { "<leader>vsd", "<cmd>Telescope lsp_document_symbol<CR>",            desc = "[s]ymbol [D]ocument " },
    { "<leader>vsw", "<cmd>Telescope lsp_dynamic_workspace_symbol<CR>",   desc = "[s]ymbol [W]orkspace " },
    { "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", mode = "i",   desc = "Signature help" },
    { "<leader>rr",  "<cmd>lua vim.lsp.buf.rename()<CR>",                 desc = "[R]efactor [R]ename symbol" },
    { "<C-CR>",      "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Code action" },
    { "<M-CR>",      "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Code action" },
    { "<leader>la",  "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Action" },
    { "<leader>=",   "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", desc = "Format" },
    { "<leader>lgx", "<cmd>lua vim.lsp.buf.declaration",                  desc = "Go declaration" }
    --- check what is used and what should be removed
  },
  opts = {
    setup = {
      metals = {},
    },
  },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup()

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. They will be passed to
    --  the `settings` field of the server config. You must look up that documentation yourself.
    --
    --  If you want to override the default filetypes that your language server will attach to you can
    --  define the property 'filetypes' to the map in question.
    local servers = {
      -- Replace these with whatever servers you want to install
      -- https://github.com/williamboman/mason-lspconfig.nvim
      pyright = {},
      rust_analyzer = {},
      jsonls = {},
      yamlls = {},
      -- tsserver = {},
      -- html = { filetypes = { 'html', 'twig', 'hbs'} },
      bashls = {},
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
        },
      },
    }

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        }
      end,
    }

    -- using Noice for hover
    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          -- Disable underline, it's very annoying
          underline = false,
          -- Enable virtual text, override spacing to 4
          -- virtual_text = { spacing = 4 },
          signs = true,
          update_in_insert = false
        })


    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- enable code folding
    -- needs to be on cmp_capabilities or it will get overwritten
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }

    -- on_attach is called for both mason_lspconfig and this because nvim-metals is installed via lazy
    -- rather than via mason, and I want the same keybindings everywhere
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buffer = args.buf ---@type number
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        on_attach(client, buffer)
      end,
    })

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
      "folke/neodev.nvim"
    }, -- Additional lua configuration
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("lsp_signature").setup {
          hint_enable = true
        }
      end
    },
    {
      'nvimdev/lspsaga.nvim',
      enabled = false,
      config = function()
        require('lspsaga').setup({
          ui = {
            border = 'rounded',
          },
          symbol_in_winbar = {
            enable = false
          },
          lightbulb = {
            enable = true
          },
          outline = {
            layout = 'float'
          },
          finder = {
            edit = { "o", "<CR>" },
            vsplit = "s",
            split = "i",
            tabe = "t",
            quit = { ";", "<ESC>" },
          },
        })
      end,
    }
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
        "Toggle infered type"
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

      local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
      api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  } }
