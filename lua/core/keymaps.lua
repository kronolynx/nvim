local function keymap(mode, key, action, opts)
  local options = { noremap = false, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  -- vim.api.nvim_set_keymap(mode, key, action, options)
  vim.keymap.set(mode, key, action, options)
end



-- Yank from cursor to end of line
keymap("", "Y", "y$")
-- save only when buffer has changed
keymap("n", "<C-s>", "<cmd>silent update!<cr>", { noremap = true })
keymap("i", "<C-s>", "<cmd>silent update!<cr>", { noremap = true })
keymap("v", "<C-s>", "<cmd>silent update!<cr>", { noremap = true })

keymap("n", "<leader>to", "<cmd>copen<cr>", { desc = "open" })
keymap("n", "<leader>tc", "<cmd>cclose<cr>", { desc = "close" })
keymap("n", "<leader>tn", "<cmd>cnext<cr>", { desc = "next" })
keymap("n", "<leader>tp", "<cmd>cprevious<cr>", { desc = "previous" })

keymap("v", "<leader>p", "\"dP")
keymap("n", "<F1>", "<Esc>")

-- -- Done using tmux navigation
-- -- Smart way to move between windows
-- keymap("", "<C-j>", "<C-W>j")
-- keymap("", "<C-k>", "<C-W>k")
-- keymap("", "<C-h>", "<C-W>h")
-- keymap("", "<C-l>", "<C-W>l")

-- Move highlighted region up and down
keymap('v', 'J', ":m '>+1<cr>gv=gv")
keymap('v', 'K', ":m '<-2<cr>gv=gv")

-- Helpful for copy and paste
-- keymap('x', '<leader>p', '"_dP')
-- keymap('n', '<leader>y', '"+y')
-- keymap('v', '<leader>y', '"+y')
-- keymap('n', '<leader>Y', '"+Y')
-- keymap('n', '<leader>d', '"_d')
-- keymap('v', '<leader>d', '"_d')

keymap("", "<M-m>", "<C-W>x") -- swap window

-- Make many of the jump commands also center on search term
keymap("n", "n", "nzz", { noremap = true })
keymap("n", "N", "Nzz", { noremap = true })
keymap("n", "<C-o>", "<C-o>zz", { noremap = true })
keymap("n", "<C-i>", "<C-i>zz", { noremap = true })
keymap("n", "*", "*zz", { noremap = true })
keymap("n", "#", "#zz", { noremap = true })

-- This unsets the "last search pattern" register by hitting return
-- keymap("n", "<CR>", "<cmd>noh<CR><CR>", { noremap = true })
-- keymap("", "<BS>", "<cmd>nohlsearch<CR>", { silent = true })
keymap('n', '<C-c>', '<cmd>nohlsearch<cr>')

-- navigate quicklist
keymap('n', '<leader>qo', ':copen<CR>', { desc = "open" })
keymap('n', '<leader>qc', ':cclose<CR>', { desc = "close" })
keymap('n', '<leader>qn', ':cnext<CR>', { desc = "next" })
keymap('n', '<leader>qp', ':cprev<CR>', { desc = "previous" })
keymap('n', '<leader>qf', ':cfirst<CR>', { desc = "first" })
keymap('n', '<leader>ql', ':clast<CR>', { desc = "last" })
keymap('n', '<leader>qr', ':call setqflist([], "r", {"idx": line(".")})<CR>', { desc = "remove" })
keymap('n', '<leader>qx', ':call setqflist([])<CR>', { desc = "clear" })

-- grep
keymap('n', '<leader>sg', ":lua prompt_grep()<CR>", { desc = "grep" } )
keymap('n', '<leader>sw', ":lua grep_word_under_cursor()<CR>", { desc = "grep word" } )

if vim.g.vscode then
  -- keymap("i", "jj", "<ESC>")
-- else
  local vscode = require("vscode")

  keymap("n", "<C-H>", function() vscode.action "workbench.action.navigateLeft" end)
  keymap("n", "<C-J>", function() vscode.action "workbench.action.navigateDown" end)
  keymap("n", "<C-K>", function() vscode.action "workbench.action.navigateUp" end)
  keymap("n", "<C-L>", function() vscode.action "workbench.action.navigateRight" end)

  keymap("n", "<C-o>", function() vscode.action "workbench.action.navigateBack" end)
  keymap("n", "<C-i>", function() vscode.action "workbench.action.navigateForward" end)

  keymap("n", "<C-c>", function() vscode.action ":nohl" end)
  keymap("n", "<S-h>", function() vscode.action "editor.action.triggerParameterHints" end)

  -- keymap("n", "<leader>F", function()
  --   vscode.action("editor.action.formatDocument")
  -- end)
  --
  -- keymap("n", "<leader>fe", function()
  --   vscode.call("workbench.view.explorer")
  -- end)
  -- keymap("n", "<leader>ff", function()
  --   vscode.call("workbench.action.quickOpen")
  -- end)

  -- VSCode extension  -- TODO translate like the ones above
  -- local vscode = require('vscode')
  -- keymap('n', '<leader>', "require('vscode').notify('whichkey.show')<CR>", { desc = "open"})
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
