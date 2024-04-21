local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    {
      "isak102/telescope-git-file-history.nvim",
      dependencies = { "tpope/vim-fugitive" }
    }
  },
  keys = {
    -- { "<leader>sp", "<cmd>lua require('telescope.builtin').spell_suggest()<cr>" },
    -- { "<leader>sp",   "<cmd>Telescope live_grep<CR>",                                                              desc = "files" },
    { "<leader>bs",  "<cmd>Telescope marks<CR>",                                                         desc = "marks" },
    { "<leader>gf",  "<cmd>lua require('telescope.builtin').find_files({hidden=false})<cr>",             desc = "find files" },
    { "<leader>lq",  "<cmd>lua require('telescope.builtin').quickfix()<cr>",                             desc = "quickfix" },
    -- git
    { "<leader>mb",  "<cmd>lua require('telescope.builtin').git_branches()<cr>",                         desc = "branches" },
    { "<leader>mc",  "<cmd>lua require('telescope.builtin').git_commits()<cr>",                          desc = "commits" },
    { "<leader>mg",  "<cmd>lua require('telescope.builtin').git_status()<cr>",                           desc = "git status" },
    { "<leader>mh",  "<cmd>lua require('telescope').extensions.git_file_history.git_file_history()<cr>", desc = "history" },
    -- search
    -- { "<leader>sp",  "<cmd>lua require('telescope.builtin').live_grep()<cr>",                            desc = "files" },
    { "<leader>sp",  "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",     desc = "files with args" },
    { "<leader>sb",  "<cmd>Telescope current_buffer_fuzzy_find fuzzy=false<CR>",                         desc = "buffer" },
    { "<leader>sf",  "<cmd>lua require('telescope.builtin').find_files({hidden=false})<cr>",             desc = "file" },
    { "<leader>so",  telescope_live_grep_open_files,                                                     desc = 'open Files' },
    { "<leader>sc",  "<cmd>Telescope resume<CR>",                                                        desc = "continue previous search" },
    { "<leader>ssd", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>",        desc = "dynamic workspace" },
    { "<leader>ssf", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",                 desc = "file workspace" },
    {
      "<leader>ssw",
      function()
        vim.ui.input({ prompt = "Workspace symbols: " }, function(query)
          require("telescope.builtin").lsp_workspace_symbols({ query = query })
        end)
      end,
      desc = "workspace"
    },
    { "<leader>st", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",                     desc = "current tab" },
    { "<leader>sw", "<cmd>Telescope grep_string<CR>",                                                            desc = "word at cursor" },
    -- help
    { "<leader>gh", "<cmd>lua require('telescope.builtin').help_tags()<CR>",                                     desc = "help" },
    -- buffers
    { "<leader>to", "<cmd>lua require('telescope.builtin').oldfiles({only_cwd=true, sort_lastused = true})<cr>", desc = "old" },
    { "<leader>tr", "<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true})<CR>",                desc = "recent" },

    { "<leader>vk", "<cmd>Telescope keymaps<CR>",                                                                desc = "Keymaps" },
  },
  config = function()
    local action_layout = require("telescope.actions.layout")
    local actions = require("telescope.actions")
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")
    local entry_display = require('telescope.pickers.entry_display')

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
      end,
    })

    local symbol_to_icon_map = {
      ['class'] = { icon = ' ', hi = 'TelescopeResultClass' },
      ['type'] = { icon = ' ', hi = 'TelescopeResultClass' },
      ['struct'] = { icon = ' ', hi = 'TelescopeResultStruct' },
      ['enum'] = { icon = ' ', hi = 'TelescopeResultClass' },
      ['union'] = { icon = ' ', hi = 'TelescopeResultClass' },
      ['interface'] = { icon = ' ', hi = 'TelescopeResultMethod' },
      ['method'] = { icon = ' ', hi = 'TelescopeResultMethod' },
      ['function'] = { icon = 'ƒ ', hi = 'TelescopeResultFunction' },
      ['constant'] = { icon = ' ', hi = 'TelescopeResultConstant' },
      ['field'] = { icon = ' ', hi = 'TelescopeResultField' },
      ['property'] = { icon = ' ', hi = 'TelescopeResultField' }
    }

    local displayer = entry_display.create({
      separator = ' ',
      items = {
        { width = 2 },
        { remaining = true }
      }
    })

    function maker()
      local entry_maker = require('telescope.make_entry').gen_from_lsp_symbols({})
      return function(line)
        local originalEntryTable = entry_maker(line)
        originalEntryTable.display = function(entry)
          local kind_and_higr = symbol_to_icon_map[entry.symbol_type:lower()] or
              { icon = ' ', hi = 'TelescopeResultsNormal' }
          local dot_idx = entry.symbol_name:reverse():find("%.") or entry.symbol_name:reverse():find("::")
          local symbol, qualifiier

          if dot_idx == nil then
            symbol = entry.symbol_name
            qualifiier = entry.filename
          else
            symbol = entry.symbol_name:sub(1 - dot_idx)
            qualifiier = entry.symbol_name:sub(1, #entry.symbol_name - #symbol - 1)
          end

          return displayer({
            { kind_and_higr.icon, kind_and_higr.hi },
            string.format("%s\t\tin %s", symbol, qualifiier)
          })
        end

        return originalEntryTable
      end
    end

    telescope.setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {}
        },
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
        },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = {         -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        }
      },
      pickers = {
        lsp_dynamic_workspace_symbols = {
          entry_maker = maker()
        }
      },
      defaults = {
        path_display = {
          filename_first = {
            reverse_directories = true
          }
        },
        pickers = {
          buffers = {
            -- sort_mru = true,
            -- ignore_current_buffer = true,
            sort_lastused = true
          },
        },
        mappings = {
          n = {
            ["<M-p>"] = action_layout.toggle_preview,
            ["<S-Left>"] = actions.preview_scrolling_left,
            ["<S-Right>"] = actions.preview_scrolling_right,
            -- todo match lazy <c-u> <c-d> to make things homogeneous
            ["<S-k>"] = actions.preview_scrolling_up,
            ["<S-j>"] = actions.preview_scrolling_down,
            ["<S-h>"] = actions.preview_scrolling_left,
            ["<S-l>"] = actions.preview_scrolling_right,
          },
          i = {
            ["<S-Up>"] = actions.preview_scrolling_up,
            ["<S-Down>"] = actions.preview_scrolling_down,
            ["<S-Left>"] = actions.preview_scrolling_left,
            ["<S-Right>"] = actions.preview_scrolling_right,
            ["<M-p>"] = action_layout.toggle_preview
          }
        },
        -- Long Scala packages make me sad
        layout_strategy = "vertical",
      },
    })

    telescope.load_extension("ui-select")
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
    telescope.load_extension("git_file_history")
  end,
}
