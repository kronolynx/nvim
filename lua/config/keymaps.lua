local function map(mode, key, action, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, key, action, options)
end


map("i", "jj", "<ESC>")
map("v", "uu", "<ESC>")

-- Yank from cursor to end of line
map("", "Y", "y$")
-- save only when buffer has changed
map("n", "<C-s>", "<cmd>update!<cr>")
map("i", "<C-s>", "<cmd>update!<cr>")
map("v", "<C-s>", "<cmd>update!<cr>")

-- Sudo write
map("", "<leader>xs", "<cmd>w !sudo tee %<CR>", { noremap = true })

map("n", "<leader>to", "<cmd>copen<cr>")
map("n", "<leader>tc", "<cmd>cclose<cr>")
map("n", "<leader>tn", "<cmd>cnext<cr>")
map("n", "<leader>tp", "<cmd>cprevious<cr>")

map("v", "<leader>p", "\"dP")

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>[d', vim.diagnostic.open_float, { desc = 'Line diagnostics' })

-- Smart way to move between windows
map("", "<C-j>", "<C-W>j")
map("", "<C-k>", "<C-W>k")
map("", "<C-h>", "<C-W>h")
map("", "<C-l>", "<C-W>l")

-- Make many of the jump commands also center on search term
map("n", "n", "nzz", { noremap = true })
map("n", "N", "Nzz", { noremap = true })
map("n", "<C-o>", "<C-o>zz", { noremap = true })
map("n", "<C-i>", "<C-i>zz", { noremap = true })
map("n", "*", "*zz", { noremap = true })
map("n", "#", "#zz", { noremap = true })

-- This unsets the "last search pattern" register by hitting return
map("n", "<CR>", "<cmd>noh<CR><CR>", { noremap = true })
map("", "<BS>", "<cmd>nohlsearch<CR>", { silent = true })

map("n", "<C-1>", "<cmd>Neotree toggle<CR>", { noremap = true })
