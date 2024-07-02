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

vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('autosave', { clear = true }),
  pattern = '*',
  callback = function()
    if vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= '' then
      vim.cmd('silent update')
    end
  end
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank_highlight', { clear = true }),
  desc = 'Highlight on yank',
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 300 }
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
