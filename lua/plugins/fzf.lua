return {
  "ibhagwan/fzf-lua",
  enabled = true,
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-CR>",      '<cmd>FzfLua lsp_code_actions<CR>',           mode = { "v", "n" } },

    -- { "<leader>gD",  "<cmd>FzfLua lsp_declarations<cr>",           desc = "lsp declarations" },
    { "<leader>gd",  "<cmd>FzfLua lsp_definitions<cr>",            desc = "lsp definitions" },
    { "<leader>gf",  "<cmd>FzfLua files<cr>",                      desc = "find files" },
    { "<leader>gh",  "<cmd>FzfLua helptags<cr>",                   desc = "help tags" },

    -- lsp
    { "<leader>gi",  "<cmd>FzfLua lsp_implementations<cr>",        desc = "lsp implementations" },
    { "<leader>gr",  "<cmd>FzfLua lsp_references<cr>",             desc = "lsp references" },
    { "<leader>gsb", "<cmd>FzfLua lsp_document_symbols<cr>",       desc = "lsp symbols buffer" },
    { "<leader>gsl", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "lsp live workspace symbols" },
    { "<leader>gsw", "<cmd>FzfLua lsp_workspace_symbols<cr>",      desc = "lsp symbols workspace" },
    { "<leader>gt",  "<cmd>FzfLua lsp_typedefs<cr>",               desc = "lsp typedefs" },

    { "<leader>la",  "<cmd>FzfLua lsp_code_actions<cr>",           desc = "lsp code actions" },
    { "<leader>lci", "<cmd>FzfLua lsp_incoming_calls<cr>",         desc = "lsp calls incoming" },
    { "<leader>lco", "<cmd>FzfLua lsp_outgoing_calls<cr>",         desc = "lsp calls outgoing" },
    { "<leader>lf",  "<cmd>FzfLua lsp_finder<cr>",                 desc = "lsp finder" },

    -- git
    { "<leader>mb",  "<cmd>FzfLua git_branches<cr>",               desc = "git branches" },
    { "<leader>mc",  "<cmd>FzfLua git_commits<cr>",                desc = "git commits" },
    { "<leader>mf",  "<cmd>FzfLua git_files<cr>",                  desc = "git files" },
    { "<leader>mg",  "<cmd>FzfLua git_status<cr>",                 desc = "git status" },

    -- search
    { "<leader>ss",  "<cmd>FzfLua live_grep<cr>",                  desc = "search path" },
    { "<leader>sr",  "<cmd>FzfLua resume<cr>",                     desc = "resume" },

    { "<leader>vk",  "<cmd>FzfLua keymaps<cr>",                    desc = "keymaps" },

    -- buffers
    { "<leader>to",  "<cmd>FzfLua oldfiles<cr>",                   desc = "old tabs" },
    { "<leader>tr",  "<cmd>FzfLua buffers<cr>",                    desc = "recent tabs" },
    -- TODO find keys for the following
    { "<leader>xmb", "<cmd>FzfLua git_bcommits<cr>",               desc = "git commits buffer" },
    { "<leader>xms", "<cmd>FzfLua git_stash<cr>",                  desc = "git stash" },
    { "<leader>xgL", "<cmd>FzfLua blines<cr>",                     desc = "buffer lines" },
    { "<leader>xgc", "<cmd>FzfLua changes<cr>",                    desc = "changes" },
    { "<leader>xgj", "<cmd>FzfLua jumps<cr>",                      desc = "jumps" },
    { "<leader>xgl", "<cmd>FzfLua lines<cr>",                      desc = "lines" },
    { "<leader>xgm", "<cmd>FzfLua marks<cr>",                      desc = "marks" },
    -- TODO decide if want to keep
    { "<leader>xdb", "<cmd>FzfLua lsp_document_diagnostics<cr>",   desc = "lsp diagnostics buffer" },
    { "<leader>xdw", "<cmd>FzfLua lsp_workspace_diagnostics<cr>",  desc = "lsp diagnostics workspace" },

    -- TODO add  dap_breakpoints, dap_variables, command_history, search_history, other grep stuff, registers

  },
  config = function()
    -- calling `setup` is optional for customization
    local actions = require "fzf-lua.actions"

    require 'fzf-lua'.setup {
      winopts     = {
        height     = 0.85,       -- window height
        width      = 0.80,       -- window width
        row        = 0.35,       -- window row position (0=top, 1=bottom)
        col        = 0.50,       -- window col position (0=left, 1=right)
        fullscreen = false,      -- start fullscreen?
        preview    = {
          hidden   = 'nohidden', -- hidden|nohidden
          vertical = 'up:60%',   -- up|down:size
          layout   = 'vertical', -- horizontal|vertical|flex
        },
      },
      fzf_opts    = {
        -- options are sent as `<left>=<right>`
        -- set to `false` to remove a flag
        -- set to `true` for a no-value flag
        -- for raw args use `fzf_args` instead
        ["--ansi"]   = true,
        ["--info"]   = "inline-right", -- fzf < v0.42 = "inline"
        ["--height"] = "100%",
        ["--layout"] = "default",
        ["--border"] = "none",
      },
      files       = {
        -- previewer      = "bat",          -- uncomment to override previewer
        -- (name from 'previewers' table)
        -- set to 'false' to disable
        prompt       = 'Files❯ ',
        multiprocess = true, -- run command in a separate process
        git_icons    = true, -- show git icons?
        file_icons   = true, -- show file icons?
        color_icons  = true, -- colorize file|git icons
        -- path_shorten   = 1,              -- 'true' or number, shorten path?
        -- custom vscode-like formatter where the filename is first:
        formatter    = "path.filename_first",
        actions      = {
          -- inherits from 'actions.files', here we can override
          -- or set bind to 'false' to disable a default action
          -- action to toggle `--no-ignore`, requires fd or rg installed
          ["ctrl-g"] = { actions.toggle_ignore },
          -- uncomment to override `actions.file_edit_or_qf`
          --   ["default"]   = actions.file_edit,
          -- custom actions are available too
          --   ["ctrl-y"]    = function(selected) print(selected[1]) end,
        }
      },
      grep        = {
        cwd_only  = true,
        formatter = "path.filename_first",
        rg_glob   = true, -- always parse globs in both 'grep' and 'live_grep'
      },
      buffers     = {
        cwd_only  = true,
        formatter = "path.filename_first",
      },
      oldfiles    = {
        cwd_only  = true,
        formatter = "path.filename_first",
      },
      lsp         = {
        prompt_postfix     = '❯ ', -- will be appended to the LSP label
        -- to override use 'prompt' instead
        cwd_only           = true,
        formatter          = "path.filename_first",
        async_or_timeout   = 5000, -- timeout(ms) or 'true' for async calls
        file_icons         = true,
        git_icons          = false,
        -- The equivalent of using `includeDeclaration` in lsp buf calls, e.g:
        -- :lua vim.lsp.buf.references({includeDeclaration = false})
        includeDeclaration = false, -- include current declaration in LSP context
        -- settings for 'lsp_{document|workspace|lsp_live_workspace}_symbols'
      },
      diagnostics = {
        prompt       = 'Diagnostics❯ ',
        cwd_only     = true,
        formatter    = "path.filename_first",
        file_icons   = true,
        git_icons    = false,
        diag_icons   = true,
        diag_source  = true, -- display diag source (e.g. [pycodestyle])
        icon_padding = '',   -- add padding for wide diagnostics signs
        multiline    = true, -- concatenate multi-line diags into a single line
        -- set to `false` to display the first line only
        -- by default icons and highlights are extracted from 'DiagnosticSignXXX'
        -- and highlighted by a highlight group of the same name (which is usually
        -- set by your colorscheme, for more info see:
        --   :help DiagnosticSignHint'
        --   :help hl-DiagnosticSignHint'
        -- only uncomment below if you wish to override the signs/highlights
        -- define only text, texthl or both (':help sign_define()' for more info)
        -- signs = {
        --   ["Error"] = { text = "", texthl = "DiagnosticError" },
        --   ["Warn"]  = { text = "", texthl = "DiagnosticWarn" },
        --   ["Info"]  = { text = "", texthl = "DiagnosticInfo" },
        --   ["Hint"]  = { text = "󰌵", texthl = "DiagnosticHint" },
        -- },
        -- limit to specific severity, use either a string or num:
        --   1 or "hint"
        --   2 or "information"
        --   3 or "warning"
        --   4 or "error"
        -- severity_only:   keep any matching exact severity
        -- severity_limit:  keep any equal or more severe (lower)
        -- severity_bound:  keep any equal or less severe (higher)
      },
    }
  end
}
