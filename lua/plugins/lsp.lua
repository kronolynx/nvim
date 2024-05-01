local api = vim.api
local map = vim.keymap.set

vim.diagnostic.config {
  virtual_text = false,
  float = {
    header = false,
    border = 'rounded',
    focusable = true,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      'scalameta/nvim-metals',
      "mfussenegger/nvim-dap",
      "nvim-lua/plenary.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "folke/neodev.nvim",
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
        lua_ls = { -- TODO fix maybe name is lua-language_server
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

      local on_attach = function(client, bufnr)
        -- map("n", "<leader>gD", vim.lsp.buf.definition, { desc = "definitions" })
        -- map("n", "<leader>gT", vim.lsp.buf.type_definition, { desc = "type definition" })
        -- map("n", "<leader>gI", vim.lsp.buf.implementation, { desc = "implementation" })
        -- map("n", "<leader>gR", vim.lsp.buf.references, { desc = "references" })
        map("n", "<leader>lvs", vim.lsp.buf.signature_help, { desc = "signature" })
        map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "rename" })
        map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "code action" })
        map("v", "<leader>la", vim.lsp.buf.code_action, { desc = "code action" })
        map("n", "<leader>ll", vim.lsp.codelens.run, { desc = "code lens" })
        map("n", "<leader>lw", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
        map("n", "K", vim.lsp.buf.hover)


        if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then -- only available in nightly
          vim.keymap.set('n', '<leader>lvh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, {
            desc = 'inlay hints',
          })
        end

        -- Diagnostic keymaps
        map("n", "<leader>dl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "line" })
        map("n", '<leader>dp', "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = 'previous' })
        map("n", '<leader>dn', "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = 'next' })

        if client.server_capabilities.completionProvider then
          api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        end
      end


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

      -- Uncomment for trace logs from neovim
      -- vim.lsp.set_log_level('trace')

      local lsp_group = api.nvim_create_augroup("lsp", { clear = true })
      --================================
      -- Metals specific setup
      --================================
      local metals_config = require("metals").bare_config()
      metals_config.tvp = {
        icons = {
          enabled = true,
        },
      }

      -- only check at workspace root, don't go up the tree
      metals_config.find_root_dir_max_project_nesting = 0

      --metals_config.cmd = { "cs", "launch", "tech.neader:langoustine-tracer_3:0.0.18", "--", "metals" }

      -- :h metals-settings
      metals_config.settings = {
        --bloopVersion = "1.5.6-253-5faffd8d-SNAPSHOT",
        --disabledMode = true,
        autoImportBuild = "initial", -- initial, all, off
        defaultBspToBuildTool = true,
        enableSemanticHighlighting = true,
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        serverVersion = "latest.snapshot",
        --serverVersion = "1.2.3-SNAPSHOT",
        --testUserInterface = "Test Explorer"
      }

      -- https://scalameta.org/metals/docs/integrations/new-editor/#initializationoptions
      metals_config.init_options = {
        compilerOptions = {},
        disableColorOutput = false,
        statusBarProvider = "on",
        icons = "unicode"
      }

      metals_config.capabilities = capabilities

      metals_config.on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        map("v", "K", require("metals").type_of_range)

        map("n", "<leader>lmw", function()
          require("metals").hover_worksheet({ border = "single" })
        end, { desc = "hover worksheet" })

        map("n", "<leader>lmt", require("metals.tvp").toggle_tree_view, { desc = "tree view" })

        map("n", "<leader>lmf", require("metals.tvp").reveal_in_tree, { desc = "find in tree" })

        map("n", "<leader>lmk", require("metals").commands, { desc = "commands" })
        map("n", "<leader>lmi", require("metals").import_build, { desc = "import build" })
        map("n", "<leader>lmd", require("metals").find_in_dependency_jars, { desc = "find in jars" })
        map("n", "<leader>lmo", require("metals").organize_imports, { desc = "find in jars" })
        map("n", "<leader>lmw", require("metals").hover_worksheet, { desc = "hover worksheet" })
        map("n", "<leader>lml", require("metals").toggle_logs, { desc = "toggle logs" })

        map("n", "<leader>lvi", function()
          require("metals").toggle_setting("showImplicitArguments")
        end, { desc = "view implicits" })

        map("n", "<leader>lvs", function()
          require("metals").toggle_setting("enableSemanticHighlighting")
        end, { desc = "view semanting highlighting" })

        map("n", "<leader>lvt", function()
          require("metals").toggle_setting("showInferredType")
        end, { desc = "view inferred type" })

        -- A lot of the servers I use won't support document_highlight or codelens,
        -- so we juse use them in Metals
        api.nvim_create_autocmd("CursorHold", {
          callback = vim.lsp.buf.document_highlight,
          buffer = bufnr,
          group = lsp_group,
        })
        api.nvim_create_autocmd("CursorMoved", {
          callback = function()
            vim.lsp.buf.clear_references()
          end,
          buffer = bufnr,
          group = lsp_group,
        })
        api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
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
    end,
  },
}
