vim.pack.add({ 'https://github.com/stevearc/oil.nvim' }, { load = true, confirm = false })

vim.defer_fn(function()
  require('oil').setup {
    preview = {
      border = "rounded",
    },
    view_options = {
      show_hidden = false,
    },
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["l"] = "actions.select",
      ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      -- ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-d>"] = "actions.preview_scroll_down",
      ["<C-u>"] = "actions.preview_scroll_up",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["h"] = { "actions.parent", mode = "n" },
      ["@"] = { "actions.open_cwd", mode = "n" },
      -- ["-"] = { "actions.open", mode = "n" }, -- Go to dir of current buffer file
      ["`"] = { "actions.cd", mode = "n" },
      ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    skip_confirm_for_simple_edits = false,
    -- view_options = {
    --   is_hidden_file = function(name)
    --     return vim.startswith(name, '.')
    --   end,
    -- },
    columns = { "icon" },
    float = {
      padding = 5,
      border = "rounded",
      -- max_width = 100,
    },
  }
  vim.keymap.set('n', '<M-f>', function() 
    require("oil").toggle_float()
    -- Auto-open preview after a short delay
    vim.defer_fn(function()
      require("oil.actions").preview.callback()
    end, 50)
  end, { desc = 'Oil Explorer' })
  -- Use ctrl-q to send oil selection to quickfix
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('oil-quickfix', { clear = true }),
    callback = function(args)
      vim.keymap.set({ 'n', 'v' }, '<C-q>', function()
        local oil = require 'oil'

        local line_number_start = vim.fn.line 'v'
        local line_number_end = vim.fn.line '.'

        local qf_list = {}

        for i = line_number_start, line_number_end do
          local filename = oil.get_current_dir(args.buf) .. oil.get_entry_on_line(args.buf, i).name
          table.insert(qf_list, { filename = filename })
        end

        vim.fn.setqflist({}, ' ', {
          nr = '$',
          items = qf_list,
          title = 'Oil',
        })

        oil.close()
        vim.cmd 'botright copen'
      end, { buffer = args.buf })
    end,
    pattern = { 'oil' },
  })
end, 150)
