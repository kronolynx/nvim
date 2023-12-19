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
  keys = {
    -- { "<leader>gf", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    -- { "<leader>tr", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
    { "<leader>bs", "<cmd>Telescope marks<CR>",      desc = "Marks" },
    { "<leader>xk", "<cmd>Telescope keymaps<CR>",    desc = "Keymaps" },
    { "<leader>ml", "<cmd>Telescope git_commits<CR>" },
    { "<leader>sp", "<cmd>Telescope live_grep<CR>" },  -- search in path

    { "<leader>gf", "<cmd>lua require('telescope.builtin').find_files({hidden=false})<cr>", desc = "find files" },
    { "<leader>mf", "<cmd>lua require('telescope.builtin').git_files({show_untracked=true})<cr>", desc = "files" },
    { "<leader>tR", "<cmd>lua require('telescope.builtin').oldfiles({only_cwd=true})<cr>", desc = "tabs old" },
    { "<leader>fp", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "find in files" },
    { "<leader>tr", "<cmd>lua require('telescope.builtin').buffers({show_all_buffers = false, sort_mru=true, ignore_current_buffer=true})<cr>", desc = "recent tabs" },
    -- { "<leader>sp", "<cmd>lua require('telescope.builtin').spell_suggest()<cr>" },
    { "<leader>ft", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", desc = "find in tab" },
    { "<leader>lxq", "<cmd> lua require('telescope.builtin').quickfix()<cr>" },
  },
  config = function()
    local action_layout = require("telescope.actions.layout")
    local telescope = require("telescope") 

    telescope.setup({
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
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<C-h>"] = "which_key",
          ["<M-p>"] = action_layout.toggle_preview
        }
      },
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
      }
    })

    telescope.load_extension("ui-select")
    telescope.load_extension("fzf")
  end
}
