-- https://neovide.dev/configuration.html
vim.o.guifont = "Rec Mono Duotone,Symbols Nerd Font Mono:h14"

vim.g.neovide_padding_top = 15
vim.g.neovide_padding_bottom = 5
vim.g.neovide_padding_right = 5
vim.g.neovide_padding_left = 5
vim.g.neovide_cursor_animation_length = 0

vim.keymap.set('n', '<D-s>', ':w<CR>')        -- Save
vim.keymap.set('v', '<D-c>', '"+y')           -- Copy
vim.keymap.set('n', '<D-v>', '"+P')           -- Paste normal mode
vim.keymap.set('v', '<D-v>', '"+P')           -- Paste visual mode
vim.keymap.set('c', '<D-v>', '<C-R>+')        -- Paste command mode
vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli')   -- Paste insert mode

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })
