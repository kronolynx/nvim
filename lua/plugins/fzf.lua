vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
}, { confirm = false })


vim.defer_fn(function()
  local actions = require "fzf-lua.actions"
  local icons = require('util.icons')

  local setup = {
    "hide",
    "telescope", -- :FzfLua profiles
    defaults = {
      formatter  = "path.filename_first",
      cwd_only   = true,
      sync       = false, -- TODO find out what does this do ???
      file_icons = true,
    },
    keymap = {
      fzf = {
        -- use cltr-q to select all items and convert to quickfix list
        ["ctrl-q"] = "select-all+accept",
      },
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
        ["ctrl-s"] = function(selected, opts)
          -- Filter by filename first, then grep content in those files (like yazi 's' then 'S')
          local fzf_lua = require('fzf-lua')
          if not selected or #selected == 0 then
            fzf_lua.live_grep()
          else
            -- Extract file paths from selected items
            local files = vim.tbl_map(function(item)
              return fzf_lua.path.entry_to_file(item).path
            end, selected)
            -- Grep only in selected files
            fzf_lua.live_grep({
              filespec = table.concat(files, " "),
              prompt = "Grep in filtered files❯ "
            })
          end
        end,
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
      diag_icons   = {
        icons.diagnostics.ERROR,
        icons.diagnostics.WARN,
        icons.diagnostics.INFO,
        icons.diagnostics.HINT,
      },
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
  require("fzf-lua").setup(setup)

  -- ---@diagnostic disable-next-line: duplicate-set-field
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

  -- require('fzf-lua').register_ui_select()

  vim.keymap.set({ "n", "v" }, "<M-CR>", "<cmd>FzfLua lsp_code_actions<CR>")
  vim.keymap.set("n", "<leader>gf", "<cmd>FzfLua files<cr>", { desc = "find files" })
  vim.keymap.set("n", "<leader>gh", "<cmd>FzfLua helptags<cr>", { desc = "help tags" })
  vim.keymap.set('n', '<leader>gH', '<cmd>FzfLua highlights<cr>', { desc = 'Highlights' })
  vim.keymap.set("n", "<leader>gj", "<cmd>FzfLua jumps<cr>", { desc = "jumps" })
  vim.keymap.set("n", "<leader>gk", "<cmd>FzfLua keymaps<cr>", { desc = "keymaps" })
  vim.keymap.set("n", "<leader>gm", "<cmd>FzfLua marks<cr>", { desc = "marks" })
  vim.keymap.set("n", "<leader>gR", "<cmd>FzfLua registers<cr>", { desc = "registers" })

  -- git
  vim.keymap.set("n", "<leader>mB", "<cmd>FzfLua git_branches<cr>", { desc = "git branches" })
  vim.keymap.set("n", "<leader>mc", "<cmd>FzfLua git_commits<cr>", { desc = "git commits" })
  vim.keymap.set("n", "<leader>mbc", "<cmd>FzfLua git_bcommits<cr>", { desc = "git commits buffer" })
  vim.keymap.set("n", "<leader>mf", "<cmd>FzfLua git_files<cr>", { desc = "git files" })
  vim.keymap.set("n", "<leader>ms", "<cmd>FzfLua git_status<cr>", { desc = "git status" })
  vim.keymap.set("n", "<leader>mS", "<cmd>FzfLua git_stash<cr>", { desc = "git stash" })

  -- search
  vim.keymap.set("n", "<leader>sc", "<cmd>FzfLua resume<cr>", { desc = "continue" })
  vim.keymap.set("n", "<leader>ss", "<cmd>FzfLua live_grep<cr>", { desc = "Grep" })
  vim.keymap.set('x', '<leader>ss', '<cmd>FzfLua grep_visual<cr>', { desc = 'Grep visual' })
  vim.keymap.set("n", "<leader>sW", "<cmd>FzfLua grep_cword<cr>", { desc = "Grep word" })

  -- buffers
  vim.keymap.set("n", "<leader>to", "<cmd>FzfLua oldfiles<cr>", { desc = "old files" })
  vim.keymap.set("n", "<leader>tr", "<cmd>FzfLua buffers<cr>", { desc = "recent files" })

  vim.keymap.set('n', 'z=', '<cmd>FzfLua spell_suggest<cr>', { desc = 'Spelling suggestions' })

  -- diagnostics
  vim.keymap.set('n', '<leader>dw', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', { desc = 'Workspace' })
  vim.keymap.set('n', '<leader>db', '<cmd>FzfLua lsp_document_diagnostics<cr>', { desc = 'document' })
  vim.keymap.set('n', '<leader>ld', '<cmd>FzfLua lsp_document_diagnostics<cr>', { desc = 'Document diagnostics' })


  -- LSP
  vim.keymap.set('n', '<leader>gd', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'Definitions' })
  vim.keymap.set('n', '<leader>gD', '<cmd>FzfLua lsp_declarations<cr>', { desc = 'Declarations' })
  vim.keymap.set('n', '<leader>gt', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'type definition' })
  vim.keymap.set('n', '<leader>gi', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'implementations' })
  vim.keymap.set('n', '<leader>gr', '<cmd>FzfLua lsp_references<cr>', { desc = 'references' })
  vim.keymap.set('n', '<leader>gS', '<cmd>FzfLua lsp_type_sub<cr>', { desc = 'subtype' })
  vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua lsp_type_super<cr>', { desc = 'super' })
  vim.keymap.set('n', '<leader>gci', '<cmd>FzfLua lsp_incoming_calls<cr>', { desc = 'incoming call' })
  vim.keymap.set('n', '<leader>gco', '<cmd>FzfLua lsp_outgoing_calls<cr>', { desc = 'outgoing call' })

  -- Symbols
  vim.keymap.set('n', '<leader>lsd', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'Document' })
  vim.keymap.set('n', '<leader>lsw', '<cmd>FzfLua lsp_workspace_symbols<cr>', { desc = 'Workspace' })
  vim.keymap.set('n', '<leader>lsg', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', { desc = 'Workspace (live)' })
end, 200)
