return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<M-CR>",      '<cmd>FzfLua lsp_code_actions<CR>', mode = { "v", "n" } },

    { "<leader>gf",  "<cmd>FzfLua files<cr>",            desc = "find files" },
    { "<leader>gh",  "<cmd>FzfLua helptags<cr>",         desc = "help tags" },
    { "<leader>gj",  "<cmd>FzfLua jumps<cr>",            desc = "jumps" },
    { "<leader>gk",  "<cmd>FzfLua keymaps<cr>",          desc = "keymaps" },
    { "<leader>gm",  "<cmd>FzfLua marks<cr>",            desc = "marks" },
    -- { "<leader>gR",  "<cmd>FzfLua registers<cr>",        desc = "registers" },


    -- git
    { "<leader>mB",  "<cmd>FzfLua git_branches<cr>",     desc = "git branches" },
    { "<leader>mc",  "<cmd>FzfLua git_commits<cr>",      desc = "git commits" },
    { "<leader>mbc", "<cmd>FzfLua git_bcommits<cr>",     desc = "git commits buffer" },
    { "<leader>mf",  "<cmd>FzfLua git_files<cr>",        desc = "git files" },
    { "<leader>ms",  "<cmd>FzfLua git_status<cr>",       desc = "git status" },
    { "<leader>mS",  "<cmd>FzfLua git_stash<cr>",        desc = "git stash" },

    -- search
    { "<leader>sc",  "<cmd>FzfLua resume<cr>",           desc = "continue" },
    { "<leader>ss",  "<cmd>FzfLua live_grep<cr>",        desc = "search path" },
    { "<leader>sW",  "<cmd>FzfLua grep_cword<cr>",       desc = "search cursor" },

    -- buffers
    { "<leader>to",  "<cmd>FzfLua oldfiles<cr>",         desc = "old files" },
    { "<leader>tr",  "<cmd>FzfLua buffers<cr>",          desc = "recent files" },
  },
  opts = function()
    local actions = require "fzf-lua.actions"
    local icons = require('util.icons')
    local fzf = require('fzf-lua')

    return {
      "hide",
      "telescope", -- :FzfLua profiles
      defaults = {
        formatter  = "path.filename_first",
        cwd_only   = true,
        sync       = false, -- TODO find out what does this do ???
        file_icons = true,
      },
      winopts = {
        height     = 0.85,       -- window height
        width      = 0.80,       -- window width
        row        = 0.35,       -- window row position (0=top, 1=bottom)
        col        = 0.50,       -- window col position (0=left, 1=right)
        fullscreen = false,      -- start fullscreen?
        backdrop   = 100,        -- Backdrop opacity, 0 is fully opaque, 100 is fully transparent (i.e. disabled)
        preview    = {
          hidden   = 'nohidden', -- hidden|nohidden
          vertical = 'up:60%',   -- up|down:size
          layout   = 'vertical', -- horizontal|vertical|flex
        },
      },
      fzf_opts = {
        ["--ansi"]           = true,
        ["--info"]           = "inline-right", -- fzf < v0.42 = "inline"
        ["--height"]         = "100%",
        ["--layout"]         = "reverse",
        -- ["--layout"]         = "default", -- TODO this is broken
        ["--border"]         = "none",
        ["--highlight-line"] = true,
      },
      files = {
        prompt       = 'Files❯ ',
        multiprocess = true, -- run command in a separate process
        git_icons    = true, -- show git icons?
        color_icons  = true, -- colorize file|git icons
        actions      = {
          ["ctrl-g"] = { actions.toggle_ignore },
        }
      },
      grep = {
        header_prefix = icons.misc.search .. ' ',
        rg_glob = true, -- always parse globs in both 'grep' and 'live_grep'
      },
      lsp = {
        prompt_postfix      = '❯ ', -- will be appended to the LSP label
        ignore_current_line = true, -- not sure if I want this behaviour
        includeDeclaration  = true, -- include current declaration in LSP context
        async_or_timeout    = 5000, -- timeout(ms) or 'true' for async calls
        git_icons           = false,
        finder              = {
          includeDeclaration = false, -- include current declaration in LSP context
        },
        symbols             = {
          symbol_icons = icons.symbol_kinds,
          symbol_style = 2 -- 1: icon+kind, 2: icon only, 3: kind only, false: disable
        }
      },
      git = {
        status = {
          actions = {
            ["right"]  = false,
            ["left"]   = false,
            ["ctrl-x"] = { fn = actions.git_reset, reload = true },
            ["tab"]    = { fn = actions.git_stage_unstage, reload = true },
          }
        }
      },
      diagnostics = {
        prompt       = 'Diagnostics❯ ',
        git_icons    = false,
        diag_icons   = true,
        diag_source  = false, -- display diag source (e.g. [pycodestyle])
        icon_padding = ' ',   -- add padding for wide diagnostics signs
        multiline    = true,  -- concatenate multi-line diags into a single line
        signs        = {
          ["Error"] = { text = '', texthl = "DiagnosticError" },
          ["Warn"]  = { text = '', texthl = "DiagnosticWarn" },
          ["Info"]  = { text = '', texthl = "DiagnosticInfo" },
          ["Hint"]  = { text = '', texthl = "DiagnosticHint" },
        },
      },
    }
  end,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(items, opts, on_choice)
      local ui_select = require 'fzf-lua.providers.ui_select'

      -- Register the fzf-lua picker the first time we call select.
      if not ui_select.is_registered() then
        ui_select.register(function(ui_opts)
          if ui_opts.kind == 'luasnip' then
            ui_opts.prompt = 'Snippet choice: '
            ui_opts.winopts = {
              relative = 'cursor',
              height = 0.35,
              width = 0.3,
            }
          elseif ui_opts.kind == 'color_presentation' then
            ui_opts.winopts = {
              relative = 'cursor',
              height = 0.35,
              width = 0.3,
            }
          else
            ui_opts.winopts = { height = 0.5, width = 0.4 }
          end

          -- Use the kind (if available) to set the previewer's title.
          if ui_opts.kind then
            ui_opts.winopts.title = string.format(' %s ', ui_opts.kind)
          end

          return ui_opts
        end)
      end

      -- Don't show the picker if there's nothing to pick.
      if #items > 0 then
        return vim.ui.select(items, opts, on_choice)
      end
    end
  end,
}
