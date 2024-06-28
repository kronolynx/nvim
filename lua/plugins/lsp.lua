local api = vim.api
local map = vim.keymap.set
local icons = require('util.icons')
local methods = vim.lsp.protocol.Methods

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
    enabled = os.getenv("LSP_ENABLED") ~= "false", -- use `alias no="LSP_ENABLED=false nvim"` to disable LSP
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      'scalameta/nvim-metals',
      "mfussenegger/nvim-dap",
      "nvim-lua/plenary.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- Library items can be absolute paths
            -- "~/projects/my-awesome-lib",
            -- Or relative, which means they will be resolved as a plugin
            -- "LazyVim",
            -- When relative, you can also provide a path to the library in the plugin dir
            "luvit-meta/library", -- see below
          },
        },
      },
      {
        "j-hui/fidget.nvim",
        opts = {
          progress = {
            display = {
              render_limit = 4
            }
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true }
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
        -- marksman = {},
        -- markdown_oxide = {},
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

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      capabilities.workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      }

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      -- Configuration for diagnostics
      local signs = {
        { name = 'DiagnosticSignError', text = icons.diagnostics.ERROR },
        { name = 'DiagnosticSignWarn',  text = icons.diagnostics.WARN },
        { name = 'DiagnosticSignHint',  text = icons.diagnostics.HINT },
        { name = 'DiagnosticSignInfo',  text = icons.diagnostics.INFO },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
      end

      vim.lsp.handlers["textDocument/publishDiagnostics"] =
          vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            -- Disable underline, it's very annoying
            underline = true,
            -- Enable virtual text, overrde spacing to 4
            -- virtual_text = { spacing = 4 },
            signs = false,
            -- signs = {
            --   active = signs
            -- },
            update_in_insert = false,
            float = {
              focusable = true,
              style = 'minimal',
              border = 'single',
              source = 'always',
              header = 'Diagnostic',
              prefix = '',
            },
          })


      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- enable code folding
      -- needs to be on cmp_capabilities or it will get overwritten
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      local lsp_group = api.nvim_create_augroup("lsp", { clear = true })

      local on_attach = function(client, bufnr)
        map("n", "<leader>gD", vim.lsp.buf.definition, { desc = "definitions" })
        map("n", "<leader>gT", vim.lsp.buf.type_definition, { desc = "type definition" })
        map("n", "<leader>ji", vim.lsp.buf.implementation, { desc = "implementation" })
        map("n", "<leader>jr", vim.lsp.buf.references, { desc = "references" })
        map("n", "H", vim.lsp.buf.signature_help, { desc = "signature help" })
        map("i", "<M-h>", vim.lsp.buf.signature_help, { desc = "signature" })
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

        if client.supports_method(methods.textDocument_documentHighlight) then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufEnter' }, {
            group = lsp_group,
            desc = 'Highlight references under the cursor',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
            group = lsp_group,
            desc = 'Clear highlight references',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if client.supports_method(methods.codeLens_resolve) then
          api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = lsp_group,
            desc = 'Refresh code lens',
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
          })
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

      --- https://github.com/MariaSolOs/dotfiles/blob/c5000d1eba7b2a153112300301e75b19a63bb25b/config/nvim/lua/lsp.lua#L177
      --- Adds extra inline highlights to the given buffer.
      ---@param buf integer
      local function add_inline_highlights(buf)
        for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
          for pattern, hl_group in pairs {
            ['@%S+'] = '@parameter',
            ['^%s*(Parameters:)'] = '@text.title',
            ['^%s*(Return:)'] = '@text.title',
            ['^%s*(See also:)'] = '@text.title',
            ['{%S-}'] = '@parameter',
            ['|%S-|'] = '@text.reference',
          } do
            local from = 1 ---@type integer?
            while from do
              local to
              from, to = line:find(pattern, from)
              if from then
                vim.api.nvim_buf_set_extmark(buf, "lsp_float", l - 1, from - 1, {
                  end_col = to,
                  hl_group = hl_group,
                })
              end
              from = to and to + 1 or nil
            end
          end
        end
      end

      --- https://github.com/MariaSolOs/dotfiles/blob/c5000d1eba7b2a153112300301e75b19a63bb25b/config/nvim/lua/lsp.lua#L208
      --- LSP handler that adds extra inline highlights, keymaps, and window options.
      --- Code inspired from `noice`.
      ---@param handler fun(err: any, result: any, ctx: any, config: any): integer?, integer?
      ---@param focusable boolean
      ---@return fun(err: any, result: any, ctx: any, config: any)
      local function enhanced_float_handler(handler, focusable)
        return function(err, result, ctx, config)
          local bufnr, winnr = handler(
            err,
            result,
            ctx,
            vim.tbl_deep_extend('force', config or {}, {
              border = 'rounded',
              focusable = focusable,
              max_height = math.floor(vim.o.lines * 0.5),
              max_width = math.floor(vim.o.columns * 0.4),
            })
          )

          if not bufnr or not winnr then
            return
          end

          -- Conceal everything.
          vim.wo[winnr].concealcursor = 'n'

          -- Extra highlights.
          add_inline_highlights(bufnr)

          -- Add keymaps for opening links.
          if focusable and not vim.b[bufnr].markdown_keys then
            vim.keymap.set('n', 'K', function()
              -- Vim help links.
              local url = (vim.fn.expand '<cWORD>' --[[@as string]]):match '|(%S-)|'
              if url then
                return vim.cmd.help(url)
              end

              -- Markdown links.
              local col = vim.api.nvim_win_get_cursor(0)[2] + 1
              local from, to
              from, to, url = vim.api.nvim_get_current_line():find '%[.-%]%((%S-)%)'
              if from and col >= from and col <= to then
                vim.system({ 'xdg-open', url }, nil, function(res)
                  if res.code ~= 0 then
                    vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
                  end
                end)
              end
            end, { buffer = bufnr, silent = true })
            vim.b[bufnr].markdown_keys = true
          end
        end
      end
      vim.lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(vim.lsp.handlers.hover, true)
      vim.lsp.handlers[methods.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers.signature_help,
        false)


      -- Uncomment for trace logs from neovim
      -- vim.lsp.set_log_level('trace')

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
        --disabledMode = true,
        autoImportBuild = "initial", -- initial, all, off
        defaultBspToBuildTool = true,
        enableSemanticHighlighting = false,
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        serverVersion = "latest.snapshot",
        scalafixConfigPath = vim.env.HOME .. "/.config/scalafix.conf",
        --testUserInterface = "Test Explorer"
      }

      -- https://scalameta.org/metals/docs/integrations/new-editor/#initializationoptions
      metals_config.init_options = {
        compilerOptions = {},
        disableColorOutput = false,
        statusBarProvider = "off",
        inlineDecorationProvider = true,
        decorationProvider = true,
        -- icons = "unicode"
      }

      metals_config.capabilities = capabilities

      metals_config.on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        map("v", "K", require("metals").type_of_range, { desc = "type of range" })

        map("n", "<leader>lmw", function()
          require("metals").hover_worksheet({ border = "single" })
        end, { desc = "hover worksheet" })

        map("n", "<leader>lmt", require("metals.tvp").toggle_tree_view, { desc = "tree view" })

        map("n", "<leader>lmf", require("metals.tvp").reveal_in_tree, { desc = "find in tree" })

        map("n", "<leader>lmc", require("metals").commands, { desc = "commands" })
        map("n", "<leader>lmi", require("metals").import_build, { desc = "import build" })
        map("n", "<leader>lmd", require("metals").find_in_dependency_jars, { desc = "find in jars" })
        map("n", "<leader>lmo", require("metals").organize_imports, { desc = "organize imports" })
        map("n", "<leader>lmw", require("metals").hover_worksheet, { desc = "hover worksheet" })
        map("n", "<leader>lml", require("metals").toggle_logs, { desc = "toggle logs" })

        map("n", "<leader>lvi", function()
          require("metals").toggle_setting("showImplicitArguments")
        end, { desc = "view implicits" })

        map("n", "<leader>lvS", function()
          require("metals").toggle_setting("enableSemanticHighlighting")
        end, { desc = "view semanting highlighting" })

        map("n", "<leader>lvt", function()
          require("metals").toggle_setting("showInferredType")
        end, { desc = "view inferred type" })

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
