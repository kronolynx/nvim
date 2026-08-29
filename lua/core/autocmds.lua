-- ============================================================================
-- Autocmds - Automatic commands triggered by events
-- ============================================================================

-- ============================================================================
-- Restore Cursor Position
-- ============================================================================
-- Return to last edit position when opening files (fixes LSP/fuzzy finder jumps)
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

-- ============================================================================
-- Window Management
-- ============================================================================
-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup('window_resize', { clear = true }),
  desc = 'Resize splits when window is resized',
  command = "wincmd =",
})

-- ============================================================================
-- File Reloading
-- ============================================================================
-- Auto-reload files when modified externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  group = vim.api.nvim_create_augroup('auto_read', { clear = true }),
  desc = 'Check for external file changes',
  command = "if mode() != 'c' | checktime | endif",
})

-- ============================================================================
-- Buffer Settings
-- ============================================================================
-- Disable editing in readonly buffers
vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('readonly_modifiable', { clear = true }),
  desc = 'Disable modifiable when readonly',
  callback = function()
    vim.bo.modifiable = not vim.bo.readonly
  end,
})

-- Auto-save on specific events
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'VimLeavePre' }, {
  group = vim.api.nvim_create_augroup('autosave', { clear = true }),
  desc = 'Auto-save modified buffers',
  callback = function()
    -- Only save normal buffers with names
    if vim.bo.buftype == "" and vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= '' then
      vim.schedule(function()
        vim.cmd 'silent! update'
      end)
    end
  end,
})

-- ============================================================================
-- Line Numbers Toggle
-- ============================================================================
-- Toggle relative line numbers based on mode/focus (excluded from terminals)
-- local line_numbers_group = vim.api.nvim_create_augroup('toggle_line_numbers', { clear = true })
--
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
--   group = line_numbers_group,
--   desc = 'Enable relative line numbers',
--   callback = function()
--     if vim.bo.buftype == 'terminal' then return end
--     if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
--       vim.wo.relativenumber = true
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
--   group = line_numbers_group,
--   desc = 'Disable relative line numbers',
--   callback = function(args)
--     if vim.bo.buftype == 'terminal' then return end
--     if vim.wo.nu then
--       vim.wo.relativenumber = false
--     end
--
--     -- Redraw to update line numbers immediately
--     if args.event == 'CmdlineEnter' then
--       if not vim.tbl_contains({ '@', '-' }, vim.v.event.cmdtype) then
--         vim.cmd.redraw()
--       end
--     end
--   end,
-- })

-- ============================================================================
-- Folding
-- ============================================================================
-- Enable Treesitter-based folding
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_folding', { clear = true }),
  desc = 'Enable Treesitter folding',
  callback = function(args)
    local bufnr = args.buf

    -- Only enable for regular files with Treesitter support
    if vim.bo[bufnr].filetype ~= 'bigfile' and pcall(vim.treesitter.start, bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.wo[0][0].foldmethod = 'expr'
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.cmd.normal 'zx'
      end)
    end
  end,
})

-- ============================================================================
-- Big File Handling
-- ============================================================================
-- Detect and mark big files (>1MB or >10k lines)
vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' }, {
  group = vim.api.nvim_create_augroup('big_file_detect', { clear = true }),
  desc = 'Detect big files and disable expensive features',
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats then
      local max_filesize = 1024 * 1024 -- 1MB
      if stats.size > max_filesize then
        vim.b[args.buf].bigfile = true
        vim.bo[args.buf].filetype = 'bigfile'
        -- Disable expensive features
        vim.bo[args.buf].swapfile = false
        vim.bo[args.buf].undofile = false
        vim.bo[args.buf].syntax = ''
        vim.opt_local.foldmethod = 'manual'
        vim.opt_local.spell = false
        vim.opt_local.cursorline = false
      end
    end
  end,
})

-- Optimize settings for big files
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('big_file', { clear = true }),
  desc = 'Optimize settings for big files',
  pattern = 'bigfile',
  callback = function(args)
    vim.schedule(function()
      vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or ''
    end)
  end,
})

-- ============================================================================
-- Visual Feedback
-- ============================================================================
-- Highlight yanked text briefly
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank_highlight', { clear = true }),
  desc = 'Highlight yanked text',
  callback = function()
    vim.hl.on_yank { higroup = 'Visual', timeout = 300 }
  end,
})

-- ============================================================================
-- Quick Close Buffers
-- ============================================================================
-- Close certain filetypes with 'q'
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  desc = 'Close with q',
  pattern = {
    'help',
    'man',
    'qf',
    'query',
    'scratch',
    'spectre_panel',
  },
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf, desc = 'Close buffer' })
  end,
})

-- ============================================================================
-- Custom Commands
-- ============================================================================
-- Grep command using ripgrep
vim.api.nvim_create_user_command('Grep', function(opts)
  vim.cmd('silent grep ' .. table.concat(opts.fargs, ' '))
  vim.cmd('redraw!')
  vim.cmd('copen')
end, {
  nargs = '+',
  complete = 'file',
  desc = 'Grep using ripgrep and populate quickfix'
})

-- Helper functions for grep
function _G.grep_word_under_cursor()
  local word = vim.fn.expand('<cword>')
  vim.cmd('Grep ' .. word)
end

function _G.prompt_grep()
  local pattern = vim.fn.input('Grep pattern: ')
  if pattern ~= '' then
    vim.cmd('Grep ' .. pattern)
  end
end
