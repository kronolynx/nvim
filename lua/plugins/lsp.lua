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
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.ERROR,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.WARN,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.HINT,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.INFO,
    },
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
        'aaronik/treewalker.nvim',
        lazy = true,
        keys = {
          -- moving
          { "<leader>wk",  "<cmd>Treewalker Up<CR>",        desc = "move up" },
          { "<leader>wj",  "<cmd>Treewalker Down<CR>",      desc = "move down" },
          { "<leader>wh",  "<cmd>Treewalker Left<CR>",      desc = "move left" },
          { "<leader>wl",  "<cmd>Treewalker Right<CR>",     desc = "move right" },
          -- swaping
          { "<leader>wsk", "<cmd>Treewalker SwapUp<CR>",    desc = "swap up" },
          { "<leader>wsj", "<cmd>Treewalker SwapDown<CR>",  desc = "swap down" },
          { "<leader>wsh", "<cmd>Treewalker SwapLeft<CR>",  desc = "swap left" },
          { "<leader>wsl", "<cmd>Treewalker SwapRight<CR>", desc = "swap right" }
        },
        -- The following options are the defaults.
        -- Treewalker aims for sane defaults, so these are each individually optional,
        -- and setup() does not need to be called, so the whole opts block is optional as well.
        opts = {
          -- Whether to briefly highlight the node after jumping to it
          highlight = true,

          -- How long should above highlight last (in ms)
          highlight_duration = 250,

          -- The color of the above highlight. Must be a valid vim highlight group.
          -- (see :h highlight-group for options)
          highlight_group = 'CursorLine',
        }
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
        ts_ls = {}, -- Typescript
        -- marksman = {},
        -- markdown_oxide = {},
        -- tsserver = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },
        bashls = {},
        lua_ls = { -- TODO fix maybe name is lua-language_server
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {
                'vim',
                'require'
              },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false
            },
            telemetry = { enable = false },
          },
        },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

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
      local hover = vim.lsp.buf.hover
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.buf.hover = function()
        return hover {
          border = 'rounded',
          max_height = math.floor(vim.o.lines * 0.8),
          max_width = math.floor(vim.o.columns * 0.8),
        }
      end

      local signature_help = vim.lsp.buf.signature_help
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.buf.signature_help = function()
        return signature_help {
          border = 'rounded',
          max_height = math.floor(vim.o.lines * 0.8),
          max_width = math.floor(vim.o.columns * 0.8),
        }
      end

      local lsp_group = api.nvim_create_augroup("lsp", { clear = true })

      local on_attach = function(client, bufnr)
        map("n", "<leader>gD", vim.lsp.buf.definition, { desc = "definitions" })
        map("n", "<leader>gT", vim.lsp.buf.type_definition, { desc = "type definition" })
        map("n", "<leader>gI", vim.lsp.buf.implementation, { desc = "implementation" })
        map("n", "<leader>gR", vim.lsp.buf.references, { desc = "references" })
        map("n", "H", vim.lsp.buf.signature_help, { desc = "signature help" })
        map("i", "<M-h>", vim.lsp.buf.signature_help, { desc = "signature" })
        map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "rename" })
        map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "code action" })
        map("v", "<leader>la", vim.lsp.buf.code_action, { desc = "code action" })
        map("n", "<leader>ll", vim.lsp.codelens.run, { desc = "code lens" })
        map("n", "<leader>lw", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
        map("n", "K", vim.lsp.buf.hover)

        -- FZF
        map("n", "<leader>gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "lsp definitions" })
        map("n", "<leader>gi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "lsp implementations" })
        map("n", "<leader>gr", "<cmd>FzfLua lsp_references<cr>", { desc = "lsp references" })
        map("n", "<leader>gSb", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "lsp symbols buffer" })
        map("n", "<leader>gSl", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "lsp live workspace symbols" })
        map("n", "<leader>gSw", "<cmd>FzfLua lsp_workspace_symbols<cr>", { desc = "lsp symbols workspace" })
        map("n", "<leader>gt", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "lsp typedefs" })

        map("n", "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "lsp code actions" })
        map("n", "<leader>lci", "<cmd>FzfLua lsp_incoming_calls<cr>", { desc = "lsp calls incoming" })
        map("n", "<leader>lco", "<cmd>FzfLua lsp_outgoing_calls<cr>", { desc = "lsp calls outgoing" })
        map("n", "<leader>lf", "<cmd>FzfLua lsp_finder<cr>", { desc = "lsp finder" })

        -- Diagnostic keymaps
        map("n", "<leader>dl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "line" })
        map("n", '<leader>dp', "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = 'previous' })
        map("n", '<leader>dn', "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = 'next' })
        map("n", "<leader>db", "<cmd>FzfLua lsp_document_diagnostics sort=true<cr>", { desc = "lsp diagnostics buffer" }) -- sort=2 // for reverse sort
        map("n", "<leader>dw", "<cmd>FzfLua lsp_workspace_diagnostics sort=true<cr>",
          { desc = "lsp diagnostics workspace" })

        if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
          -- vim.lsp.inlay_hint.enable(true) -- TODO find a way to enable by default but not here as it will enable each time a buffer is loaded
          vim.keymap.set('n', '<leader>lh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, {
            desc = 'inlay hints',
          })
        end


        if client.server_capabilities.completionProvider then
          api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        end

        if client:supports_method(methods.textDocument_documentHighlight) then
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

        if client:supports_method(methods.codeLens_resolve) then
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
      vim.lsp.handlers[methods.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers.signature_help, true)


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
        superMethodLensesEnabled = false,
        showImplicitArguments = false,
        showImplicitConversionsAndClasses = false,
        showInferredType = true,
        serverProperties = {
          "-Xmx2G",
          "-Dmetals.enable-best-effort=true",
          "-XX:+UseZGC",
          "-XX:ZUncommitDelay=30",
          "-XX:ZCollectionInterval=5",
        },
        inlayHints = {
          hintsInPatternMatch = { enable = true },
          implicitArguments = { enable = false },
          implicitConversions = { enable = false },
          inferredTypes = { enable = true },
          typeParameters = { enable = false },
        },
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

        map("n", "<leader>gs", require("metals").goto_super_method, { desc = "super method" })

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

        map("n", "<leader>lmva", function()
          require("metals").toggle_setting("showImplicitArguments")
        end, { desc = "view implicit arguments" })

        map("n", "<leader>lmvc", function()
          require("metals").toggle_setting("showImplicitConversionsAndClasses")
        end, { desc = "view implicit conversions" })

        map("n", "<leader>lmvs", function()
          require("metals").toggle_setting("enableSemanticHighlighting")
        end, { desc = "view semanting highlighting" })

        map("n", "<leader>lmvt", function()
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
