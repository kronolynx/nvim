vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.files" },
}, { confirm = false })


vim.defer_fn(function()
  local show_dotfiles = false
  local filter_show = function(_)
    return true
  end
  local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
  end

  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    require('mini.files').refresh { content = { filter = new_filter } }
  end

  require('mini.files').setup({
    content = {
      -- Start with hiding dotfiles
      filter = filter_hide,
    },
    mappings = {
      close       = 'q',
      -- Use this if you want to open several files
      go_in       = 'l',
      -- This opens the file, but quits out of mini.files (default L)
      go_in_plus  = '<CR>',
      go_out      = 'h',
      go_out_plus = 'H',
      mark_goto   = "'",
      mark_set    = 'm',
      reset       = '<BS>',
      reveal_cwd  = '@',
      show_help   = 'g?',
      synchronize = '=',
      trim_left   = '<',
      trim_right  = '>',
    },
    -- General options
    options = {
      -- Whether to delete permanently or move into module-specific trash
      permanent_delete = false,
      -- Whether to use for editing directories
      use_as_default_explorer = true,
    },
    windows = {
      preview = true,
      width_preview = 30,
    }
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local minifiles = require('mini.files')
      local buf = args.data.buf_id

      -- close with <ESC> as well as q
      vim.keymap.set('n', '<ESC>', function()
        minifiles.close()
      end, { buffer = buf })

      -- ctrl+v to open selected buffer in a split
      vim.keymap.set('n', '<C-v>', function()
        vim.api.nvim_win_call(minifiles.get_explorer_state().target_window, function()
          vim.cmd.vsp()
          minifiles.set_target_window(vim.api.nvim_get_current_win())
        end)
        minifiles.go_in({ close_on_file = true })
      end, { desc = 'Open file in split window', buffer = buf })

      -- toggle showing dotfiles with .
      vim.keymap.set('n', '.', toggle_dotfiles, { buffer = buf })
    end,
  })

  vim.keymap.set("n", "<M-e>", function()
    if vim.bo.ft == 'minifiles' then
      require('mini.files').close()
    else
      local bufname = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.fnamemodify(bufname, ':p')

      -- Noop if the buffer isn't valid.
      if path and vim.uv.fs_stat(path) then
        require('mini.files').open(bufname, false)
      end
    end
  end, { desc = "File Explorer" })
end, 200)
