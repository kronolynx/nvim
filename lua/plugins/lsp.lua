local api = vim.api

local on_attach = function(client, bufnr)
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  require("lsp-inlayhints").on_attach(client, bufnr)
end

return { {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>gd", "<cmd>Telescope lsp_definitions<CR>",      desc = "definitions" },
    -- { "<leader>gd", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>",     desc = "definitions" },
    { "<leader>gr", "<cmd>Telescope lsp_references<CR>",       desc = "references" },
    -- { "<leader>gr", "<cmd>lua require('fzf-lua').lsp_references()<CR>",      desc = "references" },
    { "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", desc = "implementation" },
    -- { "<leader>gi", "<cmd>lua require('fzf-lua').lsp_implementations()<CR>", desc = "implementation" },
    { "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "type definition" },
    -- { "<leader>gt", "<cmd>lua require('fzf-lua').lsp_typedefs()<CR>",        desc = "type definition" },
    { "<leader>vh", "<cmd>lua vim.lsp.buf.hover()<CR>",                      desc = "type documentation" },
    {
      "<leader>vh",
      "<cmd>lua vim.lsp.buf.hover()<CR>",
      mode = "v",
      desc =
      "[T]ype documentation"
    },
    {
      "<C-k>",
      "<cmd>lua vim.lsp.buf.signature_help()<CR>",
      mode = "i",
      desc =
      "Signature help"
    },
    { "<leader>rr",  "<cmd>lua vim.lsp.buf.rename()<CR>",                  desc = "refactor rename symbol" },
    { "<C-CR>",      "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "code action" },
    -- { "<C-CR>",      "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", desc = "Code action" },
    { "<M-CR>",      "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "code action" },
    -- { "<leader>la",  "<cmd>lua vim.lsp.buf.code_action()<CR>",            desc = "Action" },
    { "<leader>la",  "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", desc = "action" },
    { "<leader>ll",  "<cmd>lua vim.lsp.codelens.run()<CR>",                desc = "code lens" },
    -- { "<leader>ll",  function() vim.lsp.codelens.run end,                 desc = "code [L]ens" },
    { "<leader>=",   "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",  desc = "format" },
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
      kotlin_language_server = {},
      rust_analyzer = {},
      jsonls = {},
      yamlls = {},
      marksman = {},
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
      "folke/neodev.nvim"
    }, -- Additional lua configuration
    {
      "lvimuser/lsp-inlayhints.nvim",
      config = function()
        require("lsp-inlayhints").setup()
      end
    },
    {
      'nvimdev/lspsaga.nvim',
      enabled = true,
      keys = {
        { "<leader>gR", "<cmd>Lspsaga finder ++normal<CR>",         desc = "saga find" },
        { "<leader>gT", "<cmd>Lspsaga goto_type_definition<CR>",    desc = "saga goto type" },
        { "<leader>vt", "<cmd>Lspsaga peek_type_definition<CR>",    desc = "saga peek typedef" },
        { "<leader>gD", "<cmd>Lspsaga goto_definition<CR>",         desc = "saga go to def" },
        { "<leader>vd", "<cmd>Lspsaga peek_definition<CR>",         desc = "saga peek def" },
        -- { "<leader>ve", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "saga cursor diagnostic" },
        { "<leader>ve", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "saga cursor diagnostic" },
        { "<leader>vH", "<cmd>Lspsaga hover_doc<CR>",               desc = "saga hover" },
      },
      config = function()
        require('lspsaga').setup({
          symbol_in_winbar = {
            enable = false
          },
          lightbulb = {
            enable = false
          },
          outline = {
            layout = 'normal'
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
      { "<leader>lmc", "<cmd>Telescope metals commands<CR>",                                         desc = "commands" },
      --{ "<leader>lmc", "<cmd>lua require('telescope').extensions.metals.commands()<CR>",        desc = "Commands" },
      { "<leader>lmw", "<cmd>lua require('metals').hover_worksheet({ border = 'single' })<CR>",  desc = "hover worksheet" },
      { "<leader>lmf",  "<cmd>lua require('metals.tvp').reveal_in_tree()<CR>",                    desc = "find in tree" },
      { "<leader>lvi", "<cmd>lua require('metals').toggle_setting('showImplicitArguments')<CR>", desc = "view implicits" },
      {
        "<leader>lvt",
        "<cmd>lua require('metals').toggle_setting('showInferredType')<CR>",
        desc =
        "Toggle infered type"
      },
      { "<leader>lml", "<cmd>lua require('metals').toggle_logs()<CR>",             desc = "view logs" },
      { "<leader>lmi", "<cmd>lua require('metals').import_build()<CR>",            desc = "import build" },
      { "<leader>lmd", "<cmd>lua require('metals').find_in_dependency_jars()<CR>", desc = "dependency jars" },
      { "<leader>lmt", "<cmd>lua require('metals.tvp').toggle_tree_view()<CR>",    desc = "tree view "},
      { "<leader>lmo", "<cmd>lua require('metals').organize_imports()<CR>",        desc = "organize imports" },
      {
        "<leader>lvt",
        "<Esc><cmd>lua require('metals').type_of_range()<CR>",
        mode = "v",
        desc =
        "View type"
      },
    },
    ft = { "scala", "sbt" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope.nvim",
      "nvim-lspconfig"
    },
    config = function()
      --================================
      -- Metals specific setup
      --================================
      local metals_config = require("metals").bare_config()

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

      -- using fidget for status
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

        -- -- A lot of the servers I use won't support document_highlight or codelens,
        -- -- so we juse use them in Metals
        -- api.nvim_create_autocmd("CursorHold", {
        --   callback = vim.lsp.buf.document_highlight,
        --   buffer = bufnr,
        --   group = lsp_group,
        -- })
        -- api.nvim_create_autocmd("CursorMoved", {
        --   callback = vim.lsp.buf.clear_references,
        --   buffer = bufnr,
        --   group = lsp_group,
        -- })
        -- api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        --   callback = vim.lsp.codelens.refresh,
        --   buffer = bufnr,
        --   group = lsp_group,
        -- })
        -- api.nvim_create_autocmd("FileType", {
        --   pattern = { "dap-repl" },
        --   callback = function()
        --     require("dap.ext.autocompl").attach()
        --   end,
        --   group = lsp_group,
        -- })


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
