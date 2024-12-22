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
map("n", "<C-s>", "<cmd>silent update!<cr>", { noremap = true })
map("i", "<C-s>", "<cmd>silent update!<cr>", { noremap = true })
map("v", "<C-s>", "<cmd>silent update!<cr>", { noremap = true })

map("n", "<leader>to", "<cmd>copen<cr>", { desc = "open" })
map("n", "<leader>tc", "<cmd>cclose<cr>", { desc = "close" })
map("n", "<leader>tn", "<cmd>cnext<cr>", { desc = "next" })
map("n", "<leader>tp", "<cmd>cprevious<cr>", { desc = "previous" })

map("v", "<leader>p", "\"dP")
map("n", "<F1>", "<Esc>")

-- -- Done using tmux navigation
-- -- Smart way to move between windows
-- map("", "<C-j>", "<C-W>j")
-- map("", "<C-k>", "<C-W>k")
-- map("", "<C-h>", "<C-W>h")
-- map("", "<C-l>", "<C-W>l")

-- Move highlighted region up and down
map('v', 'J', ":m '>+1<cr>gv=gv")
map('v', 'K', ":m '<-2<cr>gv=gv")

-- Helpful for copy and paste
map('x', '<leader>p', '"_dP')
map('n', '<leader>y', '"+y')
map('v', '<leader>y', '"+y')
map('n', '<leader>Y', '"+Y')
map('n', '<leader>d', '"_d')
map('v', '<leader>d', '"_d')

map("", "<M-m>", "<C-W>x") -- swap window

-- Make many of the jump commands also center on search term
map("n", "n", "nzz", { noremap = true })
map("n", "N", "Nzz", { noremap = true })
map("n", "<C-o>", "<C-o>zz", { noremap = true })
map("n", "<C-i>", "<C-i>zz", { noremap = true })
map("n", "*", "*zz", { noremap = true })
map("n", "#", "#zz", { noremap = true })

-- This unsets the "last search pattern" register by hitting return
-- map("n", "<CR>", "<cmd>noh<CR><CR>", { noremap = true })
-- map("", "<BS>", "<cmd>nohlsearch<CR>", { silent = true })
map('n', '<C-c>', '<cmd>nohlsearch<cr>')

-- navigate quicklist
map('n', '<leader>fo', ':copen<CR>', { desc = "open"})
map('n', '<leader>fc', ':cclose<CR>' , { desc = "close"})
map('n', '<leader>fn', ':cnext<CR>', { desc = "next"})
map('n', '<leader>fp', ':cprev<CR>', { desc = "previous"})
map('n', '<leader>ff', ':cfirst<CR>', { desc = "first"})
map('n', '<leader>fl', ':clast<CR>', { desc = "last"})
map('n', '<leader>fr', ':call setqflist([], "r", {"idx": line(".")})<CR>', { desc = "remove"})
map('n', '<leader>fx', ':call setqflist([])<CR>', { desc = "clear"})

-- map("n", "<C-1>", "<cmd>Neotree toggle<CR>", { noremap = true })

-- vim.b.maximize_original_width = 0
-- vim.b.maximize_original_height = 0
--
-- function toggle_maximize_window()
--   local max_width = vim.api.nvim_get_option("columns") - 10
--   local max_height = vim.api.nvim_get_option("lines")
--
--   -- if vim.api.nvim_win_get_width(0) < max_width or vim.api.nvim_win_get_height(0) < max_height then
--   if vim.api.nvim_win_get_width(0) < max_width or vim.api.nvim_win_get_height(0) < max_height then
--     -- If the current window is not maximized, store the current size and then maximize it
--     vim.b.maximize_original_width = vim.api.nvim_win_get_width(0)
--     vim.b.maximize_original_height = vim.api.nvim_win_get_height(0)
--     print("maximizing" .. vim.b.maximize_original_width .. " " .. vim.b.maximize_original_height)
--     vim.api.nvim_win_set_width(0, max_width)
--     vim.api.nvim_win_set_height(0, max_height)
--   elseif vim.b.maximize_original_width ~= 0 or vim.b.maximize_original_height ~= 0 then
--     print("restoring" .. vim.b.maximize_original_width .. " " .. vim.b.maximize_original_height)
--     -- If the current window is maximized, restore it to the original size
--     vim.api.nvim_win_set_width(0, vim.b.maximize_original_width)
--     vim.api.nvim_win_set_height(0, vim.b.maximize_original_height)
--     vim.b.maximize_original_width = 0
--     vim.b.maximize_original_height = 0
--   else
--     print("failed" .. vim.b.maximize_original_width .. (vim.b.maximize_original_width ~= 0) .. " " .. vim.b.maximize_original_height .. (vim.b.maximize_original_height ~= 0))
--   end
-- end
--
-- -- Function to toggle maximize the current window
-- -- function toggle_maximize_window()
-- --     local max_width = vim.api.nvim_get_option("columns")
-- --     local max_height = vim.api.nvim_get_option("lines")
-- --
-- --     if vim.api.nvim_win_get_width(0) < max_width or vim.api.nvim_win_get_height(0) < max_height then
-- --         -- If the current window is not maximized, maximize it
-- --         vim.api.nvim_win_set_width(0, max_width)
-- --         vim.api.nvim_win_set_height(0, max_height)
-- --     else
-- --         -- If the current window is maximized, restore it to the default size
-- --         vim.api.nvim_win_set_width(0, max_width / 2)
-- --         vim.api.nvim_win_set_height(0, max_height / 2)
-- --     end
-- -- end
--
-- -- Map the function to a keybinding
-- vim.api.nvim_set_keymap('n', '<M-z>', ':lua toggle_maximize_window()<CR>', { noremap = true, silent = true })
