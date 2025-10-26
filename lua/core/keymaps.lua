-- Remap movement keys to handle wrapped lines
vim.keymap.set('n', 'k', function()
  return vim.v.count == 0 and 'gk' or 'k'
end, { expr = true, noremap = true })

vim.keymap.set('n', 'j', function()
  return vim.v.count == 0 and 'gj' or 'j'
end, { expr = true, noremap = true })

vim.keymap.set('n', '<Up>', function()
  return vim.v.count == 0 and 'g<Up>' or '<Up>'
end, { expr = true, noremap = true })

vim.keymap.set('n', '<Down>', function()
  return vim.v.count == 0 and 'g<Down>' or '<Down>'
end, { expr = true, noremap = true })


-- Yank from cursor to end of line
vim.keymap.set('n', 'Y', 'y$')
-- save only when buffer has changed
vim.keymap.set('n', '<C-s>', '<cmd>silent update!<cr>', { noremap = true })
vim.keymap.set('i', '<C-s>', '<cmd>silent update!<cr>', { noremap = true })
vim.keymap.set('v', '<C-s>', '<cmd>silent update!<cr>', { noremap = true })

vim.keymap.set('n', '<leader>to', '<cmd>copen<cr>', { desc = 'open' })
vim.keymap.set('n', '<leader>tc', '<cmd>cclose<cr>', { desc = 'close' })
vim.keymap.set('n', '<leader>tn', '<cmd>cnext<cr>', { desc = 'next' })
vim.keymap.set('n', '<leader>tp', '<cmd>cprevious<cr>', { desc = 'previous' })

vim.keymap.set('v', '<leader>p', '"dP')
vim.keymap.set('n', '<F1>', '<Esc>')

vim.keymap.set({ 'n', 't' }, '<M-t>', function() require('core.float_term').toggle_term() end, { desc = 'toggle term' })

-- -- Done using tmux navigation
-- -- Smart way to move between windows
-- vim.keymap.set('n', '<C-j>', '<C-W>j')
-- vim.keymap.set('n', '<C-k>', '<C-W>k')
-- vim.keymap.set('n', '<C-h>', '<C-W>h')
-- vim.keymap.set('n', '<C-l>', '<C-W>l')
-- Exit terminal mode in the builtin terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Rename word under cursor using substitute command
vim.keymap.set('n', '<leader>cw', ':%s/<C-r><C-w>/', { desc = '[R]ename [W]ord' })
-- Move highlighted region up and down
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv")

-- Copy whole file
vim.keymap.set('n', '<leader>by', 'ggvG$y', { desc = '[y]ank' })
vim.keymap.set('n', '<leader>bY', 'ggvG$"+y', { desc = '[Y]ank +' })

vim.keymap.set('n', '<leader>cw', ':set wrap!<CR>', { desc = 'Toggle Wrap' })

-- Paste whole file
vim.keymap.set('n', '<leader>bp', 'ggvG$p', { desc = '[p]aste' })
vim.keymap.set('n', '<leader>bP', 'ggvG$"+p', { desc = '[P]aste +' })

-- Helpful for copy and paste
-- vim.keymap.set('x', '<leader>p', '"_dP')
-- vim.keymap.set('n', '<leader>y', '"+y')
-- vim.keymap.set('v', '<leader>y', '"+y')
-- vim.keymap.set('n', '<leader>Y', '"+Y')
-- vim.keymap.set('n', '<leader>d', '"_d')
-- vim.keymap.set('v', '<leader>d', '"_d')

vim.keymap.set('n', '<M-m>', '<C-W>x') -- swap window

-- Make many of the jump commands also center on search term
vim.keymap.set('n', 'n', 'nzz', { noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true })
vim.keymap.set('n', '<C-o>', '<C-o>zz', { noremap = true })
vim.keymap.set('n', '<C-i>', '<C-i>zz', { noremap = true })
vim.keymap.set('n', '*', '*zz', { noremap = true })
vim.keymap.set('n', '#', '#zz', { noremap = true })

-- This unsets the "last search pattern" register by hitting return
-- vim.keymap.set('n', '<CR>', '<cmd>noh<CR><CR>', { noremap = true })
-- vim.keymap.set('', '<BS>', '<cmd>nohlsearch<CR>', { silent = true })
vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<cr>')

-- navigate quicklist
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { desc = 'open' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { desc = 'close' })
vim.keymap.set('n', '<leader>qn', ':cnext<CR>', { desc = 'next' })
vim.keymap.set('n', '<leader>qp', ':cprev<CR>', { desc = 'previous' })
vim.keymap.set('n', '<leader>qf', ':cfirst<CR>', { desc = 'first' })
vim.keymap.set('n', '<leader>ql', ':clast<CR>', { desc = 'last' })
vim.keymap.set('n', '<leader>qr', ':call setqflist([], "r", {"idx": line(".")})<CR>', { desc = 'remove' })
vim.keymap.set('n', '<leader>qx', ':call setqflist([])<CR>', { desc = 'clear' })

-- grep
vim.keymap.set('n', '<leader>sg', ':lua prompt_grep()<CR>', { desc = 'grep' })
vim.keymap.set('n', '<leader>sW', ':lua grep_word_under_cursor()<CR>', { desc = 'grep word' })

vim.keymap.set('i', 'kj', '<ESC>')

if vim.g.vscode then
  -- vim.keymap.set('i', 'jj', '<ESC>')
  -- else
  local vscode = require('vscode')

  vim.keymap.set('n', '<C-H>', function() vscode.action 'workbench.action.navigateLeft' end)
  vim.keymap.set('n', '<C-J>', function() vscode.action 'workbench.action.navigateDown' end)
  vim.keymap.set('n', '<C-K>', function() vscode.action 'workbench.action.navigateUp' end)
  vim.keymap.set('n', '<C-L>', function() vscode.action 'workbench.action.navigateRight' end)

  vim.keymap.set('n', '<C-o>', function() vscode.action 'workbench.action.navigateBack' end)
  vim.keymap.set('n', '<C-i>', function() vscode.action 'workbench.action.navigateForward' end)

  vim.keymap.set('n', '<C-c>', function() vscode.action ':nohl' end)
  vim.keymap.set('n', '<S-h>', function() vscode.action 'editor.action.triggerParameterHints' end)

  -- vim.keymap.set('n', '<leader>F', function()
  --   vscode.action('editor.action.formatDocument')
  -- end)
  --
  -- vim.keymap.set('n', '<leader>fe', function()
  --   vscode.call('workbench.view.explorer')
  -- end)
  -- vim.keymap.set('n', '<leader>ff', function()
  --   vscode.call('workbench.action.quickOpen')
  -- end)

  -- VSCode extension  -- TODO translate like the ones above
  -- local vscode = require('vscode')
  -- vim.keymap.set('n', '<leader>', "require('vscode').notify('whichkey.show')<CR>", { desc = 'open' })
  --
  ---- basic actions
  -- maps.n["<Leader>q"] = function() require("vscode").action "workbench.action.closeWindow" end
  -- maps.n["<Leader>w"] = function() require("vscode").action "workbench.action.files.save" end
  -- maps.n["<Leader>n"] = function() require("vscode").action "welcome.showNewFileEntries" end
  --
  -- -- splits navigation
  -- maps.n["|"] = function() require("vscode").action "workbench.action.splitEditor" end
  -- maps.n["\\"] = function() require("vscode").action "workbench.action.splitEditorDown" end
  --
  -- -- terminal
  -- maps.n["<F7>"] = function() require("vscode").action "workbench.action.terminal.toggleTerminal" end
  -- maps.n["<C-'>"] = function() require("vscode").action "workbench.action.terminal.toggleTerminal" end
  --
  -- -- buffer management
  -- maps.n["]b"] = "<Cmd>Tabnext<CR>"
  -- maps.n["[b"] = "<Cmd>Tabprevious<CR>"
  -- maps.n["<Leader>c"] = "<Cmd>Tabclose<CR>"
  -- maps.n["<Leader>C"] = "<Cmd>Tabclose!<CR>"
  -- maps.n["<Leader>bp"] = "<Cmd>Tablast<CR>"
  --
  -- -- file explorer
  -- maps.n["<Leader>e"] = function() require("vscode").action "workbench.files.action.focusFilesExplorer" end
  -- maps.n["<Leader>o"] = function() require("vscode").action "workbench.files.action.focusFilesExplorer" end
  --
  -- -- indentation
  -- maps.v["<Tab>"] = function() require("vscode").action "editor.action.indentLines" end
  -- maps.v["<S-Tab>"] = function() require("vscode").action "editor.action.outdentLines" end
  --
  -- -- diagnostics
  -- maps.n["]d"] = function() require("vscode").action "editor.action.marker.nextInFiles" end
  -- maps.n["[d"] = function() require("vscode").action "editor.action.marker.prevInFiles" end
  --
  -- -- pickers (emulate telescope mappings)
  -- maps.n["<Leader>fc"] = function()
  --   require("vscode").action("workbench.action.findInFiles", { args = { query = vim.fn.expand "<cword>" } })
  -- end
  -- maps.n["<Leader>fC"] = function() require("vscode").action "workbench.action.showCommands" end
  -- maps.n["<Leader>ff"] = function() require("vscode").action "workbench.action.quickOpen" end
  -- maps.n["<Leader>fn"] = function() require("vscode").action "notifications.showList" end
  -- maps.n["<Leader>fo"] = function() require("vscode").action "workbench.action.openRecent" end
  -- maps.n["<Leader>ft"] = function() require("vscode").action "workbench.action.selectTheme" end
  -- maps.n["<Leader>fw"] = function() require("vscode").action "workbench.action.findInFiles" end
  --
  -- -- git client
  -- maps.n["<Leader>gg"] = function() require("vscode").action "workbench.view.scm" end
  --
  -- -- LSP Mappings
  -- maps.n["K"] = function() require("vscode").action "editor.action.showHover" end
  -- maps.n["gI"] = function() require("vscode").action "editor.action.goToImplementation" end
  -- maps.n["gd"] = function() require("vscode").action "editor.action.revealDefinition" end
  -- maps.n["gD"] = function() require("vscode").action "editor.action.revealDeclaration" end
  -- maps.n["gr"] = function() require("vscode").action "editor.action.goToReferences" end
  -- maps.n["gy"] = function() require("vscode").action "editor.action.goToTypeDefinition" end
  -- maps.n["<Leader>la"] = function() require("vscode").action "editor.action.quickFix" end
  -- maps.n["<Leader>lG"] = function() require("vscode").action "workbench.action.showAllSymbols" end
  -- maps.n["<Leader>lR"] = function() require("vscode").action "editor.action.goToReferences" end
  -- maps.n["<Leader>lr"] = function() require("vscode").action "editor.action.rename" end
  -- maps.n["<Leader>ls"] = function() require("vscode").action "workbench.action.gotoSymbol" end
  -- maps.n["<Leader>lf"] = function() require("vscode").action "editor.action.formatDocument" end
end

-- keymap("n", "<C-1>", "<cmd>Neotree toggle<CR>", { noremap = true })

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
-- -- map the function to a keybinding
-- vim.api.nvim_set_keymap('n', '<M-z>', ':lua toggle_maximize_window()<CR>', { noremap = true, silent = true })
