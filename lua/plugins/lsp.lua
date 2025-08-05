local api = vim.api
local icons = require('util.icons')
local methods = vim.lsp.protocol.Methods
-- Disable inlay hints initially (and enable if needed with my ToggleInlayHints command).
vim.g.inlay_hints = false

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
    enabled = os.getenv("LSP_ENABLED") ~= "false",
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
        smithy_ls = {},
        -- marksman = {},
        -- markdown_oxide = {},
        -- tsserver = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },
        bashls = {},
        lua_ls = {
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
              -- library = vim.api.nvim_get_runtime_file("", true),
              library = {
                vim.env.VIMRUNTIME,
                '${3rd}/luv/library',
              },
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()

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

        ---@param lhs string
        ---@param rhs string|function
        ---@param desc string
        ---@param mode? string|string[]
        local function keymap(lhs, rhs, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        vim.b[bufnr].miniclue_config = {
          clues = {
            { mode = 'n', keys = '<leader>l',  desc = '+lsp' },
            { mode = 'x', keys = '<leader>l',  desc = '+lsp' },
            { mode = 'n', keys = '<leader>ld', desc = '+debug' },
            { mode = 'x', keys = '<leader>ld', desc = '+debug' },
            { mode = 'n', keys = '<leader>lv', desc = '+view' },
            { mode = 'x', keys = '<leader>lv', desc = '+view' },
          }
        }

        keymap("H", vim.lsp.buf.signature_help, "signature help")
        keymap("<M-h>", vim.lsp.buf.signature_help, "signature", "i")

        keymap("<leader>lr", vim.lsp.buf.rename, "rename")
        -- keymap( "<leader>la", vim.lsp.buf.code_action, "code action" )
        keymap("<leader>ll", vim.lsp.codelens.run, "code lens")
        keymap("<leader>lw", vim.lsp.buf.add_workspace_folder, "add workspace folder")
        keymap("K", vim.lsp.buf.hover, "Hover")

        keymap("<leader>gi", vim.lsp.buf.implementation, "implementation")
        keymap("<leader>gt", vim.lsp.buf.type_definition, "type definition")
        keymap("<leader>gr", vim.lsp.buf.references, "references")
        keymap("<leader>gSb", vim.lsp.buf.document_symbol, "document symbol")
        keymap("<leader>li", vim.lsp.buf.incoming_calls, "incoming calls") -- Lists all the call sites of the symbol under the cursor in the quickfix window.
        keymap("<leader>lo", vim.lsp.buf.outgoing_calls, "outgoing calls") -- Lists all the items that are called by the symbol under the cursor in the quickfix window.
        keymap("<leader>lh", vim.lsp.buf.typehierarchy, "hierarchy")       -- Lists all the subtypes or supertypes of the symbol under the cursor in the quickfix window.
        keymap("<leader>l=", vim.lsp.buf.format, "format")                 -- Lists all the subtypes or supertypes of the symbol under the cursor in the quickfix window.
        -- FZF
        keymap("<leader>gI", "<cmd>FzfLua lsp_implementations<cr>", "implementation FZF")
        keymap("<leader>gT", "<cmd>FzfLua lsp_typedefs<cr>", "typedefs FZF")
        keymap("<leader>gR", "<cmd>FzfLua lsp_references<cr>", "references FZF")
        keymap("<leader>gSB", "<cmd>FzfLua lsp_document_symbols<cr>", "symbols buffer FZF")
        keymap("<leader>lI", "<cmd>FzfLua lsp_incoming_calls<cr>", "incoming calls FZF")
        keymap("<leader>lO", "<cmd>FzfLua lsp_outgoing_calls<cr>", "outgoing calls FZF")

        keymap("<leader>gSl", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "lsp live workspace symbols FZF")
        -- keymap("<leader>gSw", "<cmd>FzfLua lsp_workspace_symbols<cr>", "lsp symbols workspace FZF") -- doesn't work for metals
        keymap("<leader>gSw", vim.lsp.buf.workspace_symbol, "workspace symbol")


        keymap('<leader>la', function() require('tiny-code-action').code_action() end, 'vim.lsp.buf.code_action()',
          { 'n', 'x' })
        -- keymap( "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", "lsp code actions" )
        keymap("<leader>lf", "<cmd>FzfLua lsp_finder<cr>", "lsp finder FZF")

        -- Diagnostics keymaps
        keymap("<leader>dl", "<cmd>lua vim.diagnostic.open_float()<CR>", "line")
        keymap('<leader>dp', "<cmd>lua vim.diagnostic.goto_prev()<CR>", 'previous')
        keymap('<leader>dn', "<cmd>lua vim.diagnostic.goto_next()<CR>", 'next')
        keymap("<leader>db", "<cmd>FzfLua lsp_document_diagnostics sort=true<cr>", "diagnostics buffer FZF") -- sort=2 // for reverse sort
        keymap("<leader>dw", "<cmd>FzfLua lsp_workspace_diagnostics sort=true<cr>", "diagnostics workspace FZF")
        -- keymap("<leader>dW", vim.lsp.buf.workspace_diagnostics, "diagnostics workspace") -- broken

        keymap('[d', function() vim.diagnostic.jump { count = -1 } end, 'Previous diagnostic')
        keymap(']d', function() vim.diagnostic.jump { count = 1 } end, 'Next diagnostic')
        keymap('[e', function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR } end,
          'Previous error')
        keymap(']e', function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR } end,
          'Next error')

        if client:supports_method(methods.textDocument_definition) then
          -- keymap('gd', function() require('fzf-lua').lsp_definitions { jump1 = true } end, 'Go to definition')
          keymap("<leader>gd", vim.lsp.buf.definition, "definition") -- TODO if not happy with QF then replace with the one above
          keymap('<leader>gD', function() require('fzf-lua').lsp_definitions { jump1 = false } end, 'Peek definition FZF')
        end

        if client:supports_method(methods.textDocument_signatureHelp) then
          keymap('<C-k>', function()
            -- Close the completion menu first (if open).
            if require('blink.cmp.completion.windows.menu').win:is_open() then
              require('blink.cmp').hide()
            end

            vim.lsp.buf.signature_help()
          end, 'Signature help', 'i')
        end

        if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
          keymap('<leader>lvh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, 'enable inlay hints')
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
        -- inlayHints = { -- TODO if this is added can't toggle hindts
        --   hintsInPatternMatch = { enable = true },
        --   implicitArguments = { enable = true },
        --   implicitConversions = { enable = true },
        --   inferredTypes = { enable = true },
        --   typeParameters = { enable = false },
        -- },
        -- serverVersion = "latest.snapshot",
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
        ---@param lhs string
        ---@param rhs string|function
        ---@param desc string
        ---@param mode? string|string[]
        local function keymap(lhs, rhs, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        local metals_clues = {
          { mode = 'n', keys = '<leader>lm',  desc = '+metals' },
          { mode = 'n', keys = '<leader>lmv', desc = '+view' },
          { mode = 'x', keys = '<leader>lm',  desc = '+metals' },
          { mode = 'x', keys = '<leader>lmv', desc = '+view' },
        }
        local current_clues = vim.b[bufnr].miniclue_config.clues or {}

        vim.b[bufnr].miniclue_config = {
          clues = vim.list_extend(current_clues, metals_clues),
        }

        keymap("<leader>gs", require("metals").goto_super_method, "super method")

        keymap("K", require("metals").type_of_range, "type of range", "v")

        keymap("<leader>lmw", function()
          require("metals").hover_worksheet({ border = "single" })
        end, "hover worksheet")

        keymap("<leader>lmt", require("metals.tvp").toggle_tree_view, "tree view")

        keymap("<leader>lmf", require("metals.tvp").reveal_in_tree, "find in tree")

        keymap("<leader>lmc", require("metals").commands, "commands")
        keymap("<leader>lmi", require("metals").import_build, "import build")
        keymap("<leader>lmd", require("metals").find_in_dependency_jars, "find in jars")
        keymap("<leader>lmo", require("metals").organize_imports, "organize imports")
        keymap("<leader>lmw", require("metals").hover_worksheet, "hover worksheet")
        keymap("<leader>lml", require("metals").toggle_logs, "toggle logs")

        keymap("<leader>lmva", function()
          require("metals").toggle_setting("showImplicitArguments")
        end, "view implicit arguments")

        keymap("<leader>lmvc", function()
          require("metals").toggle_setting("showImplicitConversionsAndClasses")
        end, "view implicit conversions")

        keymap("<leader>lmvs", function()
          require("metals").toggle_setting("enableSemanticHighlighting")
        end, "view semanting highlighting")

        keymap("<leader>lmvt", function()
          require("metals").toggle_setting("showInferredType")
        end, "view inferred type")

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

      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'Configure LSP keymaps',
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- I don't think this can happen but it's a wild world out there.
          if not client then
            vim.notify("No client attached", "error")
            return
          end

          on_attach(client, args.buf)
        end,
      })
    end,
  },
}
