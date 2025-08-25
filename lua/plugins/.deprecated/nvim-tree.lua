return {
  {
    'nvim-tree/nvim-tree.lua',
    lazy = true,
    keys = {
      {
        '<leader>gg',
        function()
          local api = require('nvim-tree.api').tree
          api.open({ focus = true, find_file = true })
        end,
        desc = 'current file in explorer',
      },
      {
        '<M-f>',
        function()
          require('nvim-tree.api').tree.toggle()
        end,
        desc = 'file explorer (tree)',
      },
    },
    config = function()
      local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              data = data
              Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
          end)
        end,
      })
      require("nvim-tree").setup(
        {
          filters = {
            dotfiles = true,
            exclude = { ".metals" }
          },
          hijack_netrw = false,
          respect_buf_cwd = true,
          renderer = {
            add_trailing = true,
            highlight_git = true,
            indent_markers = { enable = true },
            special_files = { 'Makefile', 'README.md' },
            icons = {
              git_placement = "after",
              diagnostics_placement = "after",
              modified_placement = "after",
              glyphs = {
                git = {
                  unstaged = '',
                  staged = '',
                  unmerged = '',
                  renamed = '',
                  untracked = '',
                  deleted = '',
                  ignored = '',
                },
              },
            },
          },
          git = {
            ignore = false,
          },
          view = {
            adaptive_size = true,
            width = 40,
            side = 'left',
          },
          actions = {
            file_popup = {
              open_win_config = {
                border = 'rounded',
              },
            },
          },
          on_attach = function(bufnr)
            local api = require('nvim-tree.api')

            local function opts(desc)
              return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            local git_add = function()
              local node = api.tree.get_node_under_cursor()
              local gs = node.git_status.file

              -- If the current node is a directory get children status
              if gs == nil then
                gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
                    or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
              end

              -- If the file is untracked, unstaged or partially staged, we stage it
              if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
                vim.cmd("silent !git add " .. node.absolute_path)

                -- If the file is staged, we unstage
              elseif gs == "M " or gs == "A " then
                vim.cmd("silent !git restore --staged " .. node.absolute_path)
              end

              api.tree.reload()
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set('n', '<CR>', api.node.open.no_window_picker, opts('edit'))
            vim.keymap.set('n', '<S-CR>', api.node.open.edit, opts('edit'))
            vim.keymap.set('n', 'l', api.node.open.edit, opts('open'))
            vim.keymap.set('n', '<2-LeftMouse>', api.node.open.no_window_picker, opts('open'))
            vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('close directory'))
            vim.keymap.set('n', 'H', api.tree.collapse_all, opts('close all'))
            vim.keymap.set('n', 's', git_add, opts('git un/stage'))
            vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('open horizontal'))
            vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('open vertical'))
            vim.keymap.set('n', '<M-p>', api.node.open.preview, opts('open preview'))
            vim.keymap.set('n', 'za', api.tree.toggle_hidden_filter, opts('toggle hidden files'))
            vim.keymap.set('n', 'zg', api.tree.toggle_gitignore_filter, opts('toggle git files'))
          end,
        }

      )
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "VeryLazy",
    enabled = false,
    dependencies = {
      -- "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
