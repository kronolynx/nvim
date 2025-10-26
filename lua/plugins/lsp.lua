local api = vim.api
local icons = require('util.icons')
-- Disable inlay hints initially (and enable if needed with my ToggleInlayHints command).
vim.g.inlay_hints = true

vim.diagnostic.config {
  -- virtual_text = false,
  update_in_insert = false, -- false so diags are updated on InsertLeave
  severity_sort = true,
  -- virtual_text = { spacing = 4 },
  virtual_text = { current_line = true, severity = { min = 'INFO', max = 'WARN' } },
  virtual_lines = { current_line = true, severity = { min = 'ERROR' } },
  float = {
    focusable = true,
    style = 'minimal',
    border = 'double',
    source = true,
    header = 'Diagnostic',
    prefix = '',
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
capabilities.workspace = {
  didChangeWatchedFiles = {
    dynamicRegistration = true,
  },
}

vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/scalameta/nvim-metals" },
}, { confirm = false })

if os.getenv("LSP_ENABLED") ~= "false" then
  require('fidget').setup()
  require('mason').setup()
  -- require('mason-lspconfig').setup()

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
    fish_lsp = {},
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
    lua_ls = {},
  }


  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

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

    local wk = require("which-key")
    wk.add(
      {
        { "<leader>l",  group = "lsp" },
        { "<leader>ld", group = "debug" },
        { "<leader>lv", group = "view" },
      })

    keymap("H", vim.lsp.buf.signature_help, "signature help")
    keymap("<M-h>", vim.lsp.buf.signature_help, "signature", "i")

    keymap("<leader>lr", vim.lsp.buf.rename, "rename")
    -- keymap( "<leader>la", vim.lsp.buf.code_action, "code action" )
    keymap("<leader>ll", vim.lsp.codelens.run, "code lens")
    keymap("<leader>lw", vim.lsp.buf.add_workspace_folder, "add workspace folder")
    keymap("K", vim.lsp.buf.hover, "Hover")

    keymap("<leader>gI", vim.lsp.buf.implementation, "implementation")
    keymap("<leader>gT", vim.lsp.buf.type_definition, "type definition")
    keymap("<leader>gR", vim.lsp.buf.references, "references")
    -- keymap("<leader>gS", vim.lsp.buf.document_symbol, "document symbol")
    keymap("<leader>li", vim.lsp.buf.incoming_calls, "incoming calls") -- Lists all the call sites of the symbol under the cursor in the quickfix window.
    keymap("<leader>lo", vim.lsp.buf.outgoing_calls, "outgoing calls") -- Lists all the items that are called by the symbol under the cursor in the quickfix window.
    keymap("<leader>lh", vim.lsp.buf.typehierarchy, "hierarchy")       -- Lists all the subtypes or supertypes of the symbol under the cursor in the quickfix window.
    keymap("<leader>l=", vim.lsp.buf.format, "format")                 -- Lists all the subtypes or supertypes of the symbol under the cursor in the quickfix window.
    -- FZF
    -- keymap("<leader>gI", "<cmd>FzfLua lsp_implementations<cr>", "implementation FZF")
    -- keymap("<leader>gT", "<cmd>FzfLua lsp_typedefs<cr>", "typedefs FZF")
    -- keymap("<leader>gR", "<cmd>FzfLua lsp_references<cr>", "references FZF")
    -- keymap("<leader>gSB", "<cmd>FzfLua lsp_document_symbols<cr>", "symbols buffer FZF")
    -- keymap("<leader>lI", "<cmd>FzfLua lsp_incoming_calls<cr>", "incoming calls FZF")
    -- keymap("<leader>lO", "<cmd>FzfLua lsp_outgoing_calls<cr>", "outgoing calls FZF")

    -- keymap("<leader>gSl", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "lsp live workspace symbols FZF")
    -- keymap("<leader>gSw", "<cmd>FzfLua lsp_workspace_symbols<cr>", "lsp symbols workspace FZF") -- doesn't work for metals
    -- keymap("<leader>gSw", vim.lsp.buf.workspace_symbol, "workspace symbol")


    -- keymap('<M-CR>', function() require('tiny-code-action').code_action() end, 'vim.lsp.buf.code_action()',
    --   { 'n', 'x' })
    keymap('<M-CR>', vim.lsp.buf.code_action, "code action")
    -- keymap( "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", "lsp code actions" )
    -- keymap("<leader>lf", "<cmd>FzfLua lsp_finder<cr>", "lsp finder FZF")

    -- Diagnostics keymaps
    keymap("<leader>dl", "<cmd>lua vim.diagnostic.open_float()<CR>", "line")
    keymap('<leader>dp', "<cmd>lua vim.diagnostic.goto_prev()<CR>", 'previous')
    keymap('<leader>dn', "<cmd>lua vim.diagnostic.goto_next()<CR>", 'next')
    -- keymap("<leader>dB", "<cmd>FzfLua lsp_document_diagnostics sort=true<cr>", "diagnostics buffer FZF") -- sort=2 // for reverse sort
    -- keymap("<leader>dW", "<cmd>FzfLua lsp_workspace_diagnostics sort=true<cr>", "diagnostics workspace FZF")
    -- keymap("<leader>dW", vim.lsp.buf.workspace_diagnostics, "diagnostics workspace") -- broken

    keymap('[d', function() vim.diagnostic.jump { count = -1 } end, 'Previous diagnostic')
    keymap(']d', function() vim.diagnostic.jump { count = 1 } end, 'Next diagnostic')
    keymap('[e', function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR } end,
      'Previous error')
    keymap(']e', function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR } end,
      'Next error')

    if client:supports_method('textDocument/signatureHelp') then
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
      api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
    end

    if client:supports_method('textDocument/documentHighlight') then
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

    if client:supports_method('codeLens/resolve') then
      api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = lsp_group,
        desc = 'Refresh code lens',
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      })
    end
  end

  -- Uncomment for trace logs from neovim
  -- vim.lsp.set_log_level('trace')

  api.nvim_create_autocmd('LspAttach', {
    desc = 'Configure LSP keymaps',
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      -- I don't think this can happen but it's a wild world out there.
      if not client then
        vim.notify("No client attached", vim.log.levels.ERROR)
        return
      end

      on_attach(client, args.buf)
    end,
  })


  vim.api.nvim_create_autocmd('FileType', {
    pattern = { "scala", "sbt", "java" },
    callback = function()
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
          hintsXRayMode = { enable = true }
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

      metals_config.on_attach = function(_, bufnr)
        ---@param lhs string
        ---@param rhs string|function
        ---@param desc string
        ---@param mode? string|string[]
        local function keymap(lhs, rhs, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        local wk = require("which-key")
        local metals_clues = {
          { "<leader>l",   group = "lsp" },
          { "<leader>lm",  group = "metals" },
          { "<leader>lmv", group = "view" },
        }
        wk.add(metals_clues)

        require("metals").setup_dap()

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
      end

      require("metals").initialize_or_attach(metals_config)
      -- local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
      -- api.nvim_create_autocmd("FileType", {
      --   pattern = self.ft,
      --   callback = function()
      --
      --   end,
      --   group = nvim_metals_group,
      -- })
    end
  })
end
