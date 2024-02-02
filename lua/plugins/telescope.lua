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
      "nvim-telescope/telescope-frecency.nvim",
      dependencies = { "kkharji/sqlite.lua" }
    },
  },
  opt = function()
    local actions = require("telescope.actions")

    local open_with_trouble = function(...)
      return require("trouble.providers.telescope").open_with_trouble(...)
    end
    local open_selected_with_trouble = function(...)
      return require("trouble.providers.telescope").open_selected_with_trouble(...)
    end
    -- local find_files_no_ignore = function()
    --   local action_state = require("telescope.actions.state")
    --   local line = action_state.get_current_line()
    --   Util.telescope("find_files", { no_ignore = true, default_text = line })()
    -- end
    -- local find_files_with_hidden = function()
    --   local action_state = require("telescope.actions.state")
    --   local line = action_state.get_current_line()
    --   Util.telescope("find_files", { hidden = true, default_text = line })()
    -- end

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        mappings = {
          i = {
            ["<c-t>"] = open_with_trouble,
            ["<a-t>"] = open_selected_with_trouble,
            -- ["<a-i>"] = find_files_no_ignore,
            -- ["<a-h>"] = find_files_with_hidden,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
    }
  end,
  keys = {
    -- { "<leader>gf", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    -- { "<leader>tr", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
    {
      "<leader>bs",
      "<cmd>Telescope marks<CR>",
      desc =
      "Marks"
    },
    {
      "<leader>xk",
      "<cmd>Telescope keymaps<CR>",
      desc =
      "Keymaps"
    },
    { "<leader>ml", "<cmd>Telescope git_commits<CR>" },
    { "<leader>sp", "<cmd>Telescope live_grep<CR>" }, -- search in path

    {
      "<leader>gf",
      "<cmd>lua require('telescope.builtin').find_files({hidden=false})<cr>",
      desc =
      "find files"
    },
    {
      "<leader>mf",
      "<cmd>lua require('telescope.builtin').git_files({show_untracked=true})<cr>",
      desc =
      "files"
    },
    {
      "<leader>to",
      "<cmd>lua require('telescope.builtin').oldfiles({only_cwd=true})<cr>",
      desc =
      "tabs old"
    },
    {
      "<leader>fp",
      "<cmd>lua require('telescope.builtin').live_grep()<cr>",
      desc =
      "find in files"
    },
    {
      "<leader>tr",
      "<cmd>lua require('telescope.builtin').buffers({show_all_buffers = false, sort_mru=true, ignore_current_buffer=true})<cr>",
      desc =
      "recent tabs"
    },
    {
      "<leader>/", telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files'}
    },
    -- { "<leader>sp", "<cmd>lua require('telescope.builtin').spell_suggest()<cr>" },
    {
      "<leader>ft",
      "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
      desc =
      "find in tab"
    },
    { "<leader>lxq", "<cmd> lua require('telescope.builtin').quickfix()<cr>" },
  },
  config = function()
    local action_layout = require("telescope.actions.layout")
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          },
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
          }
        },
        path_display = { "truncate" },
        pickers = {
          buffers = {
            sort_mru = true,
          }
        },
        mappings = {
          n = {
            ["<M-p>"] = action_layout.toggle_preview
          },
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            ["<C-h>"] = "which_key",
            ["<M-p>"] = action_layout.toggle_preview
          }
        },
        -- Long Scala packages make me sad
        layout_strategy = "vertical",
      },
    })

    telescope.load_extension("ui-select")
    telescope.load_extension("fzf")
  end,
  opts = {
    function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end
      -- local find_files_no_ignore = function()
      --   local action_state = require("telescope.actions.state")
      --   local line = action_state.get_current_line()
      --   Util.telescope("find_files", { no_ignore = true, default_text = line })()
      -- end
      -- local find_files_with_hidden = function()
      --   local action_state = require("telescope.actions.state")
      --   local line = action_state.get_current_line()
      --   Util.telescope("find_files", { hidden = true, default_text = line })()
      -- end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              -- ["<a-i>"] = find_files_no_ignore,
              -- ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
  }
}
