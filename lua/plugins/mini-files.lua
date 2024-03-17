local function map_split(buf_id, lhs, direction)
  local minifiles = require 'mini.files'

  local function rhs()
    local window = minifiles.get_target_window()

    -- Noop if the explorer isn't open or the cursor is on a directory.
    if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then
      return
    end

    -- Make a new window and set it as target.
    local new_target_window
    vim.api.nvim_win_call(window, function()
      vim.cmd(direction .. ' split')
      new_target_window = vim.api.nvim_get_current_win()
    end)

    minifiles.set_target_window(new_target_window)

    -- Go in and close the explorer.
    minifiles.go_in { close_on_file = true }
  end

  vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
end

local filter_show = function(fs_entry) return true end

local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, '.')
end

return {
  'echasnovski/mini.files',
  lazy = false,
  keys = {
    {
      '<leader>e',
      function()
        -- require "mini.files".open()
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.fnamemodify(bufname, ':p')

        -- Noop if the buffer isn't valid.
        if path and vim.loop.fs_stat(path) then
          require('mini.files').open(bufname, false)
        end
      end,
      desc = 'file explorer',
    },
    {
      '<leader>E',
      function()
        require('mini.files').open(vim.loop.cwd(), true)
      end,
      desc = 'file explorer pwd',
    },
  },
  opts = {
    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
    mappings = {
      go_in_plus  = '<cr>',
      go_out_plus = '<tab>',
      reset       = '<BS>',
      reveal_cwd  = '_',
      show_help   = 'gh',
      synchronize = '=',
    },
    content = {
      filter = filter_hide,
      sort = function(entries)
        local function compare_alphanumerically(e1, e2)
          -- Put directories first.
          if e1.is_dir and not e2.is_dir then
            return true
          end
          if not e1.is_dir and e2.is_dir then
            return false
          end
          -- Order numerically based on digits if the text before them is equal.
          if e1.pre_digits == e2.pre_digits and e1.digits ~= nil and e2.digits ~= nil then
            return e1.digits < e2.digits
          end
          -- Otherwise order alphabetically ignoring case.
          return e1.lower_name < e2.lower_name
        end

        local sorted = vim.tbl_map(function(entry)
          local pre_digits, digits = entry.name:match '^(%D*)(%d+)'
          if digits ~= nil then
            digits = tonumber(digits)
          end

          return {
            fs_type = entry.fs_type,
            name = entry.name,
            path = entry.path,
            lower_name = entry.name:lower(),
            is_dir = entry.fs_type == 'directory',
            pre_digits = pre_digits,
            digits = digits,
          }
        end, entries)
        table.sort(sorted, compare_alphanumerically)
        -- Keep only the necessary fields.
        return vim.tbl_map(function(x)
          return { name = x.name, fs_type = x.fs_type, path = x.path }
        end, sorted)
      end,
    },
    windows = {
      width_nofocus = 25,
      preview = false,
      width_preview = 80
    },
    -- Move stuff to the minifiles trash instead of it being gone forever.
    options = { permanent_delete = false },
  },
  config = function(_, opts)
    local minifiles = require 'mini.files'

    minifiles.setup(opts)

    local show_preview = false

    local toggle_preview = function()
      show_preview = not show_preview
      minifiles.refresh({ windows = { preview = show_preview } })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set('n', '<M-p>', toggle_preview, { buffer = buf_id })
      end,
    })

    local show_dotfiles = false

    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      minifiles.refresh({ content = { filter = new_filter } })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak left-hand side of mapping to your liking
        vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      desc = 'Add rounded corners to minifiles window',
      pattern = 'MiniFilesWindowOpen',
      callback = function(args)
        vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' })
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      desc = 'Add minifiles split keymaps',
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        map_split(buf_id, '<C-s>', 'belowright horizontal')
        map_split(buf_id, '<C-v>', 'belowright vertical')
      end,
    })
  end,
}
