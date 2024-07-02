-- Set text width to 80 for markdown files
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('markdown_settings', { clear = true }),
    pattern = '*.md',
    callback = function()
        vim.bo.textwidth = 80
    end
})
local filetype_settings = vim.api.nvim_create_augroup('filetype_settings', { clear = true })
-- Set wrap, linebreak, nolist, spell, spelllang, and complete options for markdown, text, and COMMIT_EDITMSG files
vim.api.nvim_create_autocmd({'BufReadPost','BufNewFile'}, {
    group = filetype_settings,
    pattern = '*.md,*.txt,COMMIT_EDITMSG',
    callback = function()
        vim.wo.wrap = true
        vim.wo.linebreak = true
        vim.wo.list = false
        vim.bo.spell = true
        vim.bo.spelllang = 'en_us'
        vim.bo.complete = vim.bo.complete .. ',kspell'
    end
})

-- Set spell and spelllang options for html, text, markdown, and adoc files
vim.api.nvim_create_autocmd({'BufReadPost','BufNewFile'}, {
    group = filetype_settings,
    pattern = '.html,*.txt,*.md,*.adoc',
    callback = function()
        vim.bo.spell = true
        vim.bo.spelllang = 'en_us'
    end
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('edit_position', { clear = true }),
    pattern = '*',
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.cmd("normal! g'\"")
        end
    end
})

vim.api.nvim_create_autocmd({'FocusLost', 'BufLeave', 'InsertLeave' }, {
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
