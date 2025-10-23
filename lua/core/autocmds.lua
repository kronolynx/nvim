-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last_location', { clear = true }),
  desc = 'Go to the last location when opening a buffer',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd 'normal! g`"zz'
    end
  end,
})

-- close quickfix menu after selecting choice
vim.api.nvim_create_autocmd(
  "FileType", {
    pattern = { "qf" },
    command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>]]
  })


-- auto-read files when modified externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- -- Remove trailing whitespace
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   desc = 'Remove trailing whitespace',
--   group = custom,
--   callback = function()
--     vim.cmd [[:%s/\s\+$//e]]
--   end,
-- })

-- Disable modifiable when readonly
vim.api.nvim_create_autocmd('BufRead',
  {
    group = vim.api.nvim_create_augroup('NoModWhenReadOnly', { clear = true }),
    pattern = '*',
    callback = function()
      vim.bo.modifiable = not vim.bo.readonly
    end,
  })

-- vim.api.nvim_create_autocmd({ "VimSuspend", "FocusLost" }, { command = "silent! update" })
--
-- vim.api.nvim_create_autocmd(
--   { "FocusLost", "ModeChanged", "TextChangedI", "BufEnter" },
--   { desc = "autosave", pattern = "*", command = "silent! update" }
-- )
--
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

-- --- TODO fix
-- Error detected while processing BufLeave Autocommands for "*":
-- Error executing lua callback: vim/_editor.lua:0: BufLeave Autocommands for "*"..script nvim_exec2() called at BufLeave Autocommands for "*":0: Vi
-- m(update):E382: Cannot write, 'buftype' option is set
-- stack traceback:
--         [C]: in function 'nvim_exec2'
--         vim/_editor.lua: in function 'cmd'
--         /Users/jortiz/.config/nvim/lua/config/autocmds.lua:19: in function </Users/jortiz/.config/nvim/lua/config/autocmds.lua:17>
-- todo fix
-- 13:21:35 msg_show Error executing lua callback: vim/_editor.lua:0: BufLeave Autocommands for "*"..script nvim_exec2() called at BufLeave Autocommands for "*":0: Vim(update):E382: Cannot write, 'buftype' option is set
-- stack traceback:
-- 	[C]: in function 'nvim_exec2'
-- 	vim/_editor.lua: in function 'cmd'
-- 	/Users/jortiz/.config/nvim/lua/config/autocmds.lua:29: in function </Users/jortiz/.config/nvim/lua/config/autocmds.lua:27>
-- vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
-- -- vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave', 'InsertLeave' }, {
--   group = vim.api.nvim_create_augroup('autosave', { clear = true }),
--   pattern = '*',
--   callback = function()
--     if vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= '' then
--       vim.cmd('silent update')
--     end
--   end
-- })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank_highlight', { clear = true }),
  desc = 'Highlight on yank',
  callback = function()
    vim.hl.on_yank { higroup = 'Visual', timeout = 300 }
  end,
})

-- When vimwindow is resized resize splits
-- cmd([[au VimResized * exe "normal! \<c-w>="]])

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

-- -- TODO move somewhere else and add keybinding
-- -- Copy text to clipboard using codeblock format ```{ft}{content}```
-- vim.api.nvim_create_user_command('CopyCodeBlock', function(opts)
--   local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
--   local content = table.concat(lines, '\n')
--   local result = string.format('```%s\n%s\n```', vim.bo.filetype, content)
--   vim.fn.setreg('+', result)
--   vim.notify 'Text copied to clipboard'
-- end, { range = true })
