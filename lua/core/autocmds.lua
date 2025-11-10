-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last_location', { clear = true }),
  desc = 'Go to the last location when opening a buffer',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.schedule(function()
        vim.cmd 'normal! g`"zz'
      end)
    end
  end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- -- close quickfix menu after selecting choice
-- vim.api.nvim_create_autocmd(
--   "FileType", {
--     pattern = { "qf" },
--     command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>]]
--   })

-- auto-read files when modified externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Disable modifiable when readonly
vim.api.nvim_create_autocmd('BufRead',
  {
    group = vim.api.nvim_create_augroup('NoModWhenReadOnly', { clear = true }),
    pattern = '*',
    callback = function()
      vim.bo.modifiable = not vim.bo.readonly
    end,
  })

-- Autosave on leave/focus lost
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'VimLeavePre', 'InsertLeave' }, {
  pattern = '*',
  group = vim.api.nvim_create_augroup('autosave', { clear = true }),
  callback = function()
    if vim.bo.buftype == "" and vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= '' then
      vim.schedule(function()
        vim.cmd 'silent! update'
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter_folding', { clear = true }),
    desc = 'Enable Treesitter folding',
    callback = function(args)
        local bufnr = args.buf

        -- Enable Treesitter folding when not in huge files and when Treesitter
        -- is working.
        if vim.bo[bufnr].filetype ~= 'bigfile' and pcall(vim.treesitter.start, bufnr) then
            vim.api.nvim_buf_call(bufnr, function()
                vim.wo[0][0].foldmethod = 'expr'
                vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.cmd.normal 'zx'
            end)
        end
    end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('big_file', { clear = true }),
  desc = 'Disable features in big files',
  pattern = 'bigfile',
  callback = function(args)
    vim.schedule(function()
      vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or ''
    end)
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank_highlight', { clear = true }),
  desc = 'Highlight on yank',
  callback = function()
    vim.hl.on_yank { higroup = 'Visual', timeout = 300 }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'help',
    'man',
    'qf',
    'query',
    'scratch',
    'spectre_panel',
  },
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
  end,
})


-- Function to grep the word under the cursor
function _G.grep_word_under_cursor()
  local word = vim.fn.expand('<cword>')
  vim.cmd('Grep ' .. word)
end

-- Function to prompt for grep arguments and run the Grep command
function _G.prompt_grep()
  local pattern = vim.fn.input('Grep pattern: ')
  if pattern ~= '' then
    vim.cmd('Grep ' .. pattern)
  end
end

vim.api.nvim_create_user_command('Grep', function(opts)
  vim.cmd('silent grep ' .. table.concat(opts.fargs, ' '))
  vim.cmd('redraw!')
  vim.cmd('copen')
end, { nargs = '+', complete = 'file' })
