return {
  {
    'kyazdani42/nvim-tree.lua',
    keys = {
      {
        '<leader>ff',
        function()
          local api = require('nvim-tree.api').tree
          api.open({ focus = true, find_file = true })
        end,
        desc = 'Locate file in explorer',
      },
      {
        '<C-1>',
        function()
          require('nvim-tree.api').tree.toggle()
        end,
        desc = 'Open file explorer',
      },
      {
        '<leader>fe',
        function()
          require('nvim-tree.api').tree.toggle()
        end,
        desc = 'Open file explorer',
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
        pattern = "NvimTree_*",
        callback = function()
          local layout = vim.api.nvim_call_function("winlayout", {})
          if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
            vim.cmd("confirm quit")
          end
        end
      })
      require("nvim-tree").setup(
        {
          filters = {
            dotfiles = true,
          },
          hijack_netrw = false,
          respect_buf_cwd = true,
          renderer = {
            add_trailing = true,
            highlight_git = true,
            indent_markers = { enable = true },
            special_files = { 'Makefile', 'README.md' },
            icons = {
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

            local function edit_or_open()
              local node = api.tree.get_node_under_cursor()

              if node.nodes ~= nil then
                -- expand or collapse folder
                api.node.open.edit()
              else
                -- open file
                api.node.open.edit()
                -- Close the tree if file was opened
                api.tree.close()
              end
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

            vim.keymap.set('n', '<CR>', edit_or_open, opts('edit or open'))
            vim.keymap.set('n', 'l', api.node.open.edit, opts('open'))
            vim.keymap.set('n', '<2-LeftMouse>', edit_or_open, opts('edit or open'))
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
}
