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
  },
  keys = {
    -- { "<leader>sp", "<cmd>lua require('telescope.builtin').spell_suggest()<cr>" },
    { "<leader>/",    telescope_live_grep_open_files,                                                              desc = 'search [/] in Open Files' },
    { "<leader>bs",   "<cmd>Telescope marks<CR>",                                                                  desc = "marks" },
    { "<leader>fp",   "<cmd>lua require('telescope.builtin').live_grep()<cr>",                                     desc = "find in files" },
    { "<leader>ft",   "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",                     desc = "find in tab" },
    { "<leader>gf",   "<cmd>lua require('telescope.builtin').find_files({hidden=false})<cr>",                      desc = "find files" },
    { "<leader>sf",   "<cmd>lua require('telescope.builtin').find_files({hidden=false})<cr>",                      desc = "file" },
    { "<leader>lq",   "<cmd>lua require('telescope.builtin').quickfix()<cr>",                                      desc = "quickfix" },
    { "<leader>mf",   "<cmd>lua require('telescope.builtin').git_status()<cr>",                                    desc = "files" },
    { "<leader>mb",   "<cmd>lua require('telescope.builtin').git_branches()<cr>",                                  desc = "branches" },
    { "<leader>mc",   "<cmd>lua require('telescope.builtin').git_commits()<cr>",                                   desc = "commits" },
    { "<leader>sp",   "<cmd>Telescope live_grep<CR>",                                                              desc = "files" },
    { "<leader>sP",   "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",              desc = "files with args" },
    { "<leader>sb",   "<cmd>Telescope current_buffer_fuzzy_find fuzzy=false<CR>",                                  desc = "buffer" },
    { "<leader>sr",   "<cmd>Telescope resume<CR>",                                                                 desc = "resume" },
    { "<leader>sw",   "<cmd>Telescope grep_string<CR>",                                                            desc = "word at cursor" },
    { "<leader>to",   "<cmd>lua require('telescope.builtin').oldfiles({only_cwd=true, sort_lastused = true})<cr>", desc = "tabs old" },
    { "<leader>tr",   "<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true})<CR>",                desc = "buffers" },
    { "<leader>vE",   "<cmd>Telescope diagnostics<CR>",                                                            desc = "errors" },
    { "<leader>vk",   "<cmd>Telescope keymaps<CR>",                                                                desc = "Keymaps" },
    { "<leader>ssd",  "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>",                 desc = "dynamic workspace" },
    { "<leader>ssf",  "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",                          desc = "file workspace" },
    { "<leader>ssw",  "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>",                         desc = "workspace" },
  },
  config = function()
    local action_layout = require("telescope.actions.layout")
    local actions = require("telescope.actions")
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")

    local function filename_first(_, path)
      local tail = vim.fs.basename(path)
      local parent = vim.fn.fnamemodify(vim.fs.dirname(path), ":.")
      if (vim.fn.len(parent) > 80) then
        parent = vim.fn.pathshorten(parent, 3)
      end
      if parent == "." then
        return tail
      end
      return string.format("%s\t\t%s", tail, parent)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
      end,
    })

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
      defaults = {
        path_display = filename_first,
        -- path_display = { "smart" },
        pickers = {
          buffers = {
            -- sort_mru = true,
            -- ignore_current_buffer = true,
            sort_lastused = true
          }
        },
        mappings = {
          n = {
            ["<M-p>"] = action_layout.toggle_preview,
            ["<S-Up>"] = actions.preview_scrolling_up,
            ["<S-Down>"] = actions.preview_scrolling_down,
            ["<S-Left>"] = actions.preview_scrolling_left,
            ["<S-Right>"] = actions.preview_scrolling_right,
            ["<S-k>"] = actions.preview_scrolling_up,
            ["<S-j>"] = actions.preview_scrolling_down,
            ["<S-h>"] = actions.preview_scrolling_left,
            ["<S-l>"] = actions.preview_scrolling_right,
          },
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ["<S-Up>"] = actions.preview_scrolling_up,
            ["<S-Down>"] = actions.preview_scrolling_down,
            ["<S-Left>"] = actions.preview_scrolling_left,
            ["<S-Right>"] = actions.preview_scrolling_right,
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
    telescope.load_extension("live_grep_args")
  end,
}
