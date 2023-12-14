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
-- save
map("", "<C-s>", "<esc>:w!<cr>")

-- Sudo write
map("", "<leader>xs", ":w !sudo tee %<CR>", { noremap = true })

map("n", "<leader>fo", ":copen<cr>")
map("n", "<leader>fc", ":cclose<cr>")
map("n", "<leader>fn", ":cnext<cr>")
map("n", "<leader>fp", ":cprevious<cr>")

map("v", "<leader>p", "\"dP")

-- Smart way to move between windows
map("", "<C-j>", "<C-W>j")
map("", "<C-k>", "<C-W>k")
map("", "<C-h>", "<C-W>h")
map("", "<C-l>", "<C-W>l")
map("", "<A-,>", ":vertical res -5<cr>")
map("", "<A-.>", ":vertical res +5<cr>")
map("", "<A-lt>", ":res -5<cr>")
map("", "<A->> ", ":res +5<cr>")

-- Make many of the jump commands also center on search term
map("n", "n", "nzz", { noremap = true })
map("n", "N", "Nzz", { noremap = true })
map("n", "<C-o>", "<C-o>zz", { noremap = true })
map("n", "<C-i>", "<C-i>zz", { noremap = true })
map("n", "*", "*zz", { noremap = true })
map("n", "#", "#zz", { noremap = true })
-- This unsets the "last search pattern" register by hitting return
map("n", "<CR>", ":noh<CR><CR>", { noremap = true })
map("", "<BS>", ":nohlsearch<CR>", { silent = true })

map("n", "<C-1>", ":Neotree toggle<CR>", { noremap = true })
